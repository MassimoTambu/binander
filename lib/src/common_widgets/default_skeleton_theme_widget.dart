import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

/// The default skeleton theme widget. It has to wrap the other skeleton widgets
class DefaultSkeletonThemeWidget extends StatelessWidget {
  const DefaultSkeletonThemeWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SkeletonTheme(
      shimmerGradient: const LinearGradient(
        colors: [
          Color(0xFFD8E3E7),
          Color(0xFFC8D5DA),
          Color(0xFFD8E3E7),
        ],
        stops: [
          0.1,
          0.5,
          0.9,
        ],
      ),
      darkShimmerGradient: const LinearGradient(
        colors: [
          Color(0xFF525252),
          Color(0xFF545454),
          Color(0xFF7E7E7E),
          Color(0xFF545454),
          Color(0xFF525252),
        ],
        stops: [
          0.0,
          0.2,
          0.5,
          0.8,
          1,
        ],
        begin: Alignment(-2.4, -0.2),
        end: Alignment(2.4, 0.2),
        tileMode: TileMode.decal,
      ),
      child: child,
    );
  }
}
