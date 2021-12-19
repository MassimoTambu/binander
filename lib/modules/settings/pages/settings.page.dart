part of settings_module;

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<SettingsNotifier>().themeMode;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
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
          ListTile(
            title: const Text('Info'),
            subtitle: const Text('Show app info'),
            onTap: () {
              context.router.push(const InfoRoute());
            },
          ),
        ],
      ),
    );
  }
}
