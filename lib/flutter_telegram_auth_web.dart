import 'dart:async';
import 'dart:js_interop';
import 'package:web/web.dart' as web;
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

    final origin = web.window.location.origin;
    // URL for Telegram Web OAuth
    final authUrl =
        'https://oauth.telegram.org/auth?bot_id=$_clientId&origin=$origin&request_access=write&return_to=$_redirectUri';

    // Open popup
    final int width = 550;
    final int height = 470;
    final int left = (web.window.screen.width) ~/ 2 - (width ~/ 2);
    final int top = (web.window.screen.height) ~/ 2 - (height ~/ 2);

    final popup = web.window.open(
      authUrl,
      'TelegramLogin',
      'width=$width,height=$height,left=$left,top=$top,status=0,location=0',
    );

    if (popup == null) {
      // In package:web, window.open returns a WindowProxy which is usually not null
      // but we keep the logic for robustness if possible.
      throw Exception('Popup blocked. Please allow popups for this site.');
    }

    final completer = Completer<String?>();

    // Message handler function
    void onMessage(web.Event event) {
      if (event.isA<web.MessageEvent>()) {
        final messageEvent = event as web.MessageEvent;
        final data = messageEvent.data;
        if (data != null && data.isA<JSString>()) {
          final dataStr = (data as JSString).toDart;
          if (dataStr.startsWith('tgAuthResult=')) {
            final jsonStr = dataStr.substring('tgAuthResult='.length);
            if (!completer.isCompleted) {
              completer.complete(jsonStr);
            }
            web.window.removeEventListener('message', onMessage.toJS);
            popup.close();
          }
        }
      }
    }

    // Listen for the postMessage from the popup window
    web.window.addEventListener('message', onMessage.toJS);

    // Check periodically if the user closed the popup manually
    Timer? checkTimer;
    checkTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (popup.closed && !completer.isCompleted) {
        completer.complete(null); // User cancelled login
        web.window.removeEventListener('message', onMessage.toJS);
        checkTimer?.cancel();
      } else if (completer.isCompleted) {
        checkTimer?.cancel();
      }
    });

    return completer.future;
  }
}
