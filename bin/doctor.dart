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
  
  // Check for autoVerify intent filter
  if (content.contains('android:autoVerify="true"') && content.contains('login.tg.dev')) {
    print('  [✓] AndroidManifest.xml: Intent filter for Telegram Login is configured.');
  } else {
    print('  [✗] AndroidManifest.xml: Missing intent-filter with android:autoVerify="true" and *.tg.dev host.');
    print('      Example: <intent-filter android:autoVerify="true">...</intent-filter>');
  }

  // Check for launchMode
  if (content.contains('android:launchMode="singleTask"') || content.contains('android:launchMode="singleTop"')) {
    print('  [✓] MainActivity launchMode is set.');
  } else {
    print('  [!] Recommendation: Set android:launchMode="singleTask" for MainActivity to handle deep links correctly.');
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
    if (entContent.contains('applinks:') && entContent.contains('login.tg.dev')) {
      print('  [✓] Entitlements: Associated Domains configured.');
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
