import 'package:binander/modules/bot/models/bot.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class Pipeline {
  final Ref ref;
  final Bot bot;

  Pipeline(this.ref, this.bot);

  Future<void> start();
  void pause();
  Future<void> shutdown({String reason = ''});
}
