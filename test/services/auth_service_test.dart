import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pts/services/auth_service.dart';
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

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late AuthService authService;

  late MockFlutterSecureStorage mockFlutterSecureStorage;

  group("auth services tests", () {
    setUp(() async {
      setupCloudFirestoreMocks();

      await Firebase.initializeApp();

      mockFlutterSecureStorage = MockFlutterSecureStorage();

      authService = AuthService(secureStorage: mockFlutterSecureStorage);

      when(() =>
              mockFlutterSecureStorage.write(key: 'token', value: "tokenTest"))
          .thenAnswer((_) async => null);
      await authService.setToken("tokenTest");
    });

    test("get user token", () async {
      when(() => mockFlutterSecureStorage.read(key: 'token'))
          .thenAnswer((_) async => "tokenTest");
      var token = await authService.getToken();
      expect(token, "tokenTest");
    });
  });
}
