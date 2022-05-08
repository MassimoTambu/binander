import 'package:bottino_fortino/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BinanceStatusIndicator<T> extends ConsumerWidget {
  final String title;
  final AutoDisposeFutureProvider<ApiResponse<T>> futureProvider;
  final bool Function(ApiResponse<T>) validate;

  const BinanceStatusIndicator({
    Key? key,
    required this.title,
    required this.futureProvider,
    required this.validate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final res = ref.watch(futureProvider);

    return InkWell(
      onTap: () => ref.refresh(futureProvider),
      child: Column(
        children: [
          Text(title),
          const SizedBox(height: 5),
          res.when(
            data: (data) {
              if (validate(data)) {
                return const Icon(Icons.check_circle, color: Colors.green);
              }

              return const Icon(Icons.cancel, color: Colors.red);
            },
            loading: () {
              return const SizedBox(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
                width: 24,
                height: 24,
              );
            },
            error: (error, stackTrace) {
              return const Icon(
                Icons.cancel,
                color: Colors.red,
              );
            },
          ),
        ],
      ),
    );
  }
}
