part of settings_module;

class BinanceApiSettingsPage extends ConsumerWidget {
  BinanceApiSettingsPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  void onSave(BuildContext context, WidgetRef ref) {
    if (_formKey.currentState!.validate()) {
      final fields = _formKey.currentState!.fields;
      ref.read(settingsProvider.notifier).updateFromForm(
            pubNetApiKey: fields[SettingsConfig.pubNetApiKeyName]!.value,
            pubNetApiSecret: fields[SettingsConfig.pubNetApiSecretName]!.value,
            testNetApiKey: fields[SettingsConfig.testNetApiKeyName]!.value,
            testNetApiSecret:
                fields[SettingsConfig.testNetApiSecretName]!.value,
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
      pubNetConnection: settings.pubNetConnection,
      testNetConnection: settings.testNetConnection,
    );

    final pubNetConfigs = settingsConfig.configFields.entries
        .where((c) => c.key.startsWith('pub_net'));
    final testNetConfigs = settingsConfig.configFields.entries
        .where((c) => c.key.startsWith('test_net'));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConfigGroup(
              configFields: pubNetConfigs, title: 'Public Network Connection'),
          const SizedBox(height: 40),
          ConfigGroup(
              configFields: testNetConfigs, title: 'Test Network Connection'),
        ],
      ),
    );
  }
}

class ConfigGroup extends StatelessWidget {
  final Iterable<MapEntry<String, ConfigField>> configFields;
  final String title;

  const ConfigGroup({Key? key, required this.configFields, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
        ...configFields.map((e) {
          if (e.key == SettingsConfig.pubNetUrlName ||
              e.key == SettingsConfig.testNetUrlName) {
            return ConfigFormField(configField: e.value, enabled: false);
          }
          return ConfigFormField(configField: e.value);
        }),
      ],
    );
  }
}
