import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pts/services/payment_service.dart';

void main() {
  late PaymentService paymentService;

  setUpAll(() {
    paymentService = PaymentService();
  });

  group("description", () {
    test("Create natural user", () async {
      print(paymentService.getTransactionFees(2000));

      // var name = "jean";
      // var surname = "dupont";
      // var email = "test@test.com";
      // var birth = Timestamp.fromDate(DateTime.now().toUtc());
      // var nationality = "FR";
      // var countryOfResidence = "FR";
      // var termsAndConditionsAccepted = true;
      // var id = await paymentService.createMangopayUser(name, surname, email,
      //     birth, nationality, countryOfResidence, termsAndConditionsAccepted);

      // if (id != null) {
      //   var walletId = await paymentService.createMangopayWallet(name, id);
      //   if (walletId != null) {
      //     var wallet = await paymentService.getUserWallet(walletId);
      //     if (wallet != null) {
      //       print(wallet.amount);
      //       var cardNumber = "4970101122334422";
      //       var expirationDate = "1025";
      //       var csv = "123";
      //       await paymentService.saveCardToMangopay(
      //           id, cardNumber, expirationDate, csv);
      //     }
      //   }
      // }
    });
  });
}
