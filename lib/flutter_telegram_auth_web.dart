import 'dart:async';
import 'dart:html' as html;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'flutter_telegram_auth_platform_interface.dart';

/// The web implementation of the FlutterTelegramAuth platform.
class FlutterTelegramAuthWeb extends FlutterTelegramAuthPlatform {
  String? _clientId;
  String? _redirectUri;

  /// Registers this class as the default instance of [FlutterTelegramAuthPlatform].
  static void registerWith(Registrar registrar) {
    FlutterTelegramAuthPlatform.instance = FlutterTelegramAuthWeb();
  }

  @override
  Future<void> init({
    required String clientId,
    required String redirectUri,
    List<String> scopes = const ['profile', 'phone'],
  }) async {
    _clientId = clientId;
    _redirectUri = redirectUri;
  }

  @override
  Future<String?> login() async {
    if (_clientId == null || _redirectUri == null) {
      throw Exception(
        'FlutterTelegramAuth not initialized. Call init() first.',
      );
    }

    final origin = html.window.location.origin;
    // URL for Telegram Web OAuth
    final authUrl =
        'https://oauth.telegram.org/auth?bot_id=$_clientId&origin=$origin&request_access=write&return_to=$_redirectUri';

    // Open popup
    final int width = 550;
    final int height = 470;
    final int left = (html.window.screen?.width ?? 1000) ~/ 2 - (width ~/ 2);
    final int top = (html.window.screen?.height ?? 800) ~/ 2 - (height ~/ 2);

    final popup = html.window.open(
      authUrl,
      'TelegramLogin',
      'width=$width,height=$height,left=$left,top=$top,status=0,location=0',
    );

    if (popup == null) {
      throw Exception('Popup blocked. Please allow popups for this site.');
    }

    final completer = Completer<String?>();

    late StreamSubscription<html.MessageEvent> subscription;

    // Listen for the postMessage from the popup window
    subscription = html.window.onMessage.listen((html.MessageEvent event) {
      if (event.data != null && event.data is String) {
        final data = event.data as String;
        if (data.startsWith('tgAuthResult=')) {
          final jsonStr = data.substring('tgAuthResult='.length);
          if (!completer.isCompleted) {
            completer.complete(jsonStr);
          }
          subscription.cancel();
          popup.close();
        }
      }
    });

    // Check periodically if the user closed the popup manually
    html.window.setInterval(() {
      if (popup.closed == true && !completer.isCompleted) {
        completer.complete(null); // User cancelled login
        subscription.cancel();
      }
    }, 500);

    return completer.future;
  }
}
