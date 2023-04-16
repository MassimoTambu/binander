import 'package:flutter/material.dart';

class DetailedErrorBox extends StatelessWidget {
  final Object error;
  final StackTrace? stackTrace;

  const DetailedErrorBox(this.error, this.stackTrace, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        Text(
          'Error: $error',
          style: const TextStyle(color: Colors.red),
        ),
        Text(
          'StackTrace: ${stackTrace ?? 'nothing'}',
          style: const TextStyle(color: Colors.red),
        ),
      ],
    );
  }
}
