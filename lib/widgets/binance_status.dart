part of widgets;

class BinanceStatusIndicator extends ConsumerWidget {
  const BinanceStatusIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.refresh(binanceStatusProvider).when(
      data: (data) {
        return const Icon(Icons.check_circle);
      },
      loading: () {
        return const CircularProgressIndicator();
      },
      error: (error, stackTrace) {
        return const Icon(Icons.cancel);
      },
    );

    return const CircularProgressIndicator();
  }
}
