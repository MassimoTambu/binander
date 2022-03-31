// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bottino_fortino/api/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';

@GenerateMocks([])
void main() {
  final dioAdapter = DioAdapter(dio: Dio());
  final container = ProviderContainer(
    overrides: [dioProvider.overrideWithValue(dioAdapter.dio)],
  );

  setUp(() async {});

  tearDown(() async {
    container.dispose();
  });

  test('Class initialization test', () {});
}