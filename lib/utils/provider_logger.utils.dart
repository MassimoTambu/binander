part of utils;

class ProviderLoggerUtils extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (kDebugMode) {
      print('[${provider.name ?? provider.runtimeType}] value: $newValue');
    }
  }

  @override
  void didDisposeProvider(ProviderBase provider, ProviderContainer containers) {
    if (kDebugMode) {
      print('[${provider.name ?? provider.runtimeType}] disposed');
    }
  }
}
