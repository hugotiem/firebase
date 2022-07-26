part of 'bank_account_cubit.dart';

enum BankAccountStatus { initial, dataLoaded, dataAdded, failed }

class BankAccountState extends AppBaseState<BankAccountStatus> {
  final List<BankAccount>? bankAccounts;

  const BankAccountState(BankAccountStatus? status,
      {this.bankAccounts,
      bool requestInProgress = false,
      String? requestFailureCode,
      String? requestFailureMessage})
      : super(
            status: status,
            requestInProgress: requestInProgress,
            requestFailureCode: requestFailureCode,
            requestFailureMessage: requestFailureMessage);

  const BankAccountState.initial() : this(BankAccountStatus.initial);
  const BankAccountState.failed() : this(BankAccountStatus.failed);
  const BankAccountState.dataLoaded(List<BankAccount>? bankAccounts)
      : this(BankAccountStatus.dataLoaded, bankAccounts: bankAccounts);
  const BankAccountState.dataAdded() : this(BankAccountStatus.dataAdded);

  @override
  BankAccountState copyWith(
          {List<BankAccount>? bankAccounts,
          bool requestInProgress = false,
          String? requestFailureCode,
          String? requestFailureMessage}) =>
      BankAccountState(this.status);

  @override
  List<Object?> get props => super.props..addAll([bankAccounts]);
}
