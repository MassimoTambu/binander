part of dashboard_module;

class DashboardPage extends ConsumerWidget {
  const DashboardPage({Key? key}) : super(key: key);

  void _navigateToAddBotPage(BuildContext context) {
    context.router.push(CreateBotRoute());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bots = ref.watch(botProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => context.router.push(const SettingsRoute()),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: _CryptoInfoContainer()),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              'Bots',
              style: Theme.of(context).textTheme.headline5,
            ),
          )),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              ((_, i) {
                return ProviderScope(
                  overrides: [
                    botTileProvider.overrideWithValue(BotTileProvider(bots[i])),
                  ],
                  child: const BotTile(),
                );
              }),
              childCount: bots.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddBotPage(context),
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      persistentFooterButtons: const [Text("v 0.6.9 - Dio 🐷")],
    );
  }
}
