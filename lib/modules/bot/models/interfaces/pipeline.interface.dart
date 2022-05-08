import 'package:bottino_fortino/modules/bot/models/bot.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class Pipeline {
  final Ref ref;
  final Bot bot;

  const Pipeline(this.ref, this.bot);

  void start();
  void pause();
  void shutdown({String reason = ''});
}
