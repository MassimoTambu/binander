import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsService {
  static final SettingsService _singleton = SettingsService._internal();
  final _secureStorage = const FlutterSecureStorage();

  factory SettingsService() {
    return _singleton;
  }

  SettingsService._internal();

  String get apiUrl {
    return 'https://api.binance.com/api/v3';
  }

  String get apiKey {
    return 'RsFTPmYyt31wlu9Kfc5sUHhGl8m3uyvXdfr5pm2H1egjANuZV5MlXJp6ZzfmJFkd';
  }

  String get apiSecret {
    return 'Pov5KpPI2Hu8Ho3mZaHoUSKYXQbNOEzgqoHDr5mBvBu22yCPd6Wwa2zVWie28evR';
  }
}
