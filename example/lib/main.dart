import 'package:flutter/material.dart';
import 'package:flutter_telegram_auth/flutter_telegram_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _status = 'Not logged in';

  @override
  void initState() {
    super.initState();
    // Initialize the SDK
    FlutterTelegramAuth.init(
      clientId: '{CLIENT_ID}',
      redirectUri: 'https://app12345678-login.tg.dev',
    );
  }

  void _login() async {
    try {
      final idToken = await FlutterTelegramAuth.login();
      if (idToken != null) {
        setState(() {
          _status = 'Success! JWT: $idToken';
        });
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
        appBar: AppBar(title: const Text('Telegram Auth Example')),
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
