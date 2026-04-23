import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_telegram_auth/flutter_telegram_auth.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('login fails without context', (WidgetTester tester) async {
    // We just test that the plugin is registered, real login requires native UI.
    try {
      await FlutterTelegramAuth.init(clientId: 'test', redirectUri: 'test://');
      expect(true, true);
    } catch (e) {
      fail('init should not throw an error if method channel works');
    }
  });
}
