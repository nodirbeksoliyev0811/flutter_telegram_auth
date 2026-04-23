import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_telegram_auth_platform_interface.dart';

/// An implementation of [FlutterTelegramAuthPlatform] that uses method channels.
class MethodChannelFlutterTelegramAuth extends FlutterTelegramAuthPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_telegram_auth');

  @override
  Future<void> init({
    required String clientId,
    required String redirectUri,
    List<String> scopes = const ['profile', 'phone'],
  }) async {
    await methodChannel.invokeMethod<void>('init', {
      'clientId': clientId,
      'redirectUri': redirectUri,
      'scopes': scopes,
    });
  }

  @override
  Future<String?> login() async {
    final token = await methodChannel.invokeMethod<String>('login');
    return token;
  }
}
