import 'package:bottino_fortino/api/api.dart';
import 'package:bottino_fortino/modules/bot/bots/minimize_losses/minimize_losses.pipeline.dart';
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
import 'test_order_book.dart';
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
  var orderBook = TestOrderBook.create(orders: [], getPriceStrategy: () => 0.0);
  late MinimizeLossesPipeline pipeline;

  const double startPrice = 100.0;

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

    when(mockMarketProvider.getAveragePrice(any, any)).thenAnswer((_) async =>
        ApiResponse(AveragePrice(1, orderBook.getPriceStrategy()), 200));

    when(mockTradeProvider.getAccountInformation(any)).thenAnswer((_) async =>
        ApiResponse(
            AccountInformation(0, 0, 0, 0, true, false, false, clock.now(),
                'SPOT', wallet.balances.toList(), ['SPOT']),
            200));

    when(mockTradeProvider.newLimitOrder(any, any, OrderSides.BUY, any, any))
        .thenAnswer(
      (i) async {
        final buyOrder = orderBook.addNewLimitOrder(
          wallet,
          price: i.positionalArguments[4],
          origQty: i.positionalArguments[3],
        );

        return ApiResponse(buyOrder, 201);
      },
    );

    when(mockTradeProvider.newStopLimitOrder(
            any, any, OrderSides.SELL, any, any, any))
        .thenAnswer(
      (i) async {
        final stopSellOrder = orderBook.addNewStopLimitOrder(
          wallet,
          price: i.positionalArguments[4],
          stopPrice: i.positionalArguments[5],
          origQty: i.positionalArguments[3],
        );

        return ApiResponse(stopSellOrder, 201);
      },
    );

    when(mockTradeProvider.getQueryOrder(any, any, any)).thenAnswer(
      (i) async {
        final order = orderBook.updateOrder(wallet, i.positionalArguments[2]);
        return ApiResponse(order, 201);
      },
    );

    when(mockTradeProvider.cancelOrder(any, any, any)).thenAnswer(
      (i) async {
        final orderCancel =
            orderBook.cancelOrder(wallet, i.positionalArguments[2]);

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
    orderBook.reset();
    wallet.balances = [];
  });

  void ensureIsACleanStart(MinimizeLossesPipeline pipeline) {
    expect(pipeline.bot.testNet, isTrue);
    expect(pipeline.bot.data.timer, isNull);
    expect(pipeline.bot.data.lastAveragePrice, isNull);
    expect(pipeline.bot.data.ordersHistory.lastNotEndedRunOrders, isNull);
    expect(pipeline.bot.data.ordersHistory.runOrders.length, isZero);
    expect(pipeline.bot.data.counter, isZero);
  }

  double getAllLockedAssetFromWallet() {
    return wallet.balances
        .map((b) => b.locked)
        .fold<double>(0, (acc, g) => acc + g);
  }

  test('Submit buy order and sell order, then close sell order in profit',
      () async {
    orderBook = TestOrderBook.create(
        orders: [],
        getPriceStrategy: () {
          // First lap is for buy order submission without filling it.
          // The second one it will fill the buy order.
          // Third lap will submit a sell order.
          // Fourth lap is for trigger sell order.
          if (pipeline.bot.data.counter == 1) {
            return startPrice;
          }
          if (pipeline.bot.data.counter == 2) {
            expect(
                pipeline.bot.data.ordersHistory.lastNotEndedRunOrders?.buyOrder,
                isNotNull);
            return 99;
          }
          if (pipeline.bot.data.counter == 3) {
            expect(
                pipeline.bot.data.ordersHistory.lastNotEndedRunOrders?.buyOrder,
                isNotNull);
            expect(
                pipeline.bot.data.ordersHistory.lastNotEndedRunOrders?.buyOrder
                    ?.status,
                OrderStatus.FILLED);
            return 125;
          }

          expect(
              pipeline.bot.data.ordersHistory.lastNotEndedRunOrders?.sellOrder,
              isNotNull);
          expect(
              pipeline.bot.data.ordersHistory.lastNotEndedRunOrders?.sellOrder
                  ?.status,
              OrderStatus.NEW);
          return 120;
        });

    wallet.balances = TestUtils.fillWalletWithAccountBalances();
    final bot = TestUtils.createMinimizeLossesBot(maxInvestmentPerOrder: 200);
    container.read(pipelineProvider.notifier).addBots([bot]);

    pipeline = container
        .read(pipelineProvider)
        .whereType<MinimizeLossesPipeline>()
        .first;

    ensureIsACleanStart(pipeline);

    fakeAsync((async) {
      pipeline.start();

      async.elapse(const Duration(seconds: 30));

      // Should be offline
      expect(pipeline.bot.data.status.phase, BotPhases.offline);
      expect(pipeline.bot.data.counter, 4);
      expect(pipeline.bot.data.ordersHistory.cancelledOrders.length, 0);
      expect(pipeline.bot.data.ordersHistory.runOrders.length, 1);
      // Is a profit
      expect(pipeline.bot.data.ordersHistory.profitsOnly.length, 1);
      // No losses
      expect(pipeline.bot.data.ordersHistory.lossesOnly.length, 0);
      expect(pipeline.bot.data.ordersHistory.getTotalGains(), 42);
      final testAsset = wallet.findBalanceByAsset('USDT');
      expect(TestUtils.approxPriceToFloor(testAsset.free), 1042);
      expect(testAsset.locked, 0);
      // There should not be any locked asset
      expect(getAllLockedAssetFromWallet(), 0);
    });
  });

  test('Submit buy order and sell order, then close sell order in loss',
      () async {
    orderBook = TestOrderBook.create(
        orders: [],
        getPriceStrategy: () {
          // First lap is for buy order submission without filling it.
          // The second one it will fill the buy order.
          // Third lap the price will be lower to submitting sell order.
          // Fourth lap is for trigger sell order.
          if (pipeline.bot.data.counter == 1) return startPrice;

          if (pipeline.bot.data.counter == 2) return 99;

          if (pipeline.bot.data.counter == 3) return 90;
          return 80;
        });

    wallet.balances = TestUtils.fillWalletWithAccountBalances();
    final bot = TestUtils.createMinimizeLossesBot();
    container.read(pipelineProvider.notifier).addBots([bot]);

    pipeline = container
        .read(pipelineProvider)
        .whereType<MinimizeLossesPipeline>()
        .first;

    ensureIsACleanStart(pipeline);

    fakeAsync((async) {
      pipeline.start();

      async.elapse(const Duration(seconds: 30));

      // Should be offline
      expect(pipeline.bot.data.status.phase, BotPhases.offline);
      expect(pipeline.bot.data.counter, 4);
      expect(pipeline.bot.data.ordersHistory.cancelledOrders.length, 0);
      expect(pipeline.bot.data.ordersHistory.runOrders.length, 1);
      // Is a loss
      expect(pipeline.bot.data.ordersHistory.lossesOnly.length, 1);
      // No profits
      expect(pipeline.bot.data.ordersHistory.profitsOnly.length, 0);
      expect(pipeline.bot.data.ordersHistory.getTotalGains(), -14);
      final testAsset = wallet.findBalanceByAsset('USDT');
      expect(TestUtils.approxPriceToFloor(testAsset.free), 986);
      expect(testAsset.locked, 0);
      // There should not be any locked asset
      expect(getAllLockedAssetFromWallet(), 0);
    });
  });

  test(
      'Submit buy order, reach buy order limit, cancel buy order and submit it again with the new actual price. Then place a sell order and sell it in profit',
      () async {
    orderBook = TestOrderBook.create(
        orders: [],
        getPriceStrategy: () {
          // First lap is for buy order submission without filling it.
          // From second to eighth the price will remain the same.
          // The eighth lap the buy order will be cancelled.
          // Ninth lap will be submitted another buy order and
          // the tenth will be fill it.
          // Twelfth lap will move sell order higher than before and
          // will move the sell order.
          // From thirteenth lap the price will be lower to trigger sell price (in profit).
          if (pipeline.bot.data.counter == 1) return startPrice;
          if (pipeline.bot.data.counter <= 9) return 110;
          if (pipeline.bot.data.counter <= 10) return 109;
          if (pipeline.bot.data.counter == 12) return 125;
          return 90;
        });

    wallet.balances = TestUtils.fillWalletWithAccountBalances();
    final bot = TestUtils.createMinimizeLossesBot(
        timerBuyOrder: const Duration(minutes: 1));
    container.read(pipelineProvider.notifier).addBots([bot]);

    pipeline = container
        .read(pipelineProvider)
        .whereType<MinimizeLossesPipeline>()
        .first;

    ensureIsACleanStart(pipeline);

    fakeAsync((async) {
      // fake Datetime with clock package
      pipeline.start();

      async.elapse(const Duration(seconds: 112));

      // Should be offline
      expect(pipeline.bot.data.status.phase, BotPhases.offline);
      expect(pipeline.bot.data.counter, 13);
      expect(pipeline.bot.data.ordersHistory.cancelledOrders.length, 2);
      expect(pipeline.bot.data.ordersHistory.runOrders.length, 2);
      // Is a profit
      expect(pipeline.bot.data.ordersHistory.profitsOnly.length, 1);
      // No losses
      expect(pipeline.bot.data.ordersHistory.lossesOnly.length, 0);
      expect(pipeline.bot.data.ordersHistory.getTotalGains(), 9.53);
      final testAsset = wallet.findBalanceByAsset('USDT');
      // Approximation
      expect(TestUtils.approxPriceToFloor(testAsset.free), 1009.54);
      expect(testAsset.locked, 0);
      // There should not be any locked asset
      expect(getAllLockedAssetFromWallet(), 0);

      verify(mockTradeProvider.cancelOrder(any, any, any)).called(2);
    });
  });

  test('Reach daily loss sell order limit', () async {
    orderBook = TestOrderBook.create(
        orders: [],
        getPriceStrategy: () {
          // First lap is for buy order submission without filling it.
          // The second one it will fill the buy order.
          // Third lap the price will be lower to submitting sell order.
          // Fourth lap is for trigger sell order.
          if (pipeline.bot.data.counter == 1) return startPrice;

          if (pipeline.bot.data.counter == 2) return 99;

          if (pipeline.bot.data.counter == 3) return 90;
          return 80;
        });

    wallet.balances = TestUtils.fillWalletWithAccountBalances();
    final bot = TestUtils.createMinimizeLossesBot(dailyLossSellOrders: 1);
    container.read(pipelineProvider.notifier).addBots([bot]);

    pipeline = container
        .read(pipelineProvider)
        .whereType<MinimizeLossesPipeline>()
        .first;

    ensureIsACleanStart(pipeline);

    fakeAsync((async) {
      pipeline.start();

      async.elapse(const Duration(seconds: 30));

      // Should be offline
      expect(pipeline.bot.data.status.phase, BotPhases.offline);
      expect(pipeline.bot.data.counter, 4);
      expect(pipeline.bot.data.ordersHistory.cancelledOrders.length, 0);
      expect(pipeline.bot.data.ordersHistory.runOrders.length, 1);
      // Is a loss
      expect(pipeline.bot.data.ordersHistory.lossesOnly.length, 1);
      // No profits
      expect(pipeline.bot.data.ordersHistory.profitsOnly.length, 0);
      expect(pipeline.bot.data.ordersHistory.getTotalGains(), -14);
      final testAsset = wallet.findBalanceByAsset('USDT');
      expect(TestUtils.approxPriceToFloor(testAsset.free), 986);
      expect(testAsset.locked, 0);
      // There should not be any locked asset
      expect(getAllLockedAssetFromWallet(), 0);

      verify(mockMarketProvider.getAveragePrice(any, any));
      verify(mockTradeProvider.newLimitOrder(any, any, any, any, any));
      verify(mockTradeProvider.newStopLimitOrder(any, any, any, any, any, any));
      verify(mockTradeProvider.getQueryOrder(any, any, any));
      verify(mockTradeProvider.getAccountInformation(any));
      verifyNoMoreInteractions(mockMarketProvider);
      verifyNoMoreInteractions(mockTradeProvider);

      // try restart bot
      pipeline.start();

      async.elapse(const Duration(seconds: 5));

      expect(pipeline.bot.data.status.phase, BotPhases.error);
      expect(pipeline.bot.data.status.reason,
          contains('Daily sell loss limit reached'));
    });
  });

  test(
      'Run bot three times with the following orders history results: profit, loss, profit',
      () async {
    orderBook = TestOrderBook.create(
        orders: [],
        getPriceStrategy: () {
          // First lap is for buy order submission without filling it.
          // The second one it will fill the buy order.
          // Third lap will submit a sell order.
          // Fourth lap is for trigger sell order.
          if (pipeline.bot.data.counter == 1) return startPrice;
          if (pipeline.bot.data.counter == 2) return 99;
          if (pipeline.bot.data.counter == 3) return 125;
          if (pipeline.bot.data.counter == 4) return 120;
          // These are the laps for the 2nd bot start
          if (pipeline.bot.data.counter == 5) return startPrice;
          if (pipeline.bot.data.counter == 6) return 99;
          if (pipeline.bot.data.counter == 7) return 90;
          if (pipeline.bot.data.counter == 8) return 80;
          // 3nd bot start
          if (pipeline.bot.data.counter == 9) return startPrice;
          if (pipeline.bot.data.counter == 10) return 99;
          if (pipeline.bot.data.counter == 11) return 125;

          return 120;
        });

    wallet.balances = TestUtils.fillWalletWithAccountBalances();
    final bot = TestUtils.createMinimizeLossesBot();
    container.read(pipelineProvider.notifier).addBots([bot]);

    pipeline = container
        .read(pipelineProvider)
        .whereType<MinimizeLossesPipeline>()
        .first;

    ensureIsACleanStart(pipeline);

    fakeAsync((async) {
      pipeline.start();

      async.elapse(const Duration(seconds: 30));
      // Should be offline
      expect(pipeline.bot.data.status.phase, BotPhases.offline);
      expect(pipeline.bot.data.counter, 4);
      expect(pipeline.bot.data.ordersHistory.cancelledOrders.length, 0);
      expect(pipeline.bot.data.ordersHistory.runOrders.length, 1);
      // Is a profit
      expect(pipeline.bot.data.ordersHistory.profitsOnly.length, 1);
      // No losses
      expect(pipeline.bot.data.ordersHistory.lossesOnly.length, 0);
      expect(pipeline.bot.data.ordersHistory.getTotalGains(), 21);

      expect(pipeline.bot.data.timer, isNull);
      expect(pipeline.bot.data.ordersHistory.lastNotEndedRunOrders, isNull);

      pipeline.start();

      async.elapse(const Duration(seconds: 30));

      // Should be offline
      expect(pipeline.bot.data.status.phase, BotPhases.offline);
      expect(pipeline.bot.data.ordersHistory.runOrders.length, 2);
      expect(pipeline.bot.data.counter, 8);
      // Is a profit
      expect(pipeline.bot.data.ordersHistory.profitsOnly.length, 1);
      // No losses
      expect(pipeline.bot.data.ordersHistory.lossesOnly.length, 1);
      expect(pipeline.bot.data.ordersHistory.getTotalGains(), 7);

      expect(pipeline.bot.data.timer, isNull);
      expect(pipeline.bot.data.ordersHistory.lastNotEndedRunOrders, isNull);

      pipeline.start();

      async.elapse(const Duration(seconds: 30));

      // Should be offline
      expect(pipeline.bot.data.status.phase, BotPhases.offline);
      expect(pipeline.bot.data.ordersHistory.runOrders.length, 3);
      expect(pipeline.bot.data.counter, 12);
      // Is a profit
      expect(pipeline.bot.data.ordersHistory.profitsOnly.length, 2);
      // No losses
      expect(pipeline.bot.data.ordersHistory.lossesOnly.length, 1);
      expect(pipeline.bot.data.ordersHistory.getTotalGains(), 28);
      final testAsset = wallet.findBalanceByAsset('USDT');
      expect(TestUtils.approxPriceToFloor(testAsset.free), 1028);
      expect(testAsset.locked, 0);
      // There should not be any locked asset
      expect(getAllLockedAssetFromWallet(), 0);
    });
  });

  test(
      'Submit buy order and sell order, move sell order at 7th and 9th lap and sell it in profit at 13th lap',
      () async {
    orderBook = TestOrderBook.create(
        orders: [],
        getPriceStrategy: () {
          if (pipeline.bot.data.counter == 1) return startPrice;
          if (pipeline.bot.data.counter == 2) return 99;
          if (pipeline.bot.data.counter <= 6) return startPrice;
          if (pipeline.bot.data.counter == 7 ||
              pipeline.bot.data.counter == 8) {
            return 125;
          }
          if (pipeline.bot.data.counter <= 12) return 150;

          return 120;
        });

    wallet.balances = TestUtils.fillWalletWithAccountBalances();
    final bot = TestUtils.createMinimizeLossesBot();
    container.read(pipelineProvider.notifier).addBots([bot]);

    pipeline = container
        .read(pipelineProvider)
        .whereType<MinimizeLossesPipeline>()
        .first;

    ensureIsACleanStart(pipeline);

    fakeAsync((async) {
      pipeline.start();

      async.elapse(const Duration(seconds: 120));

      // Should be offline
      expect(pipeline.bot.data.status.phase, BotPhases.offline);
      expect(pipeline.bot.data.counter, 13);
      expect(pipeline.bot.data.ordersHistory.cancelledOrders.length, 2);
      expect(pipeline.bot.data.ordersHistory.runOrders.length, 1);
      // Is a profit
      expect(pipeline.bot.data.ordersHistory.profitsOnly.length, 1);
      // No losses
      expect(pipeline.bot.data.ordersHistory.lossesOnly.length, 0);
      expect(pipeline.bot.data.ordersHistory.getTotalGains(), 46);
      final testAsset = wallet.findBalanceByAsset('USDT');
      expect(TestUtils.approxPriceToFloor(testAsset.free), 1046);
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
    orderBook =
        TestOrderBook.create(orders: [], getPriceStrategy: () => startPrice);

    wallet.balances = TestUtils.fillWalletWithAccountBalances();
    final bot = TestUtils.createMinimizeLossesBot(symbol: 'BNB-NAZD');
    container.read(pipelineProvider.notifier).addBots([bot]);

    pipeline = container
        .read(pipelineProvider)
        .whereType<MinimizeLossesPipeline>()
        .first;

    ensureIsACleanStart(pipeline);

    fakeAsync((async) {
      pipeline.start();

      async.elapse(const Duration(seconds: 20));

      // Should be offline
      expect(pipeline.bot.data.status.phase, BotPhases.error);
      expect(pipeline.bot.data.counter, 1);
      expect(pipeline.bot.data.ordersHistory.cancelledOrders.length, 0);
      expect(pipeline.bot.data.ordersHistory.runOrders.length, 0);
      // There should not be any locked asset
      expect(getAllLockedAssetFromWallet(), 0);
      verify(mockTradeProvider.getAccountInformation(any)).called(1);
      verifyNoMoreInteractions(mockMarketProvider);
      verifyNoMoreInteractions(mockTradeProvider);
      expect(pipeline.bot.data.status.reason,
          contains('asset not found on wallet account'));
    });
  });

  test(
      'Submit buy order and sell order, stop the bot and resume it. Finally close sell order in profit',
      () async {
    orderBook = TestOrderBook.create(
        orders: [],
        getPriceStrategy: () {
          // First lap is for buy order submission without filling it.
          // The second one it will fill the buy order.
          // Third lap will submit a sell order.
          // Fourth lap is for trigger sell order.
          if (pipeline.bot.data.counter == 1) return startPrice;

          if (pipeline.bot.data.counter == 2) {
            expect(pipeline.bot.data.ordersHistory.lastNotEndedRunOrders,
                isNotNull);
            return 99;
          }
          if (pipeline.bot.data.counter == 3) {
            expect(pipeline.bot.data.ordersHistory.lastNotEndedRunOrders,
                isNotNull);
            expect(
                pipeline.bot.data.ordersHistory.lastNotEndedRunOrders?.buyOrder
                    ?.status,
                OrderStatus.FILLED);
            return 125;
          }
          if (pipeline.bot.data.counter == 4) return 120;

          return 110;
        });

    wallet.balances = TestUtils.fillWalletWithAccountBalances();
    final bot = TestUtils.createMinimizeLossesBot(maxInvestmentPerOrder: 200);
    container.read(pipelineProvider.notifier).addBots([bot]);

    pipeline = container
        .read(pipelineProvider)
        .whereType<MinimizeLossesPipeline>()
        .first;

    ensureIsACleanStart(pipeline);

    fakeAsync((async) {
      pipeline.start();

      async.elapse(const Duration(seconds: 10));

      expect(pipeline.bot.data.status.phase, BotPhases.online);
      expect(pipeline.bot.data.counter, 2);

      pipeline.pause();
      expect(pipeline.bot.data.status.phase, BotPhases.offline);
      expect(pipeline.bot.data.status.reason, contains('Paused by user'));
      expect(pipeline.bot.data.counter, 2);
      expect(pipeline.bot.data.ordersHistory.lastNotEndedRunOrders?.sellOrder,
          isNull);
      expect(
          pipeline
              .bot.data.ordersHistory.lastNotEndedRunOrders?.buyOrder?.status,
          OrderStatus.FILLED);
      expect(pipeline.bot.data.ordersHistory.runOrders.length, 1);
      //TODO Remove
      expect(pipeline.bot.data.ordersHistory.runOrders.first.sellOrder, isNull);

      async.elapse(const Duration(seconds: 20));

      pipeline.start();

      async.elapse(const Duration(seconds: 20));

      // Should be offline
      expect(pipeline.bot.data.status.phase, BotPhases.offline);
      expect(pipeline.bot.data.counter, 5);
      expect(pipeline.bot.data.ordersHistory.cancelledOrders.length, 0);
      expect(pipeline.bot.data.ordersHistory.runOrders.length, 1);
      // Is a profit
      expect(pipeline.bot.data.ordersHistory.profitsOnly.length, 1);
      // No losses
      expect(pipeline.bot.data.ordersHistory.lossesOnly.length, 0);
      expect(pipeline.bot.data.ordersHistory.getTotalGains(), 32);
      final testAsset = wallet.findBalanceByAsset('USDT');
      expect(TestUtils.approxPriceToFloor(testAsset.free), 1032);
      expect(testAsset.locked, 0);
      // There should not be any locked asset
      expect(getAllLockedAssetFromWallet(), 0);
    });
  });
}
