import 'package:bottino_fortino/api/api.dart';
import 'package:bottino_fortino/modules/bot/models/bot.dart';
import 'package:bottino_fortino/modules/bot/models/bot_phases.enum.dart';
import 'package:bottino_fortino/providers/pipeline.provider.dart';
import 'package:bottino_fortino/providers/secure_storage.provider.dart';
import 'package:clock/clock.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'minimize_losses_bot_test.mocks.dart';
import 'test_utils.dart';
import 'test_wallet.dart';

@GenerateMocks([
  SecureStorageProvider,
  ApiProvider,
  SpotProvider,
  MarketProvider,
  TradeProvider
])
void main() {
  final mockSecureStorageProvider = MockSecureStorageProvider();
  final mockApiProvider = MockApiProvider();
  final mockSpotProvider = MockSpotProvider();
  final mockMarketProvider = MockMarketProvider();
  final mockTradeProvider = MockTradeProvider();
  late ProviderContainer container;
  var wallet = TestWallet([]);
  late MinimizeLossesBot bot;

  const double startPrice = 100.0;
  final List<OrderData> orders = [];
  var ordersCount = 0;
  var getPriceStrategy = () => 0.0;

  setUp(() async {
    // For initialize SecureStorage package
    WidgetsFlutterBinding.ensureInitialized();
    container = ProviderContainer(
      overrides: [
        secureStorageProvider.overrideWithValue(mockSecureStorageProvider),
        apiProvider.overrideWithValue(mockApiProvider),
      ],
    );

    // Setup API providers
    when(mockApiProvider.spot).thenReturn(mockSpotProvider);
    when(mockSpotProvider.market).thenReturn(mockMarketProvider);
    when(mockSpotProvider.trade).thenReturn(mockTradeProvider);

    // Setup API calls

    when(mockMarketProvider.getAveragePrice(any, any)).thenAnswer(
        (_) async => ApiResponse(AveragePrice(1, getPriceStrategy()), 200));

    when(mockTradeProvider.getAccountInformation(any)).thenAnswer((_) async =>
        ApiResponse(
            AccountInformation(0, 0, 0, 0, true, false, false, clock.now(),
                'SPOT', wallet.balances.toList(), ['SPOT']),
            200));

    when(mockTradeProvider.newOrder(
            any, any, OrderSides.BUY, OrderTypes.LIMIT, any, any))
        .thenAnswer(
      (i) async {
        ordersCount++;
        final buyOrder = TestUtils.createOrderNew(
            orderId: ordersCount,
            orderListId: ordersCount,
            clientOrderId: '$ordersCount',
            price: i.positionalArguments[5],
            origQty: i.positionalArguments[4],
            orderSides: OrderSides.BUY);

        wallet.balances = wallet.balances.map((b) {
          if (buyOrder.symbol.endsWith(b.asset)) {
            final cummulativeQuoteQty = buyOrder.price * buyOrder.origQty;
            return b.copyWith(
              free: b.free - cummulativeQuoteQty,
              locked: b.locked + cummulativeQuoteQty,
            );
          }
          return b;
        }).toList();

        orders.add(TestUtils.createOrderData(buyOrder));
        return ApiResponse(buyOrder, 201);
      },
    );

    when(mockTradeProvider.newOrder(
            any, any, OrderSides.SELL, OrderTypes.LIMIT, any, any))
        .thenAnswer(
      (i) async {
        ordersCount++;
        final sellOrder = TestUtils.createOrderNew(
            orderId: ordersCount,
            orderListId: ordersCount,
            clientOrderId: '$ordersCount',
            price: i.positionalArguments[5],
            origQty: i.positionalArguments[4],
            orderSides: OrderSides.SELL);

        wallet.balances = wallet.balances.map((b) {
          if (sellOrder.symbol.startsWith(b.asset)) {
            return b.copyWith(
              free: b.free - sellOrder.origQty,
              locked: b.locked + sellOrder.origQty,
            );
          }
          return b;
        }).toList();

        orders.add(TestUtils.createOrderData(sellOrder));
        return ApiResponse(sellOrder, 201);
      },
    );

    when(mockTradeProvider.getQueryOrder(any, any, any)).thenAnswer(
      (i) async {
        final order =
            orders.where((o) => o.orderId == i.positionalArguments[2]).map((o) {
          if (o.status == OrderStatus.FILLED) return o;

          final currentPrice = getPriceStrategy();
          if ((o.side == OrderSides.BUY && currentPrice >= o.price) ||
              (o.side == OrderSides.SELL && currentPrice <= o.price)) {
            final updatedOrderData = o.copyWith(
                status: OrderStatus.FILLED,
                cummulativeQuoteQty: o.origQty * o.price,
                executedQty: o.origQty);

            wallet.balances = wallet.balances.map((b) {
              // Check whether balance has been used in this order and if so update the account wallet
              if (updatedOrderData.side == OrderSides.BUY) {
                if (updatedOrderData.symbol.startsWith(b.asset)) {
                  return b.copyWith(
                      free: b.free + updatedOrderData.executedQty);
                }
                if (updatedOrderData.symbol.endsWith(b.asset)) {
                  return b.copyWith(
                      locked: b.locked - updatedOrderData.cummulativeQuoteQty);
                }
              }
              if (updatedOrderData.side == OrderSides.SELL) {
                if (updatedOrderData.symbol.startsWith(b.asset)) {
                  return b.copyWith(
                      locked: b.locked - updatedOrderData.executedQty);
                }
                if (updatedOrderData.symbol.endsWith(b.asset)) {
                  return b.copyWith(
                      free: b.free + updatedOrderData.cummulativeQuoteQty);
                }
              }

              return b;
            }).toList();

            return updatedOrderData;
          }

          return o;
        }).first;

        // Update with new OrderData
        orders.removeAt(orders.indexWhere((o) => order.orderId == o.orderId));
        orders.add(order);

        return ApiResponse(order, 201);
      },
    );

    when(mockTradeProvider.cancelOrder(any, any, any)).thenAnswer(
      (i) async {
        final orderIndex =
            orders.indexWhere((o) => o.orderId == i.positionalArguments[2]);
        final order = orders.removeAt(orderIndex);

        final orderCancel = TestUtils.createOrderCancel(order);

        wallet.balances = wallet.balances.map((b) {
          // Check whether balance has been used in this order and if so update the account wallet
          if (orderCancel.side == OrderSides.BUY) {
            if (orderCancel.symbol.endsWith(b.asset)) {
              final cummulativeQuoteQty =
                  orderCancel.price * orderCancel.origQty;
              return b.copyWith(
                  free: b.free + cummulativeQuoteQty,
                  locked: b.locked - cummulativeQuoteQty);
            }
          }
          if (orderCancel.side == OrderSides.SELL) {
            if (orderCancel.symbol.startsWith(b.asset)) {
              return b.copyWith(
                  free: b.free + orderCancel.origQty,
                  locked: b.locked - orderCancel.origQty);
            }
          }

          return b;
        }).toList();

        return ApiResponse(orderCancel, 201);
      },
    );
  });

  tearDown(() async {
    reset(mockSecureStorageProvider);
    reset(mockApiProvider);
    reset(mockSpotProvider);
    reset(mockMarketProvider);
    reset(mockTradeProvider);
    container.dispose();
    ordersCount = 0;
    orders.removeWhere((_) => true);
    getPriceStrategy = () => 0.0;
    wallet.balances = [];
  });

  void ensureIsACleanStart(Bot bot) {
    expect(bot.testNet, isTrue);
    expect(bot.pipelineData.timer, isNull);
    expect(bot.pipelineData.lastAveragePrice, isNull);
    expect(bot.pipelineData.lastBuyOrder, isNull);
    expect(bot.pipelineData.lastSellOrder, isNull);
    expect(bot.pipelineData.ordersHistory.orderPairs.length, isZero);
    expect(bot.pipelineData.pipelineCounter, isZero);
  }

  double getAllLockedAssetFromWallet() {
    return wallet.balances.map((b) => b.locked).reduce((acc, b) => acc + b);
  }

  test('Submit buy order and sell order, then close sell order in profit',
      () async {
    getPriceStrategy = () {
      // First lap is for buy order submission without filling it.
      // The second one it will fill the buy order.
      // Third lap will submit a sell order.
      // Fourth lap is for trigger sell order.
      if (bot.pipelineData.pipelineCounter == 1) {
        return startPrice;
      }
      if (bot.pipelineData.pipelineCounter == 2) {
        expect(bot.pipelineData.lastBuyOrder, isNotNull);
        return startPrice;
      }
      if (bot.pipelineData.pipelineCounter == 3) {
        expect(bot.pipelineData.lastBuyOrder, isNotNull);
        expect(bot.pipelineData.lastBuyOrder!.status, OrderStatus.FILLED);
        return 125;
      }

      expect(bot.pipelineData.lastSellOrder, isNotNull);
      expect(bot.pipelineData.lastSellOrder!.status, OrderStatus.NEW);
      return 120;
    };

    wallet.balances = TestUtils.fillWalletWithAccountBalances();
    bot = TestUtils.createMinimizeLossesBot(maxInvestmentPerOrder: 200);
    container.read(pipelineProvider.notifier).addBots([bot]);

    ensureIsACleanStart(bot);

    final pipeline = container.read(pipelineProvider).first;

    fakeAsync((async) {
      pipeline.start();

      async.elapse(const Duration(seconds: 30));

      // Should be offline
      expect(bot.pipelineData.status.phase, BotPhases.offline);
      expect(bot.pipelineData.pipelineCounter, 4);
      expect(bot.pipelineData.ordersHistory.ordersCancelled.length, 0);
      expect(bot.pipelineData.ordersHistory.orderPairs.length, 1);
      // Is a profit
      expect(bot.pipelineData.ordersHistory.profitsOnly.length, 1);
      // No losses
      expect(bot.pipelineData.ordersHistory.lossesOnly.length, 0);
      expect(bot.pipelineData.ordersHistory.getTotalGains(), 44);
      final testAsset = wallet.findBalanceByAsset('USDT');
      expect(TestUtils.approxPriceToFloor(testAsset.free), 1044);
      expect(testAsset.locked, 0);
      // There should not be any locked asset
      expect(getAllLockedAssetFromWallet(), 0);
    });
  });

  test('Submit buy order and sell order, then close sell order in loss',
      () async {
    getPriceStrategy = () {
      // First lap is for buy order submission without filling it.
      // The second one it will fill the buy order.
      // Third lap the price will be lower to submitting sell order.
      // Fourth lap is for trigger sell order.
      if (bot.pipelineData.pipelineCounter == 1 ||
          bot.pipelineData.pipelineCounter == 2) {
        return startPrice;
      }
      if (bot.pipelineData.pipelineCounter == 3) return 90;
      return 80;
    };

    wallet.balances = TestUtils.fillWalletWithAccountBalances();
    bot = TestUtils.createMinimizeLossesBot();
    container.read(pipelineProvider.notifier).addBots([bot]);

    ensureIsACleanStart(bot);

    final pipeline = container.read(pipelineProvider).first;

    fakeAsync((async) {
      pipeline.start();

      async.elapse(const Duration(seconds: 30));

      // Should be offline
      expect(bot.pipelineData.status.phase, BotPhases.offline);
      expect(bot.pipelineData.pipelineCounter, 4);
      expect(bot.pipelineData.ordersHistory.ordersCancelled.length, 0);
      expect(bot.pipelineData.ordersHistory.orderPairs.length, 1);
      // Is a loss
      expect(bot.pipelineData.ordersHistory.lossesOnly.length, 1);
      // No profits
      expect(bot.pipelineData.ordersHistory.profitsOnly.length, 0);
      expect(bot.pipelineData.ordersHistory.getTotalGains(), -13);
      final testAsset = wallet.findBalanceByAsset('USDT');
      expect(TestUtils.approxPriceToFloor(testAsset.free), 987);
      expect(testAsset.locked, 0);
      // There should not be any locked asset
      expect(getAllLockedAssetFromWallet(), 0);
    });
  });

  test(
      'Submit buy order, reach buy order limit, cancel buy order and submit it again with the new actual price. Then place a sell order and sell it in profit',
      () async {
    getPriceStrategy = () {
      // First lap is for buy order submission without filling it.
      // The second one it will fill the buy order.
      // From second to ninth the price will remain the same.
      // The ninth lap the buy order will be cancelled.
      // Tenth lap will be submitted another buy order and
      // the eleventh will be fill it.
      // From twelfth lap the price will be lower to trigger sell price (in profit).
      if (bot.pipelineData.pipelineCounter == 1) return startPrice;
      if (bot.pipelineData.pipelineCounter <= 9) return 90;
      if (bot.pipelineData.pipelineCounter <= 11) return startPrice;
      return 90;
    };

    wallet.balances = TestUtils.fillWalletWithAccountBalances();
    bot = TestUtils.createMinimizeLossesBot(
        timerBuyOrder: const Duration(minutes: 1));
    container.read(pipelineProvider.notifier).addBots([bot]);

    ensureIsACleanStart(bot);

    final pipeline = container.read(pipelineProvider).first;

    fakeAsync((async) {
      // fake Datetime with clock package
      pipeline.start();

      async.elapse(const Duration(seconds: 102));

      // Should be offline
      expect(bot.pipelineData.status.phase, BotPhases.offline);
      expect(bot.pipelineData.pipelineCounter, 12);
      expect(bot.pipelineData.ordersHistory.ordersCancelled.length, 1);
      expect(bot.pipelineData.ordersHistory.orderPairs.length, 1);
      // Is a profit
      expect(bot.pipelineData.ordersHistory.profitsOnly.length, 1);
      // No losses
      expect(bot.pipelineData.ordersHistory.lossesOnly.length, 0);
      expect(bot.pipelineData.ordersHistory.getTotalGains(), 8.1);
      final testAsset = wallet.findBalanceByAsset('USDT');
      expect(TestUtils.approxPriceToFloor(testAsset.free), 1008.1);
      expect(testAsset.locked, 0);
      // There should not be any locked asset
      expect(getAllLockedAssetFromWallet(), 0);

      verify(mockTradeProvider.cancelOrder(any, any, any)).called(1);
    });
  });

  test('Reach daily loss sell order limit', () async {
    getPriceStrategy = () {
      // First lap is for buy order submission without filling it.
      // The second one it will fill the buy order.
      // Third lap the price will be lower to submitting sell order.
      // Fourth lap is for trigger sell order.
      if (bot.pipelineData.pipelineCounter == 1 ||
          bot.pipelineData.pipelineCounter == 2) {
        return startPrice;
      }
      if (bot.pipelineData.pipelineCounter == 3) return 90;
      return 80;
    };

    wallet.balances = TestUtils.fillWalletWithAccountBalances();
    bot = TestUtils.createMinimizeLossesBot(dailyLossSellOrders: 1);
    container.read(pipelineProvider.notifier).addBots([bot]);

    ensureIsACleanStart(bot);

    final pipeline = container.read(pipelineProvider).first;

    fakeAsync((async) {
      pipeline.start();

      async.elapse(const Duration(seconds: 30));

      // Should be offline
      expect(bot.pipelineData.status.phase, BotPhases.offline);
      expect(bot.pipelineData.pipelineCounter, 4);
      expect(bot.pipelineData.ordersHistory.ordersCancelled.length, 0);
      expect(bot.pipelineData.ordersHistory.orderPairs.length, 1);
      // Is a loss
      expect(bot.pipelineData.ordersHistory.lossesOnly.length, 1);
      // No profits
      expect(bot.pipelineData.ordersHistory.profitsOnly.length, 0);
      expect(bot.pipelineData.ordersHistory.getTotalGains(), -13);
      final testAsset = wallet.findBalanceByAsset('USDT');
      expect(TestUtils.approxPriceToFloor(testAsset.free), 987);
      expect(testAsset.locked, 0);
      // There should not be any locked asset
      expect(getAllLockedAssetFromWallet(), 0);

      verify(mockMarketProvider.getAveragePrice(any, any));
      verify(mockTradeProvider.newOrder(any, any, any, any, any, any));
      verify(mockTradeProvider.getQueryOrder(any, any, any));
      verify(mockTradeProvider.getAccountInformation(any));
      verifyNoMoreInteractions(mockMarketProvider);
      verifyNoMoreInteractions(mockTradeProvider);

      // try restart bot
      pipeline.start();

      async.elapse(const Duration(seconds: 5));

      expect(bot.pipelineData.status.phase, BotPhases.error);
      expect(bot.pipelineData.status.reason,
          contains('Daily sell loss limit reached'));
    });
  });

  test(
      'Run bot three times with the following orders history results: profit, loss, profit',
      () async {
    getPriceStrategy = () {
      // First lap is for buy order submission without filling it.
      // The second one it will fill the buy order.
      // Third lap will submit a sell order.
      // Fourth lap is for trigger sell order.
      if (bot.pipelineData.pipelineCounter == 1 ||
          bot.pipelineData.pipelineCounter == 2) {
        return startPrice;
      }
      if (bot.pipelineData.pipelineCounter == 3) {
        return 125;
      }
      if (bot.pipelineData.pipelineCounter == 4) {
        return 120;
      }
      // These are the laps for the 2nd bot start
      if (bot.pipelineData.pipelineCounter == 5 ||
          bot.pipelineData.pipelineCounter == 6) {
        return startPrice;
      }
      if (bot.pipelineData.pipelineCounter == 7) return 90;
      if (bot.pipelineData.pipelineCounter == 8) return 80;
      // 3nd bot start
      if (bot.pipelineData.pipelineCounter == 9 ||
          bot.pipelineData.pipelineCounter == 10) {
        return startPrice;
      }
      if (bot.pipelineData.pipelineCounter == 11) {
        return 125;
      }

      return 120;
    };

    wallet.balances = TestUtils.fillWalletWithAccountBalances();
    bot = TestUtils.createMinimizeLossesBot();
    container.read(pipelineProvider.notifier).addBots([bot]);

    ensureIsACleanStart(bot);

    final pipeline = container.read(pipelineProvider).first;

    fakeAsync((async) {
      pipeline.start();

      async.elapse(const Duration(seconds: 30));

      // Should be offline
      expect(bot.pipelineData.status.phase, BotPhases.offline);
      expect(bot.pipelineData.pipelineCounter, 4);
      expect(bot.pipelineData.ordersHistory.ordersCancelled.length, 0);
      expect(bot.pipelineData.ordersHistory.orderPairs.length, 1);
      // Is a profit
      expect(bot.pipelineData.ordersHistory.profitsOnly.length, 1);
      // No losses
      expect(bot.pipelineData.ordersHistory.lossesOnly.length, 0);
      expect(bot.pipelineData.ordersHistory.getTotalGains(), 22);

      expect(bot.pipelineData.timer, isNull);
      expect(bot.pipelineData.lastBuyOrder, isNull);
      expect(bot.pipelineData.lastSellOrder, isNull);

      pipeline.start();

      async.elapse(const Duration(seconds: 30));

      // Should be offline
      expect(bot.pipelineData.status.phase, BotPhases.offline);
      expect(bot.pipelineData.ordersHistory.orderPairs.length, 2);
      expect(bot.pipelineData.pipelineCounter, 8);
      // Is a profit
      expect(bot.pipelineData.ordersHistory.profitsOnly.length, 1);
      // No losses
      expect(bot.pipelineData.ordersHistory.lossesOnly.length, 1);
      expect(bot.pipelineData.ordersHistory.getTotalGains(), 9);

      expect(bot.pipelineData.timer, isNull);
      expect(bot.pipelineData.lastBuyOrder, isNull);
      expect(bot.pipelineData.lastSellOrder, isNull);

      pipeline.start();

      async.elapse(const Duration(seconds: 30));

      // Should be offline
      expect(bot.pipelineData.status.phase, BotPhases.offline);
      expect(bot.pipelineData.ordersHistory.orderPairs.length, 3);
      expect(bot.pipelineData.pipelineCounter, 12);
      // Is a profit
      expect(bot.pipelineData.ordersHistory.profitsOnly.length, 2);
      // No losses
      expect(bot.pipelineData.ordersHistory.lossesOnly.length, 1);
      expect(bot.pipelineData.ordersHistory.getTotalGains(), 31);
      final testAsset = wallet.findBalanceByAsset('USDT');
      expect(TestUtils.approxPriceToFloor(testAsset.free), 1031);
      expect(testAsset.locked, 0);
      // There should not be any locked asset
      expect(getAllLockedAssetFromWallet(), 0);
    });
  });

  test(
      'Submit buy order and sell order, move sell order at 7th and 9th lap and sell it in profit at 13th lap',
      () async {
    getPriceStrategy = () {
      if (bot.pipelineData.pipelineCounter <= 6) {
        return startPrice;
      }
      if (bot.pipelineData.pipelineCounter == 7 ||
          bot.pipelineData.pipelineCounter == 8) {
        return 125;
      }
      if (bot.pipelineData.pipelineCounter <= 12) {
        return 150;
      }

      return 120;
    };

    wallet.balances = TestUtils.fillWalletWithAccountBalances();
    bot = TestUtils.createMinimizeLossesBot();
    container.read(pipelineProvider.notifier).addBots([bot]);

    ensureIsACleanStart(bot);

    final pipeline = container.read(pipelineProvider).first;

    fakeAsync((async) {
      pipeline.start();

      async.elapse(const Duration(seconds: 120));

      // Should be offline
      expect(bot.pipelineData.status.phase, BotPhases.offline);
      expect(bot.pipelineData.pipelineCounter, 13);
      expect(bot.pipelineData.ordersHistory.ordersCancelled.length, 2);
      expect(bot.pipelineData.ordersHistory.orderPairs.length, 1);
      // Is a profit
      expect(bot.pipelineData.ordersHistory.profitsOnly.length, 1);
      // No losses
      expect(bot.pipelineData.ordersHistory.lossesOnly.length, 0);
      expect(bot.pipelineData.ordersHistory.getTotalGains(), 47);
      final testAsset = wallet.findBalanceByAsset('USDT');
      expect(TestUtils.approxPriceToFloor(testAsset.free), 1047);
      expect(testAsset.locked, 0);
      // There should not be any locked asset
      expect(getAllLockedAssetFromWallet(), 0);
      // 2 cancel orders: one cancelled at 7th lap and the other at 9th lap
      // Cancelled to moving the sell order higher
      verify(mockTradeProvider.cancelOrder(any, any, any)).called(2);
    });
  });

  test('Try to submit a buy order with an asset not stored in wallet',
      () async {
    getPriceStrategy = () => startPrice;

    wallet.balances = TestUtils.fillWalletWithAccountBalances();
    bot = TestUtils.createMinimizeLossesBot(symbol: 'BNB-NAZD');
    container.read(pipelineProvider.notifier).addBots([bot]);

    ensureIsACleanStart(bot);

    final pipeline = container.read(pipelineProvider).first;

    fakeAsync((async) {
      pipeline.start();

      async.elapse(const Duration(seconds: 20));

      // Should be offline
      expect(bot.pipelineData.status.phase, BotPhases.error);
      expect(bot.pipelineData.pipelineCounter, 1);
      expect(bot.pipelineData.ordersHistory.ordersCancelled.length, 0);
      expect(bot.pipelineData.ordersHistory.orderPairs.length, 0);
      // There should not be any locked asset
      expect(getAllLockedAssetFromWallet(), 0);
      verify(mockTradeProvider.getAccountInformation(any)).called(1);
      verifyNoMoreInteractions(mockMarketProvider);
      verifyNoMoreInteractions(mockTradeProvider);
      expect(bot.pipelineData.status.reason,
          contains('asset not found on wallet account'));
    });
  });

  test(
      'Submit buy order and sell order, stop the bot and resume it. Finally close sell order in profit',
      () async {
    getPriceStrategy = () {
      // First lap is for buy order submission without filling it.
      // The second one it will fill the buy order.
      // Third lap will submit a sell order.
      // Fourth lap is for trigger sell order.
      if (bot.pipelineData.pipelineCounter == 1) {
        return startPrice;
      }
      if (bot.pipelineData.pipelineCounter == 2) {
        expect(bot.pipelineData.lastBuyOrder, isNotNull);
        return startPrice;
      }
      if (bot.pipelineData.pipelineCounter == 3) {
        expect(bot.pipelineData.lastBuyOrder, isNotNull);
        expect(bot.pipelineData.lastBuyOrder!.status, OrderStatus.FILLED);
        return 125;
      }
      if (bot.pipelineData.pipelineCounter == 4) {
        return 120;
      }

      return 110;
    };

    wallet.balances = TestUtils.fillWalletWithAccountBalances();
    bot = TestUtils.createMinimizeLossesBot(maxInvestmentPerOrder: 200);
    container.read(pipelineProvider.notifier).addBots([bot]);

    ensureIsACleanStart(bot);

    final pipeline = container.read(pipelineProvider).first;

    fakeAsync((async) {
      pipeline.start();

      async.elapse(const Duration(seconds: 10));

      expect(bot.pipelineData.status.phase, BotPhases.online);
      expect(bot.pipelineData.pipelineCounter, 2);

      pipeline.pause();
      expect(bot.pipelineData.status.phase, BotPhases.offline);
      expect(bot.pipelineData.status.reason, contains('Paused by user'));
      expect(bot.pipelineData.pipelineCounter, 2);
      expect(bot.pipelineData.lastSellOrder, isNull);
      expect(bot.pipelineData.lastBuyOrder?.status, OrderStatus.FILLED);
      expect(bot.pipelineData.ordersHistory.orderPairs.length, 0);

      async.elapse(const Duration(seconds: 20));

      pipeline.start();

      async.elapse(const Duration(seconds: 20));

      // Should be offline
      expect(bot.pipelineData.status.phase, BotPhases.offline);
      expect(bot.pipelineData.pipelineCounter, 5);
      expect(bot.pipelineData.ordersHistory.ordersCancelled.length, 0);
      expect(bot.pipelineData.ordersHistory.orderPairs.length, 1);
      // Is a profit
      expect(bot.pipelineData.ordersHistory.profitsOnly.length, 1);
      // No losses
      expect(bot.pipelineData.ordersHistory.lossesOnly.length, 0);
      expect(bot.pipelineData.ordersHistory.getTotalGains(), 34);
      final testAsset = wallet.findBalanceByAsset('USDT');
      expect(TestUtils.approxPriceToFloor(testAsset.free), 1034);
      expect(testAsset.locked, 0);
      // There should not be any locked asset
      expect(getAllLockedAssetFromWallet(), 0);
    });
  });
}
