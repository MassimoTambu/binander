import 'package:binander/src/api/api.dart';
import 'package:binander/src/features/bot/domain/bots/minimize_losses/minimize_losses_config.dart';
import 'package:binander/src/features/bot/domain/create_minimize_losses_params.dart';
import 'package:binander/src/features/bot/presentation/create_bot_controller.dart';
import 'package:binander/src/features/bot/presentation/create_minimize_losses_provider.dart';
import 'package:binander/src/features/bot/presentation/pipeline_controller.dart';
import 'package:binander/src/features/settings/presentation/exchange_info_provider.dart';
import 'package:binander/src/models/crypto_symbol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreateMinimizeLosses extends ConsumerWidget {
  const CreateMinimizeLosses({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configFields = ref.watch(createBotControllerProvider).configFields;
    final isTestNet = ref.watch(createBotControllerProvider).isTestNet;
    final createBotNotifier = ref.watch(createBotControllerProvider.notifier);
    final dailyLossField =
        configFields[MinimizeLossesConfig.dailyLossSellOrdersName]!;
    final maxInvestmentField =
        configFields[MinimizeLossesConfig.maxInvestmentPerOrderName]!;
    final percentageSellOrderField =
        configFields[MinimizeLossesConfig.percentageSellOrderName]!;
    final symbolField = configFields[MinimizeLossesConfig.symbolName]!;
    final timerBuyOrderField =
        configFields[MinimizeLossesConfig.timerBuyOrderName]!;
    final autoRestartField =
        configFields[MinimizeLossesConfig.autoRestartName]!;
    final symbols = ref
            .watch(exchangeInfoProvider)
            ?.getCompatibleSymbolsWithMinimizeLosses(isTestNet: isTestNet) ??
        [];

    final createMinimizeLosses = ref.watch(createMinimizeLossesProvider(
        CreateMinimizeLossesParams(
            isTestNet, percentageSellOrderField.value, symbolField.value)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormBuilderTextField(
          name: dailyLossField.name,
          decoration: InputDecoration(
            label: Text(dailyLossField.publicName),
            helperText: dailyLossField.description,
          ),
          initialValue:
              dailyLossField.value ?? dailyLossField.defaultValue?.toString(),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.integer(),
            FormBuilderValidators.min(0),
          ]),
          onChanged: (value) =>
              createBotNotifier.updateConfigField(dailyLossField.name, value),
        ),
        FormBuilderTextField(
          name: maxInvestmentField.name,
          decoration: InputDecoration(
            label: Text(maxInvestmentField.publicName),
            helperText: maxInvestmentField.description,
          ),
          initialValue: maxInvestmentField.value ??
              maxInvestmentField.defaultValue?.toString(),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.integer(),
            FormBuilderValidators.min(0),
          ]),
          onChanged: (value) => createBotNotifier.updateConfigField(
              maxInvestmentField.name, value),
        ),
        FormBuilderDropdown(
          name: symbolField.name,
          decoration: InputDecoration(
            label: Text(symbolField.publicName),
            helperText: symbolField.description,
          ),
          items: symbols
              .map(
                (c) => DropdownMenuItem<String>(
                  value: "${c.baseAsset}-${c.quoteAsset}",
                  child: Text("${c.baseAsset}-${c.quoteAsset}"),
                ),
              )
              .toList(),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required<String>(),
            (String? val) {
              if (val == null) return null;
              final botCount = ref
                  .read(pipelineControllerProvider)
                  .where((p) => p.bot.config.symbol!.symbol == val)
                  .length;

              final maxAlgoFilter = symbols
                  .firstWhere((s) => s.symbol == CryptoSymbol(val).toString())
                  .filters
                  .firstWhere((f) =>
                      f.filterType == SymbolFilterTypes.MAX_NUM_ALGO_ORDERS)
                  .maybeMap(
                      maxNumAlgoOrders: (f) => f.maxNumAlgoOrders,
                      orElse: () => null);

              if (maxAlgoFilter == null || botCount < maxAlgoFilter) {
                return null;
              }

              return 'Max num algo orders reached';
            }
          ]),
          onChanged: (value) {
            createBotNotifier.updateConfigField(symbolField.name, value);
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Text(
            percentageSellOrderField.publicName,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontSize: Theme.of(context).textTheme.titleMedium!.fontSize),
          ),
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            createMinimizeLosses.maybeWhen(
              data: (createMinimizeLosses) => Text(
                'Given the current price of ${createMinimizeLosses.currentPrice} ${createMinimizeLosses.symbol} and the sell order percentage of ',
              ),
              orElse: () => const Text(
                'Given the current price of -- and the sell order percentage of ',
              ),
            ),
            SizedBox(
              width: 60,
              child: FormBuilderTextField(
                name: percentageSellOrderField.name,
                initialValue: percentageSellOrderField.value ??
                    percentageSellOrderField.defaultValue?.toString(),
                decoration: InputDecoration(
                    suffixText: '%',
                    suffixStyle: Theme.of(context).textTheme.bodyLarge),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: 'Required'),
                  FormBuilderValidators.numeric(errorText: 'Numbers only'),
                  FormBuilderValidators.min(1, errorText: 'Min 1'),
                  FormBuilderValidators.max(100, errorText: 'Max 100'),
                ]),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.end,
                onChanged: (value) {
                  createBotNotifier.updateConfigField(
                      percentageSellOrderField.name, value);
                },
              ),
            ),
            createMinimizeLosses.maybeWhen(
              data: (createMinimizeLosses) => Text(
                ' I will try to submit a Sell StopLossOrder at ${createMinimizeLosses.stopSellOrderPrice} ${createMinimizeLosses.symbol}',
              ),
              orElse: () => const Text(
                ' I will try to submit a Sell StopLossOrder at --',
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            percentageSellOrderField.description,
            style: Theme.of(context).textTheme.bodySmall!,
          ),
        ),
        FormBuilderTextField(
          name: timerBuyOrderField.name,
          decoration: InputDecoration(
            prefixText: 'minutes: ',
            prefixStyle: Theme.of(context).textTheme.bodyLarge,
            label: Text(timerBuyOrderField.publicName),
            helperText: timerBuyOrderField.description,
          ),
          initialValue: timerBuyOrderField.value ??
              timerBuyOrderField.defaultValue?.toString(),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.integer(),
            FormBuilderValidators.min(0),
          ]),
          onChanged: (value) => createBotNotifier.updateConfigField(
              timerBuyOrderField.name, value),
        ),
        FormBuilderSwitch(
          name: autoRestartField.name,
          decoration: InputDecoration(
            helperText: autoRestartField.description,
          ),
          initialValue: true,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
          ]),
          title: Text(autoRestartField.publicName),
          onChanged: (value) =>
              createBotNotifier.updateConfigField(autoRestartField.name, value),
        ),
      ],
    );
  }
}
