import 'package:binander/src/common_widgets/async_value_widget.dart';
import 'package:binander/src/constants/globals.dart';
import 'package:binander/src/constants/theme_dark.dart';
import 'package:binander/src/constants/theme_light.dart';
import 'package:binander/src/features/bot/domain/pipeline.dart';
import 'package:binander/src/features/settings/presentation/settings_provider.dart';
import 'package:binander/src/localization/string_hardcoded.dart';
import 'package:binander/src/routing/app_router.dart';
import 'package:binander/src/utils/file_storage_provider.dart';
import 'package:binander/src/utils/init_provider.dart';
import 'package:binander/src/features/bot/presentation/pipeline_provider.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Binander extends ConsumerWidget {
  const Binander({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(initProvider),
      data: (_) {
        // Autosave bots to file when pipelineProvider changes
        ref.listen<List<Pipeline>>(pipelineControllerProvider,
            (prevPipelines, newPipelines) {
          final oldBots = prevPipelines?.map((e) => e.bot).toList() ?? [];
          final newBots = newPipelines.map((e) => e.bot).toList();

          // Upsert bots
          ref
              .watch(fileStorageProvider.notifier)
              .upsertBots(newPipelines.map((e) => e.bot).toList());

          // Find bots to remove
          final botsToRemove =
              oldBots.where((b1) => newBots.every((b2) => b2.uuid != b1.uuid));

          if (botsToRemove.isNotEmpty) {
            // Remove bots from file
            ref
                .read(fileStorageProvider.notifier)
                .removeBots(botsToRemove.toList());
          }
        });
        return MaterialApp.router(
          scaffoldMessengerKey: snackbarKey,
          routerConfig: goRouter,
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'app',
          onGenerateTitle: (BuildContext context) => 'Binander'.hardcoded,
          localizationsDelegates: const [FormBuilderLocalizations.delegate],
          theme: themeLight,
          darkTheme: themeDark,
          themeMode: ref.watch(settingsStorageProvider).requireValue.themeMode,
        );
      },
    );
  }
}
