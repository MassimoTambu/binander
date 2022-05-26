import 'package:bottino_fortino/api/api.dart';
import 'package:bottino_fortino/models/crypto_symbol.dart';
import 'package:bottino_fortino/modules/bot/bots/minimize_losses/minimize_losses.config.dart';
import 'package:bottino_fortino/modules/bot/bots/minimize_losses/minimize_losses.pipeline_data.dart';
import 'package:bottino_fortino/modules/bot/models/bot.dart';
import 'package:bottino_fortino/modules/bot/models/orders_history.dart';
import 'package:clock/clock.dart';
import 'package:uuid/uuid.dart';

class TestUtils {
  static const defaultSymbol = 'BNB-USDT';

  static List<AccountBalance> fillWalletWithAccountBalances() => [
        const AccountBalance('BTC', 10, 0),
        const AccountBalance('BNB', 300, 0),
        const AccountBalance('USDT', 1000, 0),
        const AccountBalance('BUSD', 5000, 0),
        const AccountBalance('ADA', 15000, 0),
      ];

  static MinimizeLossesBot createMinimizeLossesBot({
    String name = "CABAL",
    String symbol = defaultSymbol,
    int dailyLossSellOrders = 3,
    double maxInvestmentPerOrder = 100,
    double percentageSellOrder = 3,
    Duration timerBuyOrder = const Duration(minutes: 30),
    bool autoRestart = false,
  }) =>
      MinimizeLossesBot(
        const Uuid().v4(),
        MinimizeLossesPipelineData(
          ordersHistory: OrdersHistory([]),
          symbolPrecision: 8,
        ),
        name: name,
        testNet: true,
        config: MinimizeLossesConfig.create(
          symbol: CryptoSymbol(symbol),
          dailyLossSellOrders: dailyLossSellOrders,
          maxInvestmentPerOrder: maxInvestmentPerOrder,
          percentageSellOrder: percentageSellOrder,
          timerBuyOrder: timerBuyOrder,
          autoRestart: autoRestart,
        ),
      );

  static OrderNewLimit createOrderNewLimit({
    String symbol = defaultSymbol,
    int orderId = 1,
    int orderListId = 1,
    String clientOrderId = '1',
    required double price,
    required double origQty,
    required OrderSides orderSides,
  }) {
    final cryptoSymbol = CryptoSymbol(symbol);
    return OrderNewLimit(
        cryptoSymbol.toString(),
        orderId,
        orderListId,
        clientOrderId,
        clock.now(),
        price,
        origQty,
        0,
        0,
        OrderStatus.NEW,
        TimeInForce.GTC,
        OrderTypes.LIMIT,
        orderSides,
        [Fill(price, origQty, 0, cryptoSymbol.quoteAsset, orderId)]);
  }

  static OrderNewStopLimit createOrderNewStopLimit({
    String symbol = defaultSymbol,
    int orderId = 1,
    int orderListId = 1,
    String clientOrderId = '1',
  }) {
    final cryptoSymbol = CryptoSymbol(symbol);
    return OrderNewStopLimit.newStopLimit(
      cryptoSymbol.toString(),
      orderId,
      orderListId,
      clientOrderId,
      clock.now(),
    );
  }

  static OrderData createOrderDataFromNewLimit(OrderNewLimit orderNew) =>
      OrderData(
          orderNew.symbol,
          orderNew.orderId,
          orderNew.orderListId,
          orderNew.clientOrderId,
          orderNew.price,
          null,
          orderNew.origQty,
          orderNew.executedQty,
          orderNew.cummulativeQuoteQty,
          orderNew.status,
          orderNew.timeInForce,
          orderNew.type,
          orderNew.side,
          0,
          clock.now(),
          clock.now(),
          true,
          0);

  static OrderData createOrderDataFromNewStopLimit(
    OrderNewStopLimit orderNew,
    double price,
    double stopPrice,
    double origQty,
    OrderSides side, {
    double executedQty = 0,
    double cummulativeQuoteQty = 0,
    OrderStatus status = OrderStatus.NEW,
    TimeInForce timeInForce = TimeInForce.GTC,
  }) =>
      OrderData(
          orderNew.symbol,
          orderNew.orderId,
          orderNew.orderListId,
          orderNew.clientOrderId,
          price,
          stopPrice,
          origQty,
          executedQty,
          cummulativeQuoteQty,
          status,
          timeInForce,
          OrderTypes.STOP_LOSS_LIMIT,
          side,
          0,
          clock.now(),
          clock.now(),
          true,
          0);

  static OrderCancel createOrderCancel(OrderData order) => OrderCancel(
      order.symbol,
      order.orderId,
      order.orderListId,
      order.clientOrderId,
      order.clientOrderId,
      order.price,
      null,
      order.origQty,
      order.executedQty,
      order.cummulativeQuoteQty,
      OrderStatus.CANCELED,
      order.timeInForce,
      order.type,
      order.side);

  static double approxPriceToFloor(double price) =>
      (price * 100).floorToDouble() / 100;
}
