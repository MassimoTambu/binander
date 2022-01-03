part of settings_module;

class BinanceApiSettingsPage extends ConsumerWidget {
  BinanceApiSettingsPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  void onSave(BuildContext context, WidgetRef ref) {
    if (_formKey.currentState!.validate()) {
      final fields = _formKey.currentState!.fields;
      ref.read(settingsProvider.notifier).updateFromForm(
            apiKey: fields[SettingsConfig.apiKeyName]!.value,
            apiSecret: fields[SettingsConfig.apiSecretName]!.value,
            apiUrl: fields[SettingsConfig.apiUrlName]!.value,
          );
      context.router.navigateBack();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Binance Api settings'),
        centerTitle: true,
      ),
      body: FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Container(
              width: MediaQueryUtils.resizeBy(
                percValue: 80,
                currentSize: MediaQuery.of(context).size.width,
              ),
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  const ConfigContainer(),
                  TextButton(
                    onPressed: () => onSave(context, ref),
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ConfigContainer extends ConsumerWidget {
  const ConfigContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsConfig = SettingsConfig.create(
      apiKey: settings.apiKey,
      apiSecret: settings.apiSecret,
      apiUrl: settings.apiUrl,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...settingsConfig.configFields.entries
              .map((e) => ConfigFormField(configField: e.value)),
        ],
      ),
    );
  }
}
