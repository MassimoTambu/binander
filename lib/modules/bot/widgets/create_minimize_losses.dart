import 'package:bottino_fortino/modules/bot/bots/minimize_losses/minimize_losses.config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CreateMinimizeLosses extends StatelessWidget {
  const CreateMinimizeLosses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        FormBuilderTextField(
          name: percentageSellOrderField.name,
          decoration: InputDecoration(
            label: Text(percentageSellOrderField.publicName),
            helperText: percentageSellOrderField.description,
          ),
          initialValue: percentageSellOrderField.value ??
              percentageSellOrderField.defaultValue?.toString(),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.numeric(),
            FormBuilderValidators.min(1),
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
