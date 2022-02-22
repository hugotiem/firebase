import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pts/components/form/custom_text_form.dart';

void main() {
  late Widget headerText1;
  late Widget headerText2;

  group("custom text form widgets tests", () {
    setUp(() {
      headerText1 = MaterialApp(home: HeaderText1(text: "test 1"));
      headerText2 = MaterialApp(home: HeaderText2(text: "test 2"));
    });

    testWidgets(
      "HeaderText1 and HeaderText2 widget has one Text widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(headerText1);
        var textFinder = find.byType(Text);

        await tester.pumpWidget(headerText2);
        var textFinder2 = find.byType(Text);

        expect(textFinder, findsOneWidget);
        expect(textFinder2, findsOneWidget);
      },
    );

    testWidgets("text size for HeaderText1 and HeaderText1", (WidgetTester tester) async {
      await tester.pumpWidget(headerText1);
      var text = (tester.firstWidget(find.byType(Text)) as Text);

      await tester.pumpWidget(headerText2);
      var text2 = (tester.firstWidget(find.byType(Text)) as Text);

      expect(text.style?.fontSize, 25);
      expect(text2.style?.fontSize, 22);
    });
  });
}
