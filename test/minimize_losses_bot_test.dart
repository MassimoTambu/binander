import 'package:binander/src/features/settings/presentation/settings_storage_provider.dart';
import 'package:clock/clock.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:binander/src/api/api.dart';
import 'package:binander/src/features/bot/domain/bots/bot_phases.dart';
import 'package:binander/src/features/bot/domain/bots/minimize_losses/minimize_losses_pipeline.dart';
import 'package:binander/src/features/bot/presentation/pipeline_controller.dart';
import 'package:binander/src/utils/memory_storage_provider.dart';
import 'package:binander/src/utils/secure_storage_provider.dart';

import 'mocks.dart';
import 'test_order_book.dart';
import 'test_utils.dart';
import 'test_wallet.dart';

void main() {
  final mockSecureStorageProvider = MockSecureStorage();
  final mockBinanceApiProvider = MockBinanceApi();
  final mockSpotProvider = MockSpot();
  final mockMarketProvider = MockMarket();
  final mockTradeProvider = MockTrade();
  late ProviderContainer container;
  var wallet = TestWallet([]);
  var orderBook = TestOrderBook.create(orders: [], getPriceStrategy: () => 0.0);
  late MinimizeLossesPipeline pipeline;

  const double startPrice = 100.0;

  setUpAll(() {
    registerFallbackValue(FakeCryptoSimbol());
    registerFallbackValue(OrderSides.BUY);
    registerFallbackValue(OrderSides.SELL);
  });

  setUp(() async {
    // For initialize SecureStorage package
    WidgetsFlutterBinding.ensureInitialized();
    container = ProviderContainer(
      overrides: [
        secureStorageProvider.overrideWithValue(mockSecureStorageProvider),
        binanceApiProvider(TestUtils.apiConnection)
            .overrideWithValue(mockBinanceApiProvider),
      ],
    );
    // Setup memory and settings storage
    container
        .read(memoryStorageProvider.notifier)
        .load(TestUtils.memoryStorageData);
    container.read(settingsStorageProvider.notifier).state = container
        .read(settingsStorageProvider.notifier)
        .state
        .copyWith(testNetConnection: TestUtils.apiConnection);

    // Setup API providers
    when(() => mockBinanceApiProvider.spot).thenReturn(mockSpotProvider);
    when(() => mockSpotProvider.market).thenReturn(mockMarketProvider);
    when(() => mockSpotProvider.trade).thenReturn(mockTradeProvider);

    // Setup API calls

    when(() => mockMarketProvider.getAveragePrice(any())).thenAnswer(
        (_) async =>
            ApiResponse(AveragePrice(1, orderBook.getPriceStrategy()), 200));

    when(() => mockTradeProvider.getAccountInformation()).thenAnswer(
        (_) async => ApiResponse(
            AccountInformation(0, 0, 0, 0, true, false, false, clock.now(),
                'SPOT', wallet.balances.toList(), ['SPOT']),
            200));

    when(() => mockTradeProvider.newLimitOrder(
        any(), OrderSides.BUY, any(), any())).thenAnswer(
      (i) async {
        final buyOrder = orderBook.addNewLimitOrder(
          wallet,
          price: i.positionalArguments[3],
          origQty: i.positionalArguments[2],
        );

        return ApiResponse(buyOrder, 201);
      },
    );

    when(() => mockTradeProvider.newStopLimitOrder(
        any(), OrderSides.SELL, any(), any(), any())).thenAnswer(
      (i) async {
        final stopSellOrder = orderBook.addNewStopLimitOrder(
          wallet,
          price: i.positionalArguments[3],
          stopPrice: i.positionalArguments[4],
          origQty: i.positionalArguments[2],
        );

        return ApiResponse(stopSellOrder, 201);
      },
    );

    when(() => mockTradeProvider.getQueryOrder(any(), any())).thenAnswer(
      (i) async {
        final order = orderBook.updateOrder(wallet, i.positionalArguments[1]);
        return ApiResponse(order, 201);
      },
    );

    when(() => mockTradeProvider.cancelOrder(any(), any())).thenAnswer(
      (i) async {
        final orderCancel =
            orderBook.cancelOrder(wallet, i.positionalArguments[1]);

        return ApiResponse(orderCancel, 201);
      },
    );
  });

  tearDown(() {
    reset(mockSecureStorageProvider);
    reset(mockBinanceApiProvider);
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
    container.read(pipelineControllerProvider.notifier).addBots([bot]);

    pipeline = container
        .read(pipelineControllerProvider)
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
      // There should not be any() locked asset
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
    container.read(pipelineControllerProvider.notifier).addBots([bot]);

    pipeline = container
        .read(pipelineControllerProvider)
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
      // There should not be any() locked asset
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
    container.read(pipelineControllerProvider.notifier).addBots([bot]);

    pipeline = container
        .read(pipelineControllerProvider)
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
      expect(pipeline.bot.data.ordersHistory.getTotalGains(), 9.63);
      final testAsset = wallet.findBalanceByAsset('USDT');
      // Approximation
      expect(TestUtils.approxPriceToFloor(testAsset.free), 1009.63);
      expect(testAsset.locked, 0);
      // There should not be any() locked asset
      expect(getAllLockedAssetFromWallet(), 0);

      verify(() => mockTradeProvider.cancelOrder(any(), any())).called(2);
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
    container.read(pipelineControllerProvider.notifier).addBots([bot]);

    pipeline = container
        .read(pipelineControllerProvider)
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
      // There should not be any() locked asset
      expect(getAllLockedAssetFromWallet(), 0);

      verify(() => mockMarketProvider.getAveragePrice(any()));
      verify(() => mockTradeProvider.newLimitOrder(any(), any(), any(), any()));
      verify(() => mockTradeProvider.newStopLimitOrder(
          any(), any(), any(), any(), any()));
      verify(() => mockTradeProvider.getQueryOrder(any(), any()));
      verify(() => mockTradeProvider.getAccountInformation());
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
    container.read(pipelineControllerProvider.notifier).addBots([bot]);

    pipeline = container
        .read(pipelineControllerProvider)
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
      // There should not be any() locked asset
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
    container.read(pipelineControllerProvider.notifier).addBots([bot]);

    pipeline = container
        .read(pipelineControllerProvider)
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
      // There should not be any() locked asset
      expect(getAllLockedAssetFromWallet(), 0);
      // 2 cancel orders: one cancelled at 7th lap and the other at 9th lap
      // Cancelled to moving the sell order higher
      verify(() => mockTradeProvider.cancelOrder(any(), any())).called(2);
    });
  });

  test('Try to submit a buy order with an asset not stored in wallet',
      () async {
    orderBook =
        TestOrderBook.create(orders: [], getPriceStrategy: () => startPrice);

    wallet.balances = TestUtils.fillWalletWithAccountBalances();
    final bot = TestUtils.createMinimizeLossesBot(symbol: 'BNB-NAZD');
    container.read(pipelineControllerProvider.notifier).addBots([bot]);

    pipeline = container
        .read(pipelineControllerProvider)
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
      // There should not be any() locked asset
      expect(getAllLockedAssetFromWallet(), 0);
      verify(() => mockTradeProvider.getAccountInformation()).called(1);
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
    container.read(pipelineControllerProvider.notifier).addBots([bot]);

    pipeline = container
        .read(pipelineControllerProvider)
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
      // There should not be any() locked asset
      expect(getAllLockedAssetFromWallet(), 0);
    });
  });

  test(
      'With autoRestart set, submit buy order and sell order, close in profit and start another run that will finish in loss. Bot will be stopped by dailyLossSellOrders parameter',
      () async {
    orderBook = TestOrderBook.create(
        orders: [],
        getPriceStrategy: () {
          // First lap is for buy order submission without filling it.
          // The second one will fill the buy order.
          // Third lap will submit a sell order.
          // Fourth lap is for trigger sell order.
          // Fifth lap is for second buy order submission without filling it.
          // Sixth lap will fill the buy order.
          // Seventh lap will submit the second sell order.
          // Eighth lap is for trigger sell order.
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
          if (pipeline.bot.data.counter == 5) return startPrice;

          if (pipeline.bot.data.counter == 6) {
            expect(pipeline.bot.data.ordersHistory.lastNotEndedRunOrders,
                isNotNull);
            return 99;
          }
          if (pipeline.bot.data.counter == 7) {
            expect(pipeline.bot.data.ordersHistory.lastNotEndedRunOrders,
                isNotNull);
            expect(
                pipeline.bot.data.ordersHistory.lastNotEndedRunOrders?.buyOrder
                    ?.status,
                OrderStatus.FILLED);
            return 90;
          }

          return 80;
        });

    wallet.balances = TestUtils.fillWalletWithAccountBalances();
    final bot = TestUtils.createMinimizeLossesBot(
        dailyLossSellOrders: 1, autoRestart: true);
    container.read(pipelineControllerProvider.notifier).addBots([bot]);

    pipeline = container
        .read(pipelineControllerProvider)
        .whereType<MinimizeLossesPipeline>()
        .first;

    ensureIsACleanStart(pipeline);

    fakeAsync((async) {
      pipeline.start();

      async.elapse(const Duration(seconds: 80));
      expect(pipeline.bot.data.status.phase, BotPhases.error);
      expect(pipeline.bot.data.counter, 9);

      expect(pipeline.bot.data.status.reason,
          contains('Daily sell loss limit reached'));
      expect(pipeline.bot.data.ordersHistory.lastNotEndedRunOrders, isNull);

      expect(pipeline.bot.data.ordersHistory.cancelledOrders.length, 0);
      expect(pipeline.bot.data.ordersHistory.runOrders.length, 2);
      // Is a profit
      expect(pipeline.bot.data.ordersHistory.profitsOnly.length, 1);
      // No losses
      expect(pipeline.bot.data.ordersHistory.lossesOnly.length, 1);
      expect(pipeline.bot.data.ordersHistory.getTotalGains(), 7);
      final testAsset = wallet.findBalanceByAsset('USDT');
      expect(TestUtils.approxPriceToFloor(testAsset.free), 1007);
      expect(testAsset.locked, 0);
      // There should not be any() locked asset
      expect(getAllLockedAssetFromWallet(), 0);
    });
  });
}
