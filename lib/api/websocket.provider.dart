part of api;

final webSocketProvider =
    Provider<WebSocketProvider>((_) => WebSocketProvider());

class WebSocketProvider {
  IOWebSocketChannel? webSocket;

  final subscribe = {
    "method": "SUBSCRIBE",
    "params": [
      'btcusdt@bookTicker',
    ],
    "id": 2,
  };

  void connect() {
    if (webSocket == null || webSocket?.closeCode == status.goingAway) {
      webSocket = IOWebSocketChannel.connect(
          Uri.parse('wss://stream.binance.com:9443/ws/bookTicker'));
    }

    webSocket?.stream.listen(
      (event) {
        print('data');
        print(jsonEncode(event));
      },
      onDone: () => print('done'),
      cancelOnError: false,
      onError: (e) => print('error' + e.toString()),
    );
  }

  void send() {
    webSocket?.sink.add(jsonEncode(subscribe));
    print('send');
  }

  Future<void> close() async {
    final res = await webSocket?.sink.close(status.goingAway);
    print('close - ' + res.toString());
  }
}
