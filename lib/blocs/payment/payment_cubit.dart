import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';
import 'package:pts/services/payment_service.dart';

part 'payment_state.dart';

class PaymentCubit extends AppBaseCubit<PaymentState> {
  PaymentCubit() : super(PaymentState.initial());

  final PaymentService _paymentService = PaymentService();

  Future<void> purchase(String purchaseType,
      {required String? userId,
      required int amount,
      required String selectedPurchaseId,
      String? creditedUserId}) async {
    if (purchaseType == "WALLET") {
      await _paymentService.transfer(userId, selectedPurchaseId, amount);
    }
    await _paymentService.cardDirectPayin(userId, amount, selectedPurchaseId,
        sellerId: creditedUserId);
  }
}
