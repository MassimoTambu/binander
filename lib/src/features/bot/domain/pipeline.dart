import 'package:binander/src/features/bot/domain/bots/bot.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

sealed class Pipeline {
  Pipeline(this.ref, this.bot);

  final Ref ref;
  final Bot bot;

  Future<void> start();
  void pause();
  Future<void> shutdown({String reason = ''});
}

abstract interface class AbsMinimizeLossesPipeline implements Pipeline {
  AbsMinimizeLossesPipeline(this.ref, this.bot);

  @override
  final Ref ref;
  @override
  final AbsMinimizeLossesBot bot;
}
