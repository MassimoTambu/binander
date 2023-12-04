import 'package:binander/src/api/api.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BinanceStatusIndicator<T> extends ConsumerWidget {
  final String title;
  final AutoDisposeFutureProvider<ApiResponse<T>> futureProvider;
  final bool Function(ApiResponse<T>) validate;

  const BinanceStatusIndicator({
    super.key,
    required this.title,
    required this.futureProvider,
    required this.validate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => ref.refresh(futureProvider),
      child: Column(
        children: [
          Text(title),
          const SizedBox(height: 5),
          ref.watch(futureProvider).when(
            data: (data) {
              if (validate(data)) {
                return const Icon(Icons.check_circle, color: Colors.green);
              }

              return const Icon(Icons.cancel, color: Colors.red);
            },
            loading: () {
              return const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
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
