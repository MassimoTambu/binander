// ignore_for_file: constant_identifier_names

part of '../../api.dart';

/// EXECUTING	Either an order list has been placed or there is an update to the status of the list.
///
/// ALL_DONE	An order list has completed execution and thus no longer active.
///
/// REJECT	The List Status is responding to a failed action either during order placement or order canceled.)
enum OCOOrderStatus {
  EXECUTING,
  ALL_DONE,
  REJECT,
}
