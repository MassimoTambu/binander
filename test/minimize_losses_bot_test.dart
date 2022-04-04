// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bottino_fortino/api/api.dart';
import 'package:bottino_fortino/modules/bot/bot.dart';
import 'package:bottino_fortino/modules/bot/bots/minimize_losses/minimize_losses.dart';
import 'package:bottino_fortino/modules/settings/settings.dart';
import 'package:bottino_fortino/providers/providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
// import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

class MockApiProvider implements ApiProvider {
  @override
  SpotProvider get spot => MockSpotProvider(MockMarketProvider());
}

class MockSpotProvider implements SpotProvider {
  @override
  MarketProvider market;

  @override
  late TradeProvider trade;

  @override
  late WalletProvider wallet;

  MockSpotProvider(this.market);
}

class MockMarketProvider implements MarketProvider {
  @override
  ApiUtils get apiUtils => throw UnimplementedError();

  @override
  Future<ApiResponse<AveragePrice>> getAveragePrice(
      ApiConnection conn, String symbol) {
    return Future.value(const ApiResponse(AveragePrice(0, 20), 200));
  }
}

// @GenerateMocks([])
void main() {
  late DioAdapter dioAdapter;
  late ProviderContainer container;

  setUp(() async {
    // For initialize SecureStorage package
    WidgetsFlutterBinding.ensureInitialized();
    dioAdapter = DioAdapter(dio: Dio());
    container = ProviderContainer(
      overrides: [
        dioProvider.overrideWithValue(dioAdapter.dio),
        apiProvider.overrideWithValue(MockApiProvider())
      ],
    );
  });

  tearDown(() async {
    container.dispose();
  });

  test('Class initialization test', () async {
    // dioAdapter.onGet('https://testnet.binance.vision/api/v3/avgPrice',
    //     (server) {
    //   print('dio bubu');
    //   server.reply(201, {'dio merda': 'si'});
    // });

    final foo = container.read(dioProvider);

    // try {
    //   final res = await foo
    //       .get<dynamic>('https://testnet.binance.vision/api/v3/avgPrice');
    // } catch (e) {
    //   print(e.toString());
    // }

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

    final pipeline = container.read(pipelineProvider).first;

    pipeline.start();
  });
}
