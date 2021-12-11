import 'package:bottino_fortino/api/api.dart';
import 'package:flutter/material.dart';

import 'services/settings.service.dart';

void main() {
  runApp(const BottinoFortino());
}

class BottinoFortino extends StatelessWidget {
  const BottinoFortino({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: CallApi()),
    );
  }
}

class CallApi extends StatefulWidget {
  const CallApi({Key? key}) : super(key: key);

  @override
  _CallApiState createState() => _CallApiState();
}

class _CallApiState extends State<CallApi> {
  String text = "";

  final settingsService = SettingsService();

  _callApi() async {
    final api = Api(
        url: settingsService.apiUrl,
        apiKey: settingsService.apiKey,
        apiSecret: settingsService.apiSecret);
    text = await api.spot.trade.getOrders('MATICUSDT');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextButton(onPressed: _callApi, child: const Text("call")),
      Text(text),
    ]);
  }
}
