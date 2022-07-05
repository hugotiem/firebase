import 'dart:convert';

import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';
import 'package:pts/models/payments/wallet.dart';
import 'package:pts/models/payments/transaction.dart';
import 'package:pts/services/payment_service.dart';

import 'package:http/http.dart' as http;

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
    _paymentService
        .getUserTransactions(walletId)
        .then((transactions) async {
      if (transactions == null) return;
      emit(TransactionsState.transactionsLoaded(state.wallet, transactions));
      var recipientsMangopayId = transactions.map((e) => e.recipientId).toList()
        ..removeWhere((element) => element == userId);

      var authorsMangopayId = transactions.map((e) => e.recipientId).toList()
        ..removeWhere((element) => element == userId);

      final url =
          "https://us-central1-pts-beta-yog.cloudfunctions.net/getUsersByMangopayId";

      var body = jsonEncode({
        "mangoPayId": recipientsMangopayId..addAll(authorsMangopayId),
        "fields": ["name", "surname", "mangoPayId"]
      });

      try {
        final res = await http.post(Uri.parse(url), body: body);

        final json = jsonDecode(res.body);

        print(json);
      } catch (e) {
        print(e);
      }
    });
  }
}
