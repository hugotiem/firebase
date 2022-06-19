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

  /// If [amount] = null, withdraw all available amount from the wallet
  Future<void> withdraw(
      {required String walletId,
      required String bankAccountId,
      required int amount}) async {

        

    await _paymentService
        .withdraw(bankAccountId, amount, walletId: walletId)
        .then(
          (res) => res == QueryState.success
              ? emit(PaymentState.success())
              : emit(PaymentState.failed()),
        );
  }
}
