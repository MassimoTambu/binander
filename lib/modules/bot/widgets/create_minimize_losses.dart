import 'package:bottino_fortino/api/api.dart';
import 'package:bottino_fortino/models/crypto_symbol.dart';
import 'package:bottino_fortino/modules/bot/bots/minimize_losses/minimize_losses.config.dart';
import 'package:bottino_fortino/modules/bot/models/bot.dart';
import 'package:bottino_fortino/modules/dashboard/providers/create_bot.provider.dart';
import 'package:bottino_fortino/modules/settings/models/api_connection.dart';
import 'package:bottino_fortino/modules/settings/providers/settings.provider.dart';
import 'package:bottino_fortino/providers/binance_test_net_status.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CreateMinimizeLosses extends ConsumerWidget {
  const CreateMinimizeLosses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configFields = MinimizeLossesConfig().configFields;
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
        ),
        FormBuilderDropdown(
          name: symbolField.name,
          decoration: InputDecoration(
            label: Text(symbolField.publicName),
            helperText: symbolField.description,
          ),
          initialValue:
              symbolField.value ?? symbolField.defaultValue?.toString(),
          items: symbolField.items!
              .map(
                (c) => DropdownMenuItem<String>(
                  value: c,
                  child: Text(c),
                ),
              )
              .toList(),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required<String>(),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Text(
            percentageSellOrderField.publicName,
            style: Theme.of(context).textTheme.caption!.copyWith(
                fontSize: Theme.of(context).textTheme.subtitle1!.fontSize),
          ),
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'Given the current price of ${ref.watch(createBotProvider.notifier).currentPrice} ${symbolField.value} and the sell order percentage of ',
            ),
            SizedBox(
              width: 60,
              child: FormBuilderTextField(
                name: percentageSellOrderField.name,
                initialValue: percentageSellOrderField.value ??
                    percentageSellOrderField.defaultValue?.toString(),
                decoration: InputDecoration(
                    suffixText: '%',
                    suffixStyle: Theme.of(context).textTheme.bodyText1),
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
                onChanged: (value) async {
                  final fields = ref
                      .read(createBotProvider.notifier)
                      .formKey
                      .currentState!
                      .fields;
                  final symbol = fields[symbolField.name]!.value as String?;
                  final isTestNet = fields[Bot.testNetName]!.value as bool;
                  if (value == null ||
                      value.isEmpty ||
                      symbol == null ||
                      symbol.isEmpty) return;

                  final ApiConnection apiConn = isTestNet
                      ? ref.read(settingsProvider).testNetConnection
                      : ref.read(settingsProvider).pubNetConnection;

                  final res = await ref
                      .read(apiProvider)
                      .spot
                      .market
                      .getAveragePrice(apiConn, CryptoSymbol(symbol));

                  ref.read(createBotProvider.notifier).currentPrice =
                      res.body.price;
                },
              ),
            ),
            Text(', I will try to submit a Sell StopLossOrder at Y'),
          ],
        ),
        Text(
          percentageSellOrderField.description,
          style: Theme.of(context).textTheme.caption!,
        ),
        FormBuilderTextField(
          name: timerBuyOrderField.name,
          decoration: InputDecoration(
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
        ),
      ],
    );
  }
}
