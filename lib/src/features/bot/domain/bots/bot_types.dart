import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(valueField: 'name')
enum BotTypes {
  minimizeLosses('minimizeLosses');

  const BotTypes(this.name);
  final String name;
}
