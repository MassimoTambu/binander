part of settings_module;

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<SettingsNotifier>()._themeMode;
    return Scaffold(
      body: Column(
        children: [
          SwitchListTile(
            value: themeMode == ThemeMode.dark,
            title: const Text('Dark theme'),
            subtitle: const Text('Enable dark theme'),
            onChanged: (value) {
              context.read<SettingsNotifier>().themeMode =
                  value ? ThemeMode.dark : ThemeMode.light;
            },
          ),
        ],
      ),
    );
  }
}
