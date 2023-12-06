import 'package:binander/src/features/bot/domain/bots/bot.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

sealed class Pipeline {
  final Ref ref;
  final Bot bot;

  Pipeline(this.ref, this.bot);

  Future<void> start();
  void pause();
  Future<void> shutdown({String reason = ''});
}

abstract interface class AbsMinimizeLossesPipeline implements Pipeline {}
