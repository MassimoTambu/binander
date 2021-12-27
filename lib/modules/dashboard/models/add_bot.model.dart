part of dashboard_module;

class AddBotModel extends ChangeNotifier {
  var _selectedBotType = BotTypes.minimizeLosses;

  BotTypes get selectedBotType => _selectedBotType;

  set selectedBotType(BotTypes value) {
    _selectedBotType = value;
    notifyListeners();
  }
}
