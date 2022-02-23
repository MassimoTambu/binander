part of providers;

final fileStorageProvider = Provider<FileStorageProvider>((ref) {
  return FileStorageProvider();
});

class FileStorageProvider {
  Map<String, dynamic> data = {};

  Future<bool> init() async {
    if (kDebugMode) {
      print('init fileStorage');
    }
    await readData();

    return true;
  }

  static const encoder = JsonEncoder.withIndent('  ');

  static final String defaultApplicationPath = Directory.current.absolute.path;
  static final String defaultFileName = defaultApplicationPath + '/data.json';

  Future<void> readData() async {
    final file = File.fromUri(Uri.file(defaultFileName));
    if (await file.exists()) {
      final _data = await file.readAsString();
      data = jsonDecode(_data);
    } else {
      _loadSchema();
      _saveFile();
    }
  }

  void saveBots(List<Bot> bots) {
    for (var bot in bots) {
      if (bot is MinimizeLossesBot) _saveBot(bot);
    }

    _saveFile();
  }

  void _saveBot(Bot newBot) {
    final bots = data['bots'] as List;
    var botFound = false;

    for (var i = 0; i < bots.length; i++) {
      final bot = bots[i];

      if (bot['uuid'] == newBot.uuid) {
        data['bots'][i] = newBot.toJson();
        botFound = true;
        break;
      }
    }

    if (botFound) return;

    (data['bots'] as List).add(newBot.toJson());
  }

  void _loadSchema() {
    data = {'bots': []};
  }

  Future<void> _saveFile() async {
    await File.fromUri(Uri.file(defaultFileName))
        .writeAsString(encoder.convert(data));
  }
}
