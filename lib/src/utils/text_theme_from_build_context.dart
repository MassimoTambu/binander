import 'package:flutter/material.dart';

/// Extension utils to get [TextTheme] faster
extension TextThemeFromBuildContext on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}
