part of widgets;

class BinanceStatusIndicator extends ConsumerWidget {
  final String title;
  final AutoDisposeFutureProvider<ApiResponse> futureProvider;

  const BinanceStatusIndicator({
    Key? key,
    required this.title,
    required this.futureProvider,
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
              return const Icon(Icons.check_circle, color: Colors.green);
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
