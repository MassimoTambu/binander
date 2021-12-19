part of settings_module;

class SettingsNotifier extends ChangeNotifier {
  final _settingsService = SettingsService();

  ThemeMode get themeMode => _settingsService.themeMode;

  set themeMode(ThemeMode themeMode) {
    _settingsService.themeMode = themeMode;
    notifyListeners();
  }
}
