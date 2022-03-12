import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pts/components/custom_text.dart';

import 'package:pts/main.dart' as app;
import 'package:pts/services/auth_service.dart';
import 'package:pts/pages/creation/creation_page.dart';
import 'package:pts/pages/login/connect.dart';
import 'package:pts/pages/profil/profil_page.dart';
import 'package:pts/pages/search/search_page.dart';
import 'package:pts/pages/search/sliver/searchbar.dart';
import 'package:pts/pages/search/sliver/searchbar_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('integration tests', () {

     testWidgets(
      "Arrive on Home page after open the app",
      (WidgetTester tester) async {
        app.main(isTesting: true);
        await tester.pumpAndSettle();

        tester.runAsync(() async {
          await Future.delayed(const Duration(seconds: 2));
          var finder = find.byType(BottomNavigationBar);
          expect(finder, findsOneWidget);
        });
      },
    );

    testWidgets(
      "Open build party form from search page",
      (WidgetTester tester) async {
        app.main(isTesting: true);
        await tester.pumpAndSettle();

        tester.runAsync(() async {
          await Future.delayed(const Duration(seconds: 2));
          var finder = find.byWidgetPredicate((Widget widget) =>
              widget is Container &&
              widget.child is CText &&
              (widget.child as CText).text ==
                  "Créer maintenant !".toUpperCase());

          tester.tap(finder);

          var creationFinder = find.byType(CreationPage);

          expect(creationFinder, findsOneWidget);
        });
      },
    );

    testWidgets(
      "Open build party form from bottom navigation bar",
      (WidgetTester tester) async {
        app.main(isTesting: true);
        await tester.pumpAndSettle();

        tester.runAsync(() async {
          await Future.delayed(const Duration(seconds: 2));
          var finder = find.byWidgetPredicate(
              (Widget widget) => widget is FloatingActionButton);

          tester.tap(finder);

          var creationFinder = find.byType(CreationPage);

          expect(creationFinder, findsOneWidget);
        });
      },
    );
  });

  testWidgets(
    "see se connecter when loggedout or do not see se connecter when logged in",
    (WidgetTester tester) async {
      app.main(isTesting: true);
      await tester.pumpAndSettle();

      tester.runAsync(() async {
        await Future.delayed(const Duration(seconds: 2));
        var finder = find.byWidgetPredicate((Widget widget) =>
            widget is BottomNavigationBarItem &&
            (widget as BottomNavigationBarItem).label == "Profil");

        tester.tap(finder);

        var profilFinder = find.byType(Profil);

        expect(profilFinder, findsOneWidget);

        var token = await AuthService().getToken();

        if (token == null) {
          var btnConnectFinder = find.byType(Connect);
          expect(btnConnectFinder, findsOneWidget);
        } else {
          var btnDisconnectFinder = find.byWidgetPredicate(
              (widget) => widget is Text && widget.data == "Se deconnecter");
          expect(btnDisconnectFinder, findsOneWidget);
        }
      });
    },
  );

  testWidgets(
    "should open the search form",
    (WidgetTester tester) async {
      app.main(isTesting: true);
      await tester.pumpAndSettle();

      tester.runAsync(() async {
        await Future.delayed(const Duration(seconds: 2));
        var finder = find.byWidgetPredicate((Widget widget) =>
            widget is BottomNavigationBarItem &&
            (widget as BottomNavigationBarItem).label == "Rechercher");

        tester.tap(finder);

        var searchFinder = find.byType(Search);

        expect(searchFinder, findsOneWidget);

        var searchBarFinder = find.byWidgetPredicate((widget) =>
            widget is OpenContainer && widget.openBuilder is SearchBarScreen);

        tester.tap(searchBarFinder);

        var searchBarWidgetFinder = find.byType(SearchBar);

        expect(searchBarWidgetFinder, findsOneWidget);
      });
    },
  );
}
