import 'dart:convert';
import 'dart:io';

import 'package:bottino_fortino/modules/bot/models/bot.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fileStorageProvider = Provider<FileStorageProvider>((ref) {
  return FileStorageProvider();
});

class FileStorageProvider {
  Map<String, dynamic> data = {};
  // TODO use stream to write repeatedly to file
  // late IOSink sink;

  static const encoder = JsonEncoder.withIndent('  ');

  static final String defaultApplicationPath = Directory.current.absolute.path;
  static final String defaultFileName = defaultApplicationPath + '/data.json';

  Future<bool> init() async {
    if (kDebugMode) {
      print('init fileStorage');
    }
    await readData();

    return true;
  }

  Future<void> readData() async {
    final file = File.fromUri(Uri.file(defaultFileName));

    if (await file.exists()) {
      final _data = await file.readAsString();
      data = jsonDecode(_data);

      // sink = file.openWrite();
    } else {
      // sink = file.openWrite();

      _loadSchema();
      await _saveFile();
    }
  }

  void upsertBots(Iterable<Bot> bots) {
    for (var bot in bots) {
      _upsertBot(bot);
    }

    _saveFile();
  }

  void _upsertBot(Bot newBot) {
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
    data = {'bots': <Map<String, dynamic>>[]};
  }

  Future<void> _saveFile() async {
    await File.fromUri(Uri.file(defaultFileName))
        .writeAsString(encoder.convert(data));

    // final file = File.fromUri(Uri.file(defaultFileName));
    // sink.
    // await file.writeAsString(encoder.convert(data));
  }
}
