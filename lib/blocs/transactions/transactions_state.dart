part of 'transactions_cubit.dart';

enum TransactionStatus { initial, walletLoaded, transactionsLoaded }

class TransactionsState extends AppBaseState<TransactionStatus> {
  final Wallet? wallet;
  final List<Transaction>? transactions;

  const TransactionsState(TransactionStatus? status,
      {this.wallet,
      this.transactions,
      bool requestInProgress = false,
      String? requestFailureCode,
      String? requestFailureMessage})
      : super(
            status: status,
            requestInProgress: requestInProgress,
            requestFailureCode: requestFailureCode,
            requestFailureMessage: requestFailureMessage);

  const TransactionsState.initial() : this(TransactionStatus.initial);
  const TransactionsState.walletLoaded(Wallet wallet)
      : this(TransactionStatus.walletLoaded, wallet: wallet);
  const TransactionsState.transactionsLoaded(
      Wallet? wallet, List<Transaction> transactions)
      : this(TransactionStatus.transactionsLoaded,
            wallet: wallet, transactions: transactions);

  TransactionsState copyWith(
          {bool requestInProgress = false,
          String? requestFailureCode,
          String? requestFailureMessage}) =>
      TransactionsState(this.status,
          requestInProgress: requestInProgress,
          requestFailureCode: requestFailureCode,
          requestFailureMessage: requestFailureMessage);
}
