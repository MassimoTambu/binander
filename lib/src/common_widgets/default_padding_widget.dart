import 'package:flutter/material.dart';

const double defaultPaddingOffset = 8;

class DefaultPaddingWidget extends StatelessWidget {
  const DefaultPaddingWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(
            left: defaultPaddingOffset, right: defaultPaddingOffset),
        child: child,
      );
}
