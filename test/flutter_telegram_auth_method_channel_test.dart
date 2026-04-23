import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_telegram_auth/flutter_telegram_auth_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFlutterTelegramAuth platform = MethodChannelFlutterTelegramAuth();
  const MethodChannel channel = MethodChannel('flutter_telegram_auth');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        if (methodCall.method == 'login') {
          return 'mock_token_123';
        }
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('login', () async {
    expect(await platform.login(), 'mock_token_123');
  });
}
