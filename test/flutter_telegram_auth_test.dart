import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_telegram_auth/flutter_telegram_auth.dart';
import 'package:flutter_telegram_auth/flutter_telegram_auth_platform_interface.dart';
import 'package:flutter_telegram_auth/flutter_telegram_auth_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterTelegramAuthPlatform
    with MockPlatformInterfaceMixin
    implements FlutterTelegramAuthPlatform {

  @override
  Future<void> init({required String clientId, required String redirectUri, List<String> scopes = const ['profile', 'phone']}) async {
    return;
  }

  @override
  Future<String?> login() => Future.value('mock_id_token');
}

void main() {
  final FlutterTelegramAuthPlatform initialPlatform = FlutterTelegramAuthPlatform.instance;

  test('$MethodChannelFlutterTelegramAuth is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterTelegramAuth>());
  });

  test('login', () async {
    MockFlutterTelegramAuthPlatform fakePlatform = MockFlutterTelegramAuthPlatform();
    FlutterTelegramAuthPlatform.instance = fakePlatform;

    expect(await FlutterTelegramAuth.login(), 'mock_id_token');
  });
}
