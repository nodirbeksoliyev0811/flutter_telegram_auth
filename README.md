# flutter_telegram_auth

A Flutter plugin for integrating [Telegram Native SDKs](https://core.telegram.org/bots/telegram-login#native-sdks) for both Android and iOS. This allows over 1 billion users to seamlessly sign up and log in with their Telegram accounts without opening webviews.

## Prerequisites

1. Set up a Telegram Bot via [@BotFather](https://t.me/botfather).
2. Configure **Login Widget** settings in BotFather (register your package/bundle IDs and Redirect URIs).

## Installation

Add the plugin to your `pubspec.yaml`.

### Android Configuration

Update your app's `android/app/src/main/AndroidManifest.xml` to handle the redirect URI, ensuring `android:autoVerify="true"` is set. Example:
```xml
<activity android:name=".MainActivity" android:launchMode="singleTask">
    <!-- Telegram Login Redirect -->
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="https" 
              android:host="YOUR_BOT_DOMAIN-login.tg.dev" />
    </intent-filter>
</activity>
```

### iOS Configuration

Telegram's iOS SDK is distributed via Swift Package Manager (SPM). Since you are using a standard Flutter plugin, you need to add the package to your iOS workspace:

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Go to **File > Add Package Dependencies...**
3. Enter the URL: `https://github.com/TelegramMessenger/telegram-login-ios`
4. Add the `TelegramLogin` package to your `Runner` target.
5. In Xcode, select your app target, go to **Signing & Capabilities**, click **+ Capability**, and add **Associated Domains**. Add your Universal Link (e.g., `applinks:app123456-login.tg.dev`).

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:flutter_telegram_auth/flutter_telegram_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _status = 'Not logged in';

  @override
  void initState() {
    super.initState();
    // 1. Initialize the SDK
    FlutterTelegramAuth.init(
      clientId: 'YOUR_BOT_ID', 
      redirectUri: 'https://app123456-login.tg.dev/tglogin', // From BotFather
    );
  }

  void _login() async {
    try {
      // 2. Start Login Flow
      final idToken = await FlutterTelegramAuth.login();
      if (idToken != null) {
        setState(() {
          _status = 'Success! JWT: $idToken';
        });
        // Important: Send this idToken to your backend for verification!
      }
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Telegram Auth')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_status, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login with Telegram'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```
