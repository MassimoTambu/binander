// ignore_for_file: constant_identifier_names

part of '../../api.dart';

/// RESPONSE	This is used when the ListStatus is responding to a failed action. (E.g. Orderlist placement or cancellation)
///
/// EXEC_STARTED	The order list has been placed or there is an update to the order list status.
///
/// ALL_DONE	The order list has finished executing and thus no longer active.
enum OCOStatus {
  RESPONSE,
  EXEC_STARTED,
  ALL_DONE,
}
