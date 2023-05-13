import 'dart:convert';
import 'dart:io';

import 'package:binander/src/features/bot/domain/bots/bot.dart';
import 'package:binander/src/utils/snackbar_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'file_storage_provider.g.dart';

@Riverpod(keepAlive: true)
class FileStorage extends _$FileStorage {
  @override
  Future<Map<String, dynamic>> build() async {
    debugPrint('init fileStorage');

    if (Platform.isAndroid) {
      defaultApplicationPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
      defaultFileName = '$defaultApplicationPath/data.json';
    }

    await readData();

    return state.requireValue;
  }

  static const encoder = JsonEncoder.withIndent('  ');

  static String defaultApplicationPath = Directory.current.absolute.path;
  static String defaultFileName = '$defaultApplicationPath/data.json';

  Future<void> readData() async {
    final file = File.fromUri(Uri.file(defaultFileName));

    if (await file.exists()) {
      final dataFromFile = await file.readAsString();
      state = jsonDecode(dataFromFile);
    } else {
      _loadSchema();
      _saveFile();
    }
  }

  void _loadSchema() {
    state = const AsyncData({'bots': <Map<String, dynamic>>[]});
  }

  Future<void> upsertBots(List<Bot> bots) async {
    for (var bot in bots) {
      _upsertBot(bot);
    }

    await _saveFile();
  }

  void _upsertBot(Bot newBot) {
    final bots = state.requireValue['bots'] as List;
    var botFound = false;

    for (var i = 0; i < bots.length; i++) {
      final bot = bots[i];

      if (bot['uuid'] == newBot.uuid) {
        state.requireValue['bots'][i] = newBot.toJson();
        botFound = true;
        break;
      }
    }

    if (botFound) return;

    (state.requireValue['bots'] as List).add(newBot.toJson());
  }

  Future<void> removeBots(List<Bot> bots) async {
    (state.requireValue['bots'] as List)
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
      await raf.writeString(encoder.convert(state.requireValue));
    } catch (e) {
      showSnackBarAction('Error while saving file: $e', seconds: 5);
    } finally {
      raf.closeSync();
    }
  }
}
