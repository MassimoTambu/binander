import 'package:bottino_fortino/modules/dashboard/providers/bot_tile.provider.dart';
import 'package:bottino_fortino/modules/dashboard/widgets/bot_tile/bot_tile.dart';
import 'package:bottino_fortino/modules/dashboard/widgets/crypto_info_container/crypto_info_container.dart';
import 'package:bottino_fortino/providers/pipeline.provider.dart';
import 'package:bottino_fortino/router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({Key? key}) : super(key: key);

  void _navigateToAddBotPage(BuildContext context) {
    context.router.push(CreateBotRoute());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pipelines = ref.watch(pipelineProvider);

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
          const SliverToBoxAdapter(child: CryptoInfoContainer()),
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
                    botTileProvider
                        .overrideWithValue(BotTileProvider(pipelines[i])),
                  ],
                  child: const BotTile(),
                );
              }),
              childCount: pipelines.length,
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
