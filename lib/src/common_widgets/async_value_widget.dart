import 'package:binander/src/common_widgets/error_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Wrapper on [AsyncValue], it automatically manages error and loader cases.
/// It also has a named constructor where you can set a custom loader
class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
  }) : loader = const Center(child: CircularProgressIndicator.adaptive());
  const AsyncValueWidget.customLoader({
    super.key,
    required this.value,
    required this.data,
    required this.loader,
  });
  final AsyncValue<T> value;
  final Widget Function(T) data;
  final Widget loader;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (e, st) => Center(child: ErrorMessageWidget(e.toString())),
      loading: () => loader,
    );
  }
}

/// Sliver equivalent of [AsyncValueWidget]
class AsyncValueSliverWidget<T> extends StatelessWidget {
  const AsyncValueSliverWidget({
    super.key,
    required this.value,
    required this.data,
  }) : loader = const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator.adaptive()));
  const AsyncValueSliverWidget.customLoader({
    super.key,
    required this.value,
    required this.data,
    required this.loader,
  });
  final AsyncValue<T> value;
  final Widget Function(T) data;
  final Widget loader;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => loader,
      error: (e, st) => SliverToBoxAdapter(
        child: Center(child: ErrorMessageWidget(e.toString())),
      ),
    );
  }
}
