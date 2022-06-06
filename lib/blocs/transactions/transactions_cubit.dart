import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';
import 'package:pts/models/payments/wallet.dart';
import 'package:pts/models/payments/transaction.dart';
import 'package:pts/services/payment_service.dart';

part 'transactions_state.dart';

class TransactionsCubit extends AppBaseCubit<TransactionsState> {
  TransactionsCubit() : super(TransactionsState.initial());

  final PaymentService _paymentService = PaymentService();

  Future<void> loadData(String userId) async {
    await _paymentService.getWalletByUserId(userId).then((value) async {
      var wallet = value?[WalletType.MAIN];
      if (wallet == null) return;
      emit(TransactionsState.walletLoaded(wallet));

      await getUserTransactions(wallet.id, userId);
    });
  }

  Future<void> getUserTransactions(String walletId, String userId) async {
    _paymentService.getUserTransactions(walletId, userId).then((transactions) {
      if (transactions == null) return;
      
      emit(TransactionsState.transactionsLoaded(state.wallet, transactions));
    });
  }
}
