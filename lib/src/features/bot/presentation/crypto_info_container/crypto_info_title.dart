import 'package:flutter/material.dart';

class CryptoInfoTitle extends StatelessWidget {
  final String title;

  const CryptoInfoTitle(
    this.title, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
