import 'dart:convert';
import 'dart:io';

import 'package:binander/modules/bot/models/bot.dart';
import 'package:binander/providers/snackbar.provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fileStorageProvider = Provider<FileStorageProvider>((ref) {
  return FileStorageProvider(ref);
});

class FileStorageProvider {
  final Ref ref;
  Map<String, dynamic> data = {};

  FileStorageProvider(this.ref);

  static const encoder = JsonEncoder.withIndent('  ');

  static final String defaultApplicationPath = Directory.current.absolute.path;
  static final String defaultFileName = '$defaultApplicationPath/data.json';

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
      final dataFromFile = await file.readAsString();
      data = jsonDecode(dataFromFile);
    } else {
      _loadSchema();
      _saveFile();
    }
  }

  void _loadSchema() {
    data = {'bots': <Map<String, dynamic>>[]};
  }

  Future<void> upsertBots(List<Bot> bots) async {
    for (var bot in bots) {
      _upsertBot(bot);
    }

    await _saveFile();
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

  Future<void> removeBots(List<Bot> bots) async {
    (data['bots'] as List)
        .removeWhere((b) => bots.any((b2) => b2.uuid == b['uuid']));

    await _saveFile();
  }

  Future<void> _saveFile() async {
    final file = File.fromUri(Uri.file(defaultFileName));
    final raf = file.openSync(mode: FileMode.write);
    try {
      // We must require lock to prevent concurrent writes.
      // Also we have to perform a async lock, otherwise app could freeze if we don't release lock quickly
      await raf.lock(FileLock.blockingExclusive);
      await raf.writeString(encoder.convert(data));
    } catch (e) {
      ref
          .read(snackBarProvider)
          .show('Error while saving file: $e', seconds: 5);
    } finally {
      raf.closeSync();
    }
  }
}
