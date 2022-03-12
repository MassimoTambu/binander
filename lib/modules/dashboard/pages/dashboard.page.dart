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
      body: ListView.builder(
        itemCount: bots.length,
        itemBuilder: (context, i) {
          return ProviderScope(overrides: [
            currentBot.overrideWithValue(bots[i]),
          ], child: const BotTile());
        },
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
