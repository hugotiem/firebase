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

  Future<void> registerCard(String? userMangoPayId, String cardNumber,
      String endDate, String cvv) async {
    if (userMangoPayId == null) {
      return emit(CardRegistrationState.failed());
    }
    emit(state.setRequestInProgress() as CardRegistrationState);
    var register = await _mangopay.saveCardToMangopay(userMangoPayId,
        cardNumber.replaceAll(" ", ""), endDate.replaceAll("/", ""), cvv);
    if (register == "SUCCESS") {
      return emit(CardRegistrationState.dataLoaded(state.cards));
    } else
      return emit(CardRegistrationState.failed());
  }
}
