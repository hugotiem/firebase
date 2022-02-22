import 'package:mocktail/mocktail.dart';
import 'package:pts/models/services/auth_service.dart';
import 'package:pts/models/services/firestore_service.dart';
import 'package:pts/models/services/payment_service.dart';

class MockAuthService extends Mock implements AuthService {}
class MockFireStoreService extends Mock implements FireStoreServices {}
class MockPaymentServie extends Mock implements PaymentService {}

// Unit tests => 