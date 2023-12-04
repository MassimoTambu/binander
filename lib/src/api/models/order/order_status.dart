// ignore_for_file: constant_identifier_names

part of '../../api.dart';

/// NEW	The order has been accepted by the engine. <br>
/// PARTIALLY_FILLED	A part of the order has been filled. <br>
/// FILLED	The order has been completed. <br>
/// CANCELED	The order has been canceled by the user. <br>
/// PENDING_CANCEL	Currently unused. <br>
/// REJECTED	The order was not accepted by the engine and not processed. <br>
/// EXPIRED	The order was canceled according to the order type's rules (e.g. LIMIT FOK orders with no fill, LIMIT IOC or MARKET orders that partially fill) or by the exchange, (e.g. orders canceled during liquidation, orders canceled during maintenance). <br>
/// EXPIRED_IN_MATCH	The order was canceled by the exchange due to STP trigger. (e.g. an order with EXPIRE_TAKER will match with existing orders on the book with the same account or same tradeGroupId).
enum OrderStatus {
  NEW,
  PARTIALLY_FILLED,
  FILLED,
  CANCELED,
  PENDING_CANCEL,
  REJECTED,
  EXPIRED,
  EXPIRED_IN_MATCH,
}
