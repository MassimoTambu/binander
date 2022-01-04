part of widgets;

class BinanceStatusIndicator extends ConsumerWidget {
  const BinanceStatusIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final res = ref.watch(binanceStatusProvider);

    return Container(
      child: res.when(
        data: (data) {
          return const Icon(Icons.check_circle);
        },
        loading: () {
          return const CircularProgressIndicator(strokeWidth: 2);
        },
        error: (error, stackTrace) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => ref.refresh(binanceStatusProvider),
                icon: const Icon(Icons.refresh),
                hoverColor: Colors.transparent,
              ),
              const Icon(
                Icons.cancel,
                color: Colors.red,
              ),
            ],
          );
        },
      ),
    );
  }
}
