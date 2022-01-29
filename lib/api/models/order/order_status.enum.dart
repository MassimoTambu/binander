// ignore_for_file: constant_identifier_names

part of api;

// NEW	The order has been accepted by the engine.
// PARTIALLY_FILLED	A part of the order has been filled.
// FILLED	The order has been completed.
// CANCELED	The order has been canceled by the user.
// PENDING_CANCEL	Currently unused
// REJECTED	The order was not accepted by the engine and not processed.
// EXPIRED	The order was canceled according to the order type's rules (e.g. LIMIT FOK orders with no fill, LIMIT IOC or MARKET orders that partially fill) or by the exchange, (e.g. orders canceled during liquidation, orders canceled during maintenance)

enum OrderStatus {
  NEW,
  PARTIALLY_FILLED,
  FILLED,
  CANCELED,
  PENDING_CANCEL,
  REJECTED,
  EXPIRED,
}
