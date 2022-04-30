// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bottino_fortino/api/api.dart';
import 'package:bottino_fortino/modules/bot/bot.dart';
import 'package:bottino_fortino/providers/providers.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'minimize_losses_bot_test.mocks.dart';
import 'test_utils.dart';

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

    when(mockMarketProvider.getAveragePrice(any, any)).thenAnswer((i) async {
      return ApiResponse(AveragePrice(1, getPriceStrategy()), 200);
    });

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
            return o.copyWith(
                status: OrderStatus.FILLED,
                cummulativeQuoteQty: o.origQty * o.price,
                executedQty: o.origQty);
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

        return ApiResponse(orderCancel, 201);
      },
    );
  });

  tearDown(() async {
    container.dispose();
    ordersCount = 0;
    orders.removeWhere((_) => true);
    getPriceStrategy = () => 0.0;
  });

  void ensureIsACleanStart(Bot bot) {
    expect(bot.testNet, isTrue);
    expect(bot.pipelineData.timer, isNull);
    expect(bot.pipelineData.lastAveragePrice, isNull);
    expect(bot.pipelineData.lastBuyOrder, isNull);
    expect(bot.pipelineData.lastSellOrder, isNull);
    expect(bot.pipelineData.lossSellOrderCounter, isZero);
    expect(bot.pipelineData.ordersHistory.orders.length, isZero);
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

    bot = TestUtils.createMinimizeLossesBot();
    container.read(pipelineProvider.notifier).addBots([bot]);

    ensureIsACleanStart(bot);

    final pipeline = container.read(pipelineProvider).first;

    fakeAsync((async) {
      pipeline.start();

      async.elapse(const Duration(seconds: 30));

      // Should be offline
      expect(bot.pipelineData.status.phase, BotPhases.offline);
      expect(bot.pipelineData.ordersHistory.orders.length, 1);
      expect(bot.pipelineData.pipelineCounter, 4);
      // Is a profit
      expect(bot.pipelineData.ordersHistory.profitsOnly.length, 1);
      // No losses
      expect(bot.pipelineData.ordersHistory.lossesOnly.length, 0);
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

    bot = TestUtils.createMinimizeLossesBot();
    container.read(pipelineProvider.notifier).addBots([bot]);

    ensureIsACleanStart(bot);

    final pipeline = container.read(pipelineProvider).first;

    fakeAsync((async) {
      pipeline.start();

      async.elapse(const Duration(seconds: 30));

      // Should be offline
      expect(bot.pipelineData.status.phase, BotPhases.offline);
      expect(bot.pipelineData.ordersHistory.orders.length, 1);
      expect(bot.pipelineData.pipelineCounter, 4);
      // Is a loss
      expect(bot.pipelineData.ordersHistory.lossesOnly.length, 1);
      // No profits
      expect(bot.pipelineData.ordersHistory.profitsOnly.length, 0);
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
      expect(bot.pipelineData.ordersHistory.orders.length, 1);
      expect(bot.pipelineData.pipelineCounter, 12);
      // Is a profit
      expect(bot.pipelineData.ordersHistory.profitsOnly.length, 1);
      // No losses
      expect(bot.pipelineData.ordersHistory.lossesOnly.length, 0);

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

    bot = TestUtils.createMinimizeLossesBot(dailyLossSellOrders: 1);
    container.read(pipelineProvider.notifier).addBots([bot]);

    ensureIsACleanStart(bot);

    final pipeline = container.read(pipelineProvider).first;

    fakeAsync((async) {
      pipeline.start();

      async.elapse(const Duration(seconds: 30));

      // Should be offline
      expect(bot.pipelineData.status.phase, BotPhases.offline);
      expect(bot.pipelineData.ordersHistory.orders.length, 1);
      expect(bot.pipelineData.pipelineCounter, 4);
      // Is a loss
      expect(bot.pipelineData.ordersHistory.lossesOnly.length, 1);
      // No profits
      expect(bot.pipelineData.ordersHistory.profitsOnly.length, 0);

      verify(mockMarketProvider.getAveragePrice(any, any));
      verify(mockTradeProvider.newOrder(any, any, any, any, any, any));
      verify(mockTradeProvider.getQueryOrder(any, any, any));
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

    bot = TestUtils.createMinimizeLossesBot();
    container.read(pipelineProvider.notifier).addBots([bot]);

    ensureIsACleanStart(bot);

    final pipeline = container.read(pipelineProvider).first;

    fakeAsync((async) {
      pipeline.start();

      async.elapse(const Duration(seconds: 30));

      // Should be offline
      expect(bot.pipelineData.status.phase, BotPhases.offline);
      expect(bot.pipelineData.ordersHistory.orders.length, 1);
      expect(bot.pipelineData.pipelineCounter, 4);
      // Is a profit
      expect(bot.pipelineData.ordersHistory.profitsOnly.length, 1);
      // No losses
      expect(bot.pipelineData.ordersHistory.lossesOnly.length, 0);

      expect(bot.pipelineData.timer, isNull);
      expect(bot.pipelineData.lastBuyOrder, isNull);
      expect(bot.pipelineData.lastSellOrder, isNull);

      pipeline.start();

      async.elapse(const Duration(seconds: 30));

      // Should be offline
      expect(bot.pipelineData.status.phase, BotPhases.offline);
      expect(bot.pipelineData.ordersHistory.orders.length, 2);
      expect(bot.pipelineData.pipelineCounter, 8);
      // Is a profit
      expect(bot.pipelineData.ordersHistory.profitsOnly.length, 1);
      // No losses
      expect(bot.pipelineData.ordersHistory.lossesOnly.length, 1);

      expect(bot.pipelineData.timer, isNull);
      expect(bot.pipelineData.lastBuyOrder, isNull);
      expect(bot.pipelineData.lastSellOrder, isNull);

      pipeline.start();

      async.elapse(const Duration(seconds: 30));

      // Should be offline
      expect(bot.pipelineData.status.phase, BotPhases.offline);
      expect(bot.pipelineData.ordersHistory.orders.length, 3);
      expect(bot.pipelineData.pipelineCounter, 12);
      // Is a profit
      expect(bot.pipelineData.ordersHistory.profitsOnly.length, 2);
      // No losses
      expect(bot.pipelineData.ordersHistory.lossesOnly.length, 1);
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

    bot = TestUtils.createMinimizeLossesBot();
    container.read(pipelineProvider.notifier).addBots([bot]);

    ensureIsACleanStart(bot);

    final pipeline = container.read(pipelineProvider).first;

    fakeAsync((async) {
      pipeline.start();

      async.elapse(const Duration(seconds: 120));

      // Should be offline
      expect(bot.pipelineData.status.phase, BotPhases.offline);
      expect(bot.pipelineData.ordersHistory.orders.length, 1);
      expect(bot.pipelineData.pipelineCounter, 13);
      // Is a profit
      expect(bot.pipelineData.ordersHistory.profitsOnly.length, 1);
      // No losses
      expect(bot.pipelineData.ordersHistory.lossesOnly.length, 0);
      // 2 cancel orders: one cancelled at 7th lap and the other at 9th lap
      // Cancelled to moving the sell order higher
      verify(mockTradeProvider.cancelOrder(any, any, any)).called(2);
    });
  });

  /// Prossimi test
  /// - test sui soldi rimanenti
  /// - partenza, stop e ripresa del bot: assicurarsi che non cambi niente
}
