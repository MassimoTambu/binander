part of dashboard_module;

class AddBotModel extends ChangeNotifier {
  var _selectedBotType = BotTypes.minimizeLosses;
  final _botService = BotService();
  final _snackBarService = SnackBarService();

  BotTypes get selectedBotType => _selectedBotType;

  set selectedBotType(BotTypes value) {
    _selectedBotType = value;
    notifyListeners();
  }

  void createBot(
      BuildContext context,
      Map<String, FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>>
          fields) {
    final bot = _botService.createBot(fields);

    _snackBarService.show(context, 'Bot ${bot.name} created!');
  }
}
