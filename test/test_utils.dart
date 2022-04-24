import 'package:bottino_fortino/api/api.dart';
import 'package:bottino_fortino/modules/bot/bot.dart';
import 'package:bottino_fortino/modules/bot/bots/minimize_losses/minimize_losses.dart';
import 'package:clock/clock.dart';
import 'package:uuid/uuid.dart';

class TestUtils {
  static const String defaultSymbol = "BNBUSDT";

  static MinimizeLossesBot createMinimizeLossesBot({
    String name = "CABAL",
    String symbol = defaultSymbol,
    int dailyLossSellOrders = 3,
    double maxQuantityPerOrder = 100,
    double percentageSellOrder = 3,
    Duration timerBuyOrder = const Duration(minutes: 30),
  }) =>
      MinimizeLossesBot(
        const Uuid().v4(),
        MinimizeLossesPipeLineData(),
        name: name,
        testNet: true,
        config: MinimizeLossesConfig(
          symbol: symbol,
          dailyLossSellOrders: dailyLossSellOrders,
          maxQuantityPerOrder: maxQuantityPerOrder,
          percentageSellOrder: percentageSellOrder,
          timerBuyOrder: timerBuyOrder,
        ),
      );

  static OrderNew createOrderNew({
    String symbol = defaultSymbol,
    int orderId = 1,
    int orderListId = 1,
    String clientOrderId = '1',
    required double price,
    required double origQty,
    required OrderSides orderSides,
  }) =>
      OrderNew(
          symbol,
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
          [Fill(price, origQty, 1, 'USDT', 52)]);

  static OrderData createOrderData(OrderNew orderNew) => OrderData(
      orderNew.symbol,
      orderNew.orderId,
      orderNew.orderListId,
      orderNew.clientOrderId,
      orderNew.price,
      orderNew.origQty,
      orderNew.executedQty,
      orderNew.cummulativeQuoteQty,
      orderNew.status,
      orderNew.timeInForce,
      orderNew.type,
      orderNew.side,
      0,
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
      clock.now(),
      order.price,
      order.origQty,
      order.executedQty,
      order.cummulativeQuoteQty,
      order.status,
      order.timeInForce,
      order.type,
      order.side);
}
