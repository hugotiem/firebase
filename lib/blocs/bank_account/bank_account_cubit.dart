import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';
import 'package:pts/models/address.dart';
import 'package:pts/models/payments/bank_account.dart';
import 'package:pts/services/payment_service.dart';

part 'bank_account_state.dart';

class BankAccountCubit extends AppBaseCubit<BankAccountState> {
  BankAccountCubit() : super(BankAccountState.initial());

  final PaymentService _paymentService = PaymentService();

  Future<void> loadData(String? userId) async {
    if (userId == null) return emit(BankAccountState.failed());
    var bankAccounts = await _paymentService.getUserBankAccounts(userId);
    if (bankAccounts == null) return emit(BankAccountState.failed());
    emit(BankAccountState.dataLoaded(bankAccounts));
  }

  Future<void> addBankAccount(
      String userId, String ownerName, Address address, String iban) async {
    await _paymentService
        .addIBANBankAccount(userId, ownerName, address, iban)
        .then((value) {
      if (value == QueryState.success) {
        return emit(BankAccountState.dataAdded());
      }
      return emit(BankAccountState.failed());
    });
  }

  Future<void> refresh(String? userId) async {
    if (userId == null) return;
    emit(state.setRequestInProgress() as BankAccountState);
    loadData(userId);
  }
}
