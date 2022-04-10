// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bottino_fortino/api/api.dart';
import 'package:bottino_fortino/modules/bot/bot.dart';
import 'package:bottino_fortino/modules/bot/bots/minimize_losses/minimize_losses.dart';
import 'package:bottino_fortino/providers/providers.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import 'minimize_losses_bot_test.mocks.dart';

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
  });

  tearDown(() async {
    container.dispose();
  });

  test('Submit buy order and sell order, then close sell order in profit',
      () async {
    // Set api calls for providers
    const startPrice = 100.0;
    // Trend crypto prices
    final prices = [
      const AveragePrice(1, startPrice),
      const AveragePrice(1, 125),
      const AveragePrice(1, 120),
    ];
    final List<OrderData> orders = [];
    when(mockMarketProvider.getAveragePrice(any, any)).thenAnswer(
      (_) async => ApiResponse(prices.removeAt(0), 200),
    );

    when(mockTradeProvider.newOrder(
            any, any, OrderSides.BUY, OrderTypes.LIMIT, any, any))
        .thenAnswer(
      (i) async {
        final buyOrder = OrderNew(
            'BNBUSDT',
            1,
            12,
            '1',
            DateTime.now(),
            i.positionalArguments[5],
            i.positionalArguments[4],
            0,
            0,
            OrderStatus.NEW,
            TimeInForce.GTC,
            OrderTypes.LIMIT,
            OrderSides.BUY,
            const [Fill(startPrice, 99, 1, 'USDT', 52)]);

        orders.add(OrderData(
            buyOrder.symbol,
            buyOrder.orderId,
            buyOrder.orderListId,
            buyOrder.clientOrderId,
            buyOrder.price,
            buyOrder.origQty,
            buyOrder.executedQty,
            buyOrder.cummulativeQuoteQty,
            buyOrder.status,
            buyOrder.timeInForce,
            buyOrder.type,
            buyOrder.side,
            0,
            0,
            DateTime.now(),
            DateTime.now(),
            true,
            0));
        return ApiResponse(buyOrder, 201);
      },
    );

    when(mockTradeProvider.newOrder(
            any, any, OrderSides.SELL, OrderTypes.LIMIT, any, any))
        .thenAnswer(
      (i) async {
        final sellOrder = OrderNew(
            'BNBUSDT',
            2,
            13,
            '2',
            DateTime.now(),
            i.positionalArguments[5],
            i.positionalArguments[4],
            0,
            0,
            OrderStatus.NEW,
            TimeInForce.GTC,
            OrderTypes.LIMIT,
            OrderSides.BUY,
            const [Fill(startPrice, 99, 1, 'USDT', 52)]);

        orders.add(OrderData(
            sellOrder.symbol,
            sellOrder.orderId,
            sellOrder.orderListId,
            sellOrder.clientOrderId,
            sellOrder.price,
            sellOrder.origQty,
            sellOrder.executedQty,
            sellOrder.cummulativeQuoteQty,
            sellOrder.status,
            sellOrder.timeInForce,
            sellOrder.type,
            sellOrder.side,
            0,
            0,
            DateTime.now(),
            DateTime.now(),
            true,
            0));
        return ApiResponse(sellOrder, 201);
      },
    );

    when(mockTradeProvider.getQueryOrder(any, any, any)).thenAnswer(
      (i) async {
        final order = orders
            .where((o) => o.orderId == i.positionalArguments[2])
            .map((o) => o.copyWith(
                status: OrderStatus.FILLED,
                cummulativeQuoteQty: o.origQty,
                executedQty: o.origQty))
            .first;

        return ApiResponse(order, 201);
      },
    );

    final bot = Bot.minimizeLosses(
      const Uuid().v4(),
      MinimizeLossesPipeLineData(),
      name: "BOB",
      testNet: true,
      config: MinimizeLossesConfig(
        symbol: "BNBUSDT",
        dailyLossSellOrders: 3,
        maxQuantityPerOrder: 100,
        percentageSellOrder: 3,
        timerBuyOrder: const Duration(minutes: 30),
      ),
    );
    container.read(pipelineProvider.notifier).addBots([bot]);

    // Ensure is a clean start
    expect(bot.testNet, isTrue);
    expect(bot.pipelineData.timer, isNull);
    expect(bot.pipelineData.lastAveragePrice, isNull);
    expect(bot.pipelineData.lastBuyOrder, isNull);
    expect(bot.pipelineData.lastSellOrder, isNull);
    expect(bot.pipelineData.lossSellOrderCounter, isZero);
    expect(bot.pipelineData.ordersHistory.orders.length, isZero);

    final pipeline = container.read(pipelineProvider).first;

    fakeAsync((async) {
      pipeline.start();

      async.elapse(const Duration(seconds: 120));

      // Should be offline
      expect(bot.pipelineData.status.phase, BotPhases.offline);
      expect(bot.pipelineData.ordersHistory.orders.length, 1);
      // Is a profit
      expect(bot.pipelineData.lossSellOrderCounter, 0);
    });

    /// Prossimi test
    /// - con un ordine in perdita
    /// - con limite "giornaliero" di ordini in perdita raggiunto
    /// - con il seguente ordine: 1 ordine in profitto, 1 in perdita e 1 in profitto
    /// - con 13 giri cicli senza vendere e poi vendita in profitto spostando il sell order al 7° e 9° ciclo
  });
}
