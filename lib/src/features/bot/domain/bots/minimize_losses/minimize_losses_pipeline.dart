import 'dart:async';

import 'package:binander/src/api/api.dart';
import 'package:binander/src/features/bot/domain/bots/bot_limit.dart';
import 'package:binander/src/features/bot/domain/bots/bot_phases.dart';
import 'package:binander/src/features/bot/domain/bots/bot_status.dart';
import 'package:binander/src/features/bot/domain/bots/minimize_losses/minimize_losses_bot.dart';
import 'package:binander/src/features/bot/domain/bots/minimize_losses/minimize_losses_pipeline_data.dart';
import 'package:binander/src/features/bot/domain/pipeline.dart';
import 'package:binander/src/features/bot/domain/roi.dart';
import 'package:binander/src/features/bot/presentation/pipeline_controller.dart';
import 'package:binander/src/features/settings/presentation/settings_storage_provider.dart';
import 'package:binander/src/utils/date_only_compare.dart';
import 'package:binander/src/utils/floor_to_double_with_decimals.dart';
import 'package:binander/src/utils/snackbar_utils.dart';

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'minimize_losses_pipeline.freezed.dart';

@freezed
class MinimizeLossesPipeline
    with _$MinimizeLossesPipeline
    implements AbsMinimizeLossesPipeline {
  const MinimizeLossesPipeline._();

  const factory MinimizeLossesPipeline(Ref ref, MinimizeLossesBot bot) =
      _MinimizeLossesPipeline;

  @override
  Future<void> start() async {
    // We can't create a status variable because with freezed
    //  if the state changes (like below) we will have the old reference
    // final status = status;

    if (bot.data.timer != null && !bot.data.timer!.isActive) return;

    _incrementPipelineCounter();

    changeStatusTo(BotPhases.starting, 'starting');

    if (bot.data.timer != null) bot.data.timer!.cancel();

    final botLimits = _getBotLimitsReached();
    if (botLimits.isNotEmpty) {
      return await shutdown(
          phase: BotPhases.error,
          reason: botLimits.map((l) => l.cause).join(" - "));
    }

    final lastBuyOrder = bot.data.ordersHistory.lastNotEndedRunOrders?.buyOrder;
    // If buyorder does not exists
    if (lastBuyOrder == null) {
      // Exit if bot execution has been interrupted
      if (bot.data.status.phase != BotPhases.starting) return;

      changeStatusTo(BotPhases.starting, 'submitting buy order');

      final accInfo = await _getAccountInformation();
      final accBalances = accInfo.balances.where(
        (b) => b.asset == bot.config.symbol!.quoteAsset,
      );
      // Asset not found in account
      if (accBalances.isEmpty) {
        return await shutdown(
            phase: BotPhases.error,
            reason: 'asset not found on wallet account');
      }

      bot.data.lastAveragePrice = await _getCurrentCryptoPrice();
      ref
          .read(pipelineControllerProvider.notifier)
          .updateBotData(bot.uuid, bot.data);

      final double rightPairQty = getRightPairQty(accBalances.first);

      await _trySubmitBuyOrder(rightPairQty);
      bot.data.buyOrderStartedAt = clock.now();
    }

    // Exit if bot execution has been interrupted
    if (bot.data.status.phase != BotPhases.starting) return;

    // Skip buyOrder pipeline if it has been filled
    if (lastBuyOrder != null && lastBuyOrder.status == OrderStatus.FILLED) {
      changeStatusTo(BotPhases.online, 'resumed');
      bot.data.timer =
          Timer.periodic(const Duration(seconds: 10), _runBotPipeline);
      return;
    }

    changeStatusTo(BotPhases.starting, 'waiting buy order to complete');

    bot.data.timer =
        Timer.periodic(const Duration(seconds: 10), _runCheckBuyOrderPipeline);
  }

  @override
  void pause() {
    bot.data.timer?.cancel();
    bot.data.timer = null;

    const message = 'Paused by user';

    changeStatusTo(BotPhases.offline, message);

    _showSnackBar(message);
  }

  @override
  Future<void> shutdown(
      {BotPhases phase = BotPhases.offline, String reason = ''}) async {
    bot.data.timer?.cancel();
    bot.data.timer = null;

    if (reason.isNotEmpty) {
      reason = ': $reason';
    }

    changeStatusTo(BotPhases.stopping, 'stopping$reason');

    // We should leave a clean environment before stopping the bot.
    // If for some reason the bot has going to stop we should cancel the opened orders
    final lastBuyOrder = bot.data.ordersHistory.lastNotEndedRunOrders?.buyOrder;
    if (lastBuyOrder != null && lastBuyOrder.status != OrderStatus.FILLED) {
      await _trySubmitCancelOrder(lastBuyOrder.orderId);
    }
    final lastSellOrder =
        bot.data.ordersHistory.lastNotEndedRunOrders?.sellOrder;
    if (lastSellOrder != null && lastSellOrder.status != OrderStatus.FILLED) {
      await _trySubmitCancelOrder(lastSellOrder.orderId);
    }

    bot.data.buyOrderStartedAt = null;
    bot.data.lastAveragePrice = null;
    bot.data.ordersHistory.closeRunOrder();

    final closingMessage = 'Turned off$reason';

    changeStatusTo(phase, closingMessage);

    _showSnackBar(closingMessage, seconds: phase == BotPhases.error ? 5 : 3);
  }

  void changeStatusTo(BotPhases phase, String message) {
    final status = BotStatus(phase, message);
    ref
        .read(pipelineControllerProvider.notifier)
        .updateBotStatus(bot.uuid, status);
  }

  void _incrementPipelineCounter() {
    bot.data.counter += 1;
  }

  List<BotLimit> _getBotLimitsReached() {
    final limits = <BotLimit>[];
    if (_hasReachDailySellLossLimit()) {
      limits.add(BotLimit(
          'Daily sell loss limit reached, max ${bot.config.dailyLossSellOrders}'));
    }

    return limits;
  }

  /// Check if buy order has been filled. If so, fetch run Bot Pipeline every 10s
  Future<void> _runCheckBuyOrderPipeline(Timer timer) async {
    // Exit if bot execution has been interrupted
    if (!timer.isActive || bot.data.status.phase != BotPhases.starting) {
      timer.cancel();
      return;
    }
    _incrementPipelineCounter();

    final expireDate =
        bot.data.buyOrderStartedAt!.add(bot.config.timerBuyOrder!);
    final dateNow = clock.now();

    if (dateNow.isAfter(expireDate)) {
      // Should retry and submit another buy order
      changeStatusTo(BotPhases.starting,
          "buy order time limit reached. I'm about to try again..");

      await _trySubmitCancelOrder(
          bot.data.ordersHistory.lastNotEndedRunOrders!.buyOrder!.orderId);
      bot.data.ordersHistory.closeRunOrder();
      bot.data.buyOrderStartedAt = null;
      timer.cancel();

      bot.data.timer =
          Timer.periodic(const Duration(seconds: 2), (_) => start());
      return;
    }

    // Update order
    bot.data.ordersHistory.upsertOrderInNotEndedRunOrder(await _getBuyOrder());

    if (bot.data.ordersHistory.lastNotEndedRunOrders!.buyOrder!.status ==
        OrderStatus.FILLED) {
      timer.cancel();

      changeStatusTo(BotPhases.online, 'buy order has been filled');

      timer = Timer.periodic(const Duration(seconds: 10), _runBotPipeline);
    }
  }

  Future<void> _runBotPipeline(Timer timer) async {
    // Exit if bot execution has been interrupted
    if (!timer.isActive || bot.data.status.phase != BotPhases.online) {
      timer.cancel();
      return;
    }
    _incrementPipelineCounter();

    bot.data.lastAveragePrice = await _getCurrentCryptoPrice();

    if (bot.data.ordersHistory.lastNotEndedRunOrders!.sellOrder == null) {
      await _trySubmitSellOrder();
      changeStatusTo(BotPhases.online, 'submitted sell order');
      return;
    }

    changeStatusTo(BotPhases.online, 'check sell order');

    final sellOrder = await _getSellOrder();
    bot.data.ordersHistory.upsertOrderInNotEndedRunOrder(sellOrder);

    // if order status is open or partially closed
    if (sellOrder.status == OrderStatus.NEW ||
        //TODO find a solution for PARTIALLY_FILLED: it could probably break a lot of things
        sellOrder.status == OrderStatus.PARTIALLY_FILLED) {
      if (_hasToMoveOrder()) {
        await _moveOrder(sellOrder.orderId);
        changeStatusTo(BotPhases.online,
            'Moved sell order to ${sellOrder.price} ${bot.config.symbol!.quoteAsset} with stop at ${sellOrder.stopPrice} ${bot.config.symbol!.quoteAsset}');
        _showSnackBar(
            'Moved sell order to ${sellOrder.stopPrice} ${bot.config.symbol!.quoteAsset} with stop at ${sellOrder.stopPrice} ${bot.config.symbol!.quoteAsset}');
      }

      return;
    }
    // If order status is closed
    else if (sellOrder.status == OrderStatus.FILLED) {
      var reason = 'Sell order executed';

      // Check if is a loss
      if (bot.data.ordersHistory.lastNotEndedRunOrders!.roi == ROI.loss) {
        // check if is major or equal to loss counter
        if (_hasReachDailySellLossLimit()) {
          reason += ' - Daily loss sell orders reached';
        }
      }

      timer.cancel();

      if (bot.config.autoRestart!) {
        bot.data.timer?.cancel();
        bot.data.timer = null;
        bot.data.buyOrderStartedAt = null;
        bot.data.lastAveragePrice = null;
        bot.data.ordersHistory.closeRunOrder();

        bot.data.timer =
            Timer.periodic(const Duration(seconds: 2), (_) => start());
        return;
      }

      return await shutdown(reason: reason);
    } else {
      // Unexpected order status:
      // CANCELED | EXPIRED | PARTIALLY_FILLED | PENDING_CANCEL | REJECTED
      // Bot will be turned off
      return await shutdown(
          reason:
              'Unexpected order status: ${sellOrder.status.name}. Bot will be turned off..');
    }
  }

  void _showSnackBar(String message, {int seconds = 3}) {
    // Add bot name to message
    message = '${bot.name} - $message';
    showSnackBarAction(message, seconds: seconds);
  }

  BinanceApi _getBinanceApi() {
    final apiConn = bot.testNet
        ? ref.read(settingsStorageProvider).testNetConnection
        : ref.read(settingsStorageProvider).pubNetConnection;
    return ref.read(binanceApiProvider(apiConn));
  }

  Future<AveragePrice> _getCurrentCryptoPrice() async {
    final res =
        await _getBinanceApi().spot.market.getAveragePrice(bot.config.symbol!);
    return res.body;
  }

  Future<AccountInformation> _getAccountInformation() async {
    final res = await _getBinanceApi().spot.trade.getAccountInformation();
    return res.body;
  }

  double getRightPairQty(AccountBalance balance) {
    if (bot.config.maxInvestmentPerOrder! > balance.free) {
      return balance.free;
    }
    return bot.config.maxInvestmentPerOrder!;
  }

  Future<void> _trySubmitBuyOrder(double rightPairQty) async {
    try {
      final newBuyOrder = await _submitBuyOrder(rightPairQty);
      final buyOrderData = (await _getBinanceApi()
              .spot
              .trade
              .getQueryOrder(bot.config.symbol!, newBuyOrder.orderId))
          .body;
      bot.data.ordersHistory.upsertOrderInNotEndedRunOrder(buyOrderData);
    } on ApiException catch (e) {
      final message = 'Failed to submit buy order | $e';

      changeStatusTo(BotPhases.error, message);

      _showSnackBar(message, seconds: 5);

      if (kDebugMode) {
        print(message);
      }

      await shutdown(phase: BotPhases.error, reason: message);
    }
  }

  /// Submit a new Buy Order with the last average price approximated
  Future<OrderNewLimit> _submitBuyOrder(double rightPairQty) async {
    final currentApproxPrice = bot.data.lastAveragePrice!.price
        .floorToDoubleWithDecimals(bot.data.orderPrecision);
    final res = await _getBinanceApi().spot.trade.newLimitOrder(
        bot.config.symbol!,
        OrderSides.BUY,
        _calculateBuyOrderQuantity(
            rightPairQty, bot.data.lastAveragePrice!.price),
        currentApproxPrice);

    return res.body;
  }

  double _calculateBuyOrderQuantity(double rightPairQty, double currentPrice) {
    final qty = rightPairQty / currentPrice;
    return qty.floorToDoubleWithDecimals(bot.data.quantityPrecision);
  }

  Future<OrderData> _getBuyOrder() async {
    final res = await _getBinanceApi().spot.trade.getQueryOrder(
        bot.config.symbol!,
        bot.data.ordersHistory.lastNotEndedRunOrders!.buyOrder!.orderId);

    return res.body;
  }

  Future<void> _trySubmitSellOrder() async {
    try {
      final stopLimitOrder = await _submitStopSellOrder();
      final sellOrderData = (await _getBinanceApi()
              .spot
              .trade
              .getQueryOrder(bot.config.symbol!, stopLimitOrder.orderId))
          .body;
      bot.data.ordersHistory.upsertOrderInNotEndedRunOrder(sellOrderData);
    } on ApiException {
      final message = '${bot.name} - Failed to submit sell order';

      changeStatusTo(BotPhases.error, message);

      _showSnackBar(message, seconds: 5);

      if (kDebugMode) {
        print(message);
      }
    }
  }

  Future<OrderNewStopLimit> _submitStopSellOrder() async {
    final price = _calculateNewOrderPrice()
        .floorToDoubleWithDecimals(bot.data.orderPrecision);
    final stopPrice = calculateNewOrderStopPriceWithProperties()
        .floorToDoubleWithDecimals(bot.data.orderPrecision);

    final res = await _getBinanceApi().spot.trade.newStopLimitOrder(
        bot.config.symbol!,
        OrderSides.SELL,
        bot.data.ordersHistory.lastNotEndedRunOrders!.buyOrder!.executedQty,
        price,
        stopPrice);
    return res.body;
  }

  Future<OrderData> _getSellOrder() async {
    final res = await _getBinanceApi().spot.trade.getQueryOrder(
        bot.config.symbol!,
        bot.data.ordersHistory.lastNotEndedRunOrders!.sellOrder!.orderId);
    return res.body;
  }

  Future<void> _moveOrder(int orderId) async {
    await _trySubmitCancelOrder(orderId);
    await _trySubmitSellOrder();
  }

  Future<void> _trySubmitCancelOrder(int orderId) async {
    try {
      final orderCancel = await _submitCancelOrder(orderId);
      final orderData = (await _getBinanceApi()
              .spot
              .trade
              .getQueryOrder(bot.config.symbol!, orderCancel.orderId))
          .body;
      bot.data.ordersHistory.lastNotEndedRunOrders?.orders.add(orderData);
    } on ApiException {
      const message = 'Failed to submit cancel order';

      changeStatusTo(BotPhases.error, message);

      _showSnackBar(message, seconds: 5);

      if (kDebugMode) {
        print(message);
      }
    }
  }

  Future<OrderCancel> _submitCancelOrder(int orderId) async {
    final res = await _getBinanceApi()
        .spot
        .trade
        .cancelOrder(bot.config.symbol!, orderId);

    return res.body;
  }

  bool _hasToMoveOrder() {
    final diffPerc = calculatePercentageOfDifference();
    return diffPerc >= MinimizeLossesPipelineData.tolerance;
  }

  double _calculateNewOrderPrice() {
    final lastBuyOrder =
        bot.data.ordersHistory.lastNotEndedRunOrders!.buyOrder!.price;
    return bot.data.lastAveragePrice!.price -
        (lastBuyOrder * (bot.config.percentageSellOrder! + 1) / 100);
  }

  /// Calculate the new sell order stop price.
  /// It could return 0 if atleast one of last buy order, last average price or
  /// percentage sell order were null
  double calculateNewOrderStopPriceWithProperties() {
    final lastBuyOrderPrice =
        bot.data.ordersHistory.lastNotEndedRunOrders?.buyOrder?.price;
    final lastAvgPrice = bot.data.lastAveragePrice?.price;
    final percentageSellOrder = bot.config.percentageSellOrder;

    return calculateNewOrderStopPrice(
      lastBuyOrderPrice: lastBuyOrderPrice,
      lastAvgPrice: lastAvgPrice,
      percentageSellOrder: percentageSellOrder,
    );
  }

  static double calculateNewOrderStopPrice({
    required double? lastAvgPrice,
    required double? lastBuyOrderPrice,
    required double? percentageSellOrder,
  }) {
    if (lastBuyOrderPrice == null ||
        lastAvgPrice == null ||
        percentageSellOrder == null) {
      return 0;
    }

    return lastAvgPrice - (lastBuyOrderPrice * percentageSellOrder / 100);
  }

  double calculatePercentageOfDifference() {
    final newStopOrderPrice = calculateNewOrderStopPriceWithProperties();
    if (newStopOrderPrice == 0) return 0;

    final sellOrder = bot.data.ordersHistory.lastNotEndedRunOrders!.sellOrder!;

    return (newStopOrderPrice * 100 / sellOrder.stopPrice!) - 100;
  }

  bool _hasReachDailySellLossLimit() {
    final sellOrdersExecutedToday = bot.data.ordersHistory.lossesOnly.where(
      (o) {
        final dateTime = o.sellOrder?.updateTime;

        if (dateTime == null) return false;

        return dateTime.isSameDate(DateTime.now());
      },
    );

    return sellOrdersExecutedToday.length >= bot.config.dailyLossSellOrders!;
  }
}
