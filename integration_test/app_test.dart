import 'package:animations/animations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:pts/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('integration tests', () {
    testWidgets(
      "test description",
      (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();

        var finders = tester.widgetList(find.byType(OpenContainer));

        print(finders);
      },
    );
  });
}
