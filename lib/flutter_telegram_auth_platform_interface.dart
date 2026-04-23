import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_telegram_auth_method_channel.dart';

abstract class FlutterTelegramAuthPlatform extends PlatformInterface {
  /// Constructs a FlutterTelegramAuthPlatform.
  FlutterTelegramAuthPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterTelegramAuthPlatform _instance = MethodChannelFlutterTelegramAuth();

  /// The default instance of [FlutterTelegramAuthPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterTelegramAuth].
  static FlutterTelegramAuthPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterTelegramAuthPlatform] when
  /// they register themselves.
  static set instance(FlutterTelegramAuthPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> init({
    required String clientId,
    required String redirectUri,
    List<String> scopes = const ['profile', 'phone'],
  }) {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<String?> login() {
    throw UnimplementedError('login() has not been implemented.');
  }
}
