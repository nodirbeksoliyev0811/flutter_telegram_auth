import 'dart:io';

void main() {
  print('=========================================');
  print('   Flutter Telegram Auth Doctor 🔍      ');
  print('=========================================');
  print('');

  _checkAndroid();
  print('');
  _checkIOS();
  print('');
  _checkWeb();

  print('\nDone! If you see any [✗], please refer to the README.md for setup instructions.');
}

void _checkAndroid() {
  print('Checking Android configuration...');
  final manifestPath = 'android/app/src/main/AndroidManifest.xml';
  final file = File(manifestPath);

  if (!file.existsSync()) {
    print('  [!] Could not find $manifestPath');
    return;
  }

  final content = file.readAsStringSync();
  
  // Try to extract the host
  final hostMatch = RegExp(r'android:host="([^"]+-login\.tg\.dev)"').firstMatch(content);
  final detectedHost = hostMatch?.group(1);

  // Check for autoVerify intent filter
  if (content.contains('android:autoVerify="true"') && detectedHost != null) {
    print('  [✓] AndroidManifest.xml: Intent filter configured for $detectedHost');
  } else {
    print('  [✗] AndroidManifest.xml: Missing or incorrect intent-filter.');
    print('      Ensure you have <data android:scheme="https" android:host="appXXXX-login.tg.dev" />');
    print('      with android:autoVerify="true" in your <intent-filter>.');
  }

  // Check for launchMode
  if (content.contains('android:launchMode="singleTask"') || content.contains('android:launchMode="singleTop"')) {
    print('  [✓] MainActivity launchMode is set correctly.');
  } else {
    print('  [!] Warning: MainActivity launchMode should be "singleTask" or "singleTop".');
  }
}

void _checkIOS() {
  print('Checking iOS configuration...');
  final plistPath = 'ios/Runner/Info.plist';
  final file = File(plistPath);

  if (!file.existsSync()) {
    print('  [!] Could not find $plistPath');
    return;
  }

  final content = file.readAsStringSync();

  // Check for LSApplicationQueriesSchemes
  if (content.contains('<string>tg</string>')) {
    print('  [✓] Info.plist: LSApplicationQueriesSchemes contains "tg".');
  } else {
    print('  [✗] Info.plist: Missing "tg" in LSApplicationQueriesSchemes.');
    print('      Required for Telegram app detection.');
  }

  // Check for associated domains (basic check)
  final entitlementsPath = 'ios/Runner/Runner.entitlements';
  if (File(entitlementsPath).existsSync()) {
    final entContent = File(entitlementsPath).readAsStringSync();
    final domainMatch = RegExp(r'<string>applinks:([^<]+-login\.tg\.dev)</string>').firstMatch(entContent);
    final detectedDomain = domainMatch?.group(1);

    if (detectedDomain != null) {
      print('  [✓] Entitlements: Associated Domain configured for $detectedDomain');
    } else {
      print('  [✗] Entitlements: Missing login.tg.dev in Associated Domains.');
    }
  } else {
    print('  [!] Runner.entitlements not found. Ensure Associated Domains capability is added in Xcode.');
  }
}

void _checkWeb() {
  print('Checking Web configuration...');
  final webFile = File('web/telegram_login.html');

  if (webFile.existsSync()) {
    final content = webFile.readAsStringSync();
    if (content.contains('tgAuthResult') && content.contains('window.opener.postMessage')) {
      print('  [✓] web/telegram_login.html is present and contains callback logic.');
    } else {
      print('  [!] web/telegram_login.html exists but might be missing callback logic.');
    }
  } else {
    print('  [✗] Missing web/telegram_login.html. Required for Web authentication callback.');
  }
}
