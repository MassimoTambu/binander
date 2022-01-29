part of widgets;

class BinanceStatusIndicator extends ConsumerWidget {
  const BinanceStatusIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final res = ref.watch(binancePubNetStatusProvider);

    return Container(
      child: res.when(
        data: (data) {
          return const Icon(Icons.check_circle, color: Colors.green);
        },
        loading: () {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => ref.refresh(binancePubNetStatusProvider),
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
