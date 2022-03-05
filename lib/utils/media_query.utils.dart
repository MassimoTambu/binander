part of utils;

//TODO use an external library
class MediaQueryUtils {
  static double resizeBy({
    required double percValue,
    required double currentSize,
    double? fullUnder,
  }) {
    final res = currentSize * percValue / 100;
    if (fullUnder != null && res <= fullUnder) return currentSize;
    return res;
  }
}
