part of settings_module;

class ApiConnection {
  String url;
  String apiSecret;
  String apiKey;

  ApiConnection({
    required this.url,
    required this.apiKey,
    required this.apiSecret,
  });
}
