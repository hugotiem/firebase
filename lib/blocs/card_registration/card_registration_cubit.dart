import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';
import 'package:pts/models/payments/credit_card.dart';
import 'package:pts/services/payment_service.dart';

part 'card_registration_state.dart';

class CardRegistrationCubit extends AppBaseCubit<CardRegistrationState> {
  CardRegistrationCubit() : super(CardRegistrationState.initial());

  final PaymentService _mangopay = PaymentService();

  Future<void> loadData(String? userMangopayId) async {
    if (userMangopayId == null) {
      return emit(CardRegistrationState.failed());
    }
    var cards = await _mangopay.getUserCreditCards(userMangopayId);
    if (cards == null) {
      return emit(CardRegistrationState.failed());
    }
    return emit(CardRegistrationState.dataLoaded(cards));
  }
}
