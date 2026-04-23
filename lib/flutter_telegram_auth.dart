import 'dart:convert';
import 'flutter_telegram_auth_platform_interface.dart';
import 'src/telegram_user.dart';

export 'src/telegram_user.dart';

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

  /// Decodes the JWT token locally and returns a [TelegramUser] object.
  /// NOTE: This only decodes the payload for local UI convenience. 
  /// You MUST still verify the token's signature on your backend!
  static TelegramUser? getLocalUserFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      String payload = parts[1];
      // Pad with '=' so length is a multiple of 4
      int paddingLength = 4 - (payload.length % 4);
      if (paddingLength > 0 && paddingLength < 4) {
        payload += '=' * paddingLength;
      }

      final String decodedPayload = utf8.decode(base64Url.decode(payload));
      final Map<String, dynamic> json = jsonDecode(decodedPayload);
      return TelegramUser.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  /// Checks if the JWT token has expired locally.
  static bool isTokenExpired(String token) {
    try {
      final user = getLocalUserFromToken(token);
      if (user?.authDate == null) return true;

      // Telegram tokens are usually valid for a long time, 
      // but developers often check against 24h or similar.
      // Here we just provide the basic logic.
      final authDateTime = DateTime.fromMillisecondsSinceEpoch(user!.authDate! * 1000);
      final now = DateTime.now();
      
      // Example: If it's more than 30 days old, consider it expired
      return now.difference(authDateTime).inDays > 30;
    } catch (e) {
      return true;
    }
  }
}
