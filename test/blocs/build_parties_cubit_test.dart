import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pts/blocs/parties/build_parties_cubit.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';

typedef Callback(MethodCall call);

setupCloudFirestoreMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFirebase.channel.setMockMethodCallHandler((call) async {
    if (call.method == 'Firebase#initializeCore') {
      return [
        {
          'name': defaultFirebaseAppName,
          'options': {
            'apiKey': '123',
            'appId': '123',
            'messagingSenderId': '123',
            'projectId': '123',
          },
          'pluginConstants': {},
        }
      ];
    }

    if (call.method == 'Firebase#initializeApp') {
      return {
        'name': call.arguments['appName'],
        'options': call.arguments['options'],
        'pluginConstants': {},
      };
    }

    if (customHandlers != null) {
      customHandlers(call);
    }

    return null;
  });
}

void main() {
  late BuildPartiesCubit buildPartiesCubit;

  group("build parties cubit tests", () {
    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();

      setupCloudFirestoreMocks();

      await Firebase.initializeApp();

      buildPartiesCubit = BuildPartiesCubit();
    });

    blocTest('add item to a bloc',
        build: () {
          return buildPartiesCubit;
        },
        act: (BuildPartiesCubit cubit) => cubit.addItem("test", "test value"),
        expect: () => [
              BuildPartiesState.adding(),
              BuildPartiesState.added(null)
            ],
        verify: (BuildPartiesCubit cubit) {
          expect(cubit.state.parties?.containsKey('test'), true);
          expect(cubit.state.parties?.containsValue('test value'), true);
        });
  });
}
