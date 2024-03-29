import 'dart:math';

extension FloorToDoubleWithDecimals on double {
  double floorToDoubleWithDecimals(int decimals) {
    final approx = pow(10, decimals);
    return (this * approx).floorToDouble() / approx;
  }
}
