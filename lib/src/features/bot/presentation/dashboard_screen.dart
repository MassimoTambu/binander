import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:binander/src/features/bot/presentation/bot_tile/bot_tile.dart';
import 'package:binander/src/features/bot/presentation/crypto_info_container/crypto_info_container.dart';
import 'package:binander/src/features/bot/presentation/pipeline_controller.dart';
import 'package:binander/src/routing/app_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _navigateToAddBotPage(BuildContext context) {
    context.pushNamed(AppRoute.createBot.name);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pipelines = ref.watch(pipelineControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(AppRoute.settings.name),
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
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          )),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              ((_, i) => BotTile(pipeline: pipelines[i])),
              childCount: pipelines.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddBotPage(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
      persistentFooterButtons: const [Text("v 0.6.9 - Dio 🐷")],
    );
  }
}
