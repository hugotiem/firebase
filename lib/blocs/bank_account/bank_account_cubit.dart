import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';
import 'package:pts/models/payments/bank_account.dart';
import 'package:pts/services/firestore_service.dart';
import 'package:pts/services/payment_service.dart';

part 'bank_account_state.dart';

class BankAccountCubit extends AppBaseCubit<BankAccountState> {
  BankAccountCubit() : super(BankAccountState.initial());

  final PaymentService _paymentService = PaymentService();
  final FireStoreServices _firestore = FireStoreServices("user");

  Future<void> loadData(String? userId) async {
    if (userId == null) return emit(BankAccountState.failed());
    var bankAccounts = await _paymentService.getUserBankAccounts(userId);
    if (bankAccounts == null) return emit(BankAccountState.failed());
    emit(BankAccountState.dataLoaded(bankAccounts));
  }

  Future<void> refresh() async {}
}
