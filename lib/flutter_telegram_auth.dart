import 'flutter_telegram_auth_platform_interface.dart';

class FlutterTelegramAuth {
  /// Initializes the Telegram SDK. Call this before [login].
  static Future<void> init({
    required String clientId,
    required String redirectUri,
    List<String> scopes = const ['profile', 'phone'],
  }) {
    return FlutterTelegramAuthPlatform.instance.init(
      clientId: clientId,
      redirectUri: redirectUri,
      scopes: scopes,
    );
  }

  /// Starts the Telegram login flow. Returns the ID token as a String, or null if cancelled/failed.
  static Future<String?> login() {
    return FlutterTelegramAuthPlatform.instance.login();
  }
}
