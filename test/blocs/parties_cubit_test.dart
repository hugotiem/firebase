import 'package:bloc_test/bloc_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import '../mocks/services_mock.dart';

void main() {
  late PartiesCubit partiesCubit;

  late MockFireStoreService mockFireStoreService;

  late MockFireStoreService userMockFireStoreService;

  late MockAuthService mockAuthService;

  late FakeFirebaseFirestore instance;

  late var snapshot;

  group("PartiesCubit tests", () {
    setUp(() async {
      mockFireStoreService = MockFireStoreService();
      userMockFireStoreService = MockFireStoreService();
      mockAuthService = MockAuthService();

      partiesCubit = PartiesCubit(
        services: mockFireStoreService,
        userServices: userMockFireStoreService,
        auth: mockAuthService,
      );
    });

    group("return random String", () {
      test("with length = 5 when input is 5", () {
        String random = partiesCubit.getRandomString(5);
        expect(random.length, 5);
      });

      test("empty when input is negative", () {
        String random = partiesCubit.getRandomString(-3);
        expect(random, isEmpty);
      });
    });

    group("bloc tests", () {
      setUp(() async {
        instance = FakeFirebaseFirestore();

        await instance.collection('partiesTest').add({
          'name': 'test',
          'address': "",
          'animals': true,
          'city': '',
          'coordinates': [0, 0],
          'date': DateTime.now().toIso8601String(),
          'desc': "",
          'endTime':
              DateTime.now().add(const Duration(minutes: 2)).toIso8601String(),
          'isActive': true,
          'number': "",
          'party owner': "",
          'postal code': "",
          'price': 0,
          'startTime': DateTime.now().toIso8601String(),
          'theme': "",
          'waitList': [],
        });

        snapshot = await instance.collection('users').get();

        mockFireStoreService = MockFireStoreService();
        userMockFireStoreService = MockFireStoreService();
        mockAuthService = MockAuthService();

        partiesCubit = PartiesCubit(
          services: mockFireStoreService,
          userServices: userMockFireStoreService,
          auth: mockAuthService,
        );
      });

      blocTest(
        "getDataWithWhereIsEqualTo method emit dataLoaded state when data provided",
        build: () {
          when(() => mockFireStoreService.getDataWithWhereIsEqualTo(
              "keyTester", "valueTester")).thenAnswer((_) async => snapshot);
          return partiesCubit;
        },
        act: (PartiesCubit cubit) async =>
            cubit.fetchPartiesWithWhereIsEqualTo("keyTester", "valueTester"),
        expect: () => [
          PartiesState.initial().setRequestInProgress(),
          PartiesState.loaded(null, null),
        ],
      );

      blocTest(
        "getDataWithWhereIsEqualTo method does not emit when data is null",
        build: () {
          when(() => mockFireStoreService.getDataWithWhereIsEqualTo(
              "keyTester", "valueTester")).thenAnswer((_) async => snapshot);
          return partiesCubit;
        },
        act: (PartiesCubit cubit) async =>
            cubit.fetchPartiesWithWhereIsEqualTo("keyTester", null),
        expect: () => [],
      );
    });
  });
}
