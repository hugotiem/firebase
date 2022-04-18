import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pts/models/address.dart';
import 'package:pts/models/payments/bank_account.dart';
import 'package:pts/models/payments/card_registration.dart';
import 'package:pts/models/payments/credit_card.dart';
import 'package:pts/models/payments/wallet.dart';

enum KYCType { IDENTITY_PROOF, ADDRESS_PROOF }

class PaymentService {
  final String prefixUrl = "https://api.sandbox.mangopay.com";
  final String apiVersion = "v2.01";
  final String clientId = "ptstest";
  final String apiKey = "WEsMJm4EJDND0UsFvw1ngTYoDC56WwAndVZOAERWj8LKTu4020";
  final String url = "https://api.sandbox.mangopay.com/v2.01/ptstest";
  final Map<String, String> headers = {
    'Authorization':
        'Basic cHRzdGVzdDpXRXNNSm00RUpETkQwVXNGdncxbmdUWW9EQzU2V3dBbmRWWk9BRVJXajhMS1R1NDAyMA==',
    'Content-Type': 'application/json'
  };

  Future<String?> createMangopayUser(
      String name,
      String surname,
      String email,
      DateTime birth,
      String nationality,
      String countryOfResidence,
      bool termsAndConditionsAccepted) async {
    final String _url = "$url/users/natural/";

    var request = http.Request('POST', Uri.parse(_url));

    request.body = json.encode({
      "FirstName": name,
      "LastName": surname,
      "Birthday": (birth.toUtc().millisecondsSinceEpoch * 0.001).toInt(),
      "Nationality": nationality,
      "CountryOfResidence": countryOfResidence,
      "Email": email,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return json.decode(await response.stream.bytesToString())['Id'];
    }
    print(response.reasonPhrase);
    return null;
  }

  Future<String?> createMangopayWallet(String name, String id) async {
    final String _url = "$url/wallets";

    var request = http.Request('POST', Uri.parse(_url));

    request.body = json.encode({
      "Owners": [id],
      "Description": "$name's wallet",
      "Currency": "EUR",
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return json.decode(await response.stream.bytesToString())['Id'];
    }
    print(response.reasonPhrase);
    return null;
  }

  Future<void> getUserById(String userId) async {
    final String _url = "$url/users/$userId";

    var request = http.Request('GET', Uri.parse(_url));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {}
  }

  Future<Wallet?> getUserWallet(String walletId) async {
    final String _url = "$url/wallets/$walletId";

    var request = http.Request('GET', Uri.parse(_url));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var map = json.decode(await response.stream.bytesToString());
      return Wallet.fromJson(map);
    }
    print(response.reasonPhrase);
    return null;
  }

  Future<Wallet?> getWalletByUserId(String userId) async {
    final String _url = "$url/users/$userId/wallets/";

    var request = http.Request('GET', Uri.parse(_url));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var map = json.decode(await response.stream.bytesToString());
      return Wallet.fromJson(map[0]);
    }
    print(response.reasonPhrase);
    return null;
  }

  Future<CardRegistration?> _createCardRegistration(String userId) async {
    final String currency = 'EUR';
    final String _url = "$url/cardregistrations";

    var request = http.Request('POST', Uri.parse(_url));

    request.body = json.encode({
      "UserId": userId,
      "Currency": currency,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var map = json.decode(await response.stream.bytesToString());
      return CardRegistration.fromJson(map);
    }
    print(response.reasonPhrase);
    return null;
  }

  Future<String?> _postCardDataInfo(
      String userId,
      CardRegistration cardRegistration,
      String cardNumber,
      String expirationDate,
      String csv) async {
    final String _url = cardRegistration.cardRegistrationURL;

    var request = http.Request('POST', Uri.parse(_url));

    request.bodyFields = {
      "accessKeyRef": cardRegistration.accessKey,
      "data": cardRegistration.preRegistrationData,
      "cardNumber": cardNumber,
      "cardExpirationDate": expirationDate,
      "cardCvx": csv,
      "returnURL": "",
    };

    request.headers
        .addAll({"Content-Type": "application/x-www-form-urlencoded"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    }
    print(response.reasonPhrase);
    return null;
  }

  Future<void> saveCardToMangopay(String userId, String cardNumber,
      String expirationDate, String csv) async {
    final CardRegistration? _cardRegistration =
        await _createCardRegistration(userId);

    if (_cardRegistration == null) {
      return;
    }

    final String? _registrationData = await _postCardDataInfo(
        userId, _cardRegistration, cardNumber, expirationDate, csv);

    if (_registrationData == null) {
      return;
    }

    var _url = "$url/CardRegistrations/${_cardRegistration.id}";

    var request = http.Request('PUT', Uri.parse(_url));

    request.body = json.encode({"RegistrationData": _registrationData});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return print("SUCCESS");
    }
    return print(response.reasonPhrase);
  }

  Future<List<CreditCard>?> getUserCreditCards(String userId) async {
    final String _url = "$url/users/$userId/cards";

    var request = http.Request('GET', Uri.parse(_url));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var map = json.decode(await response.stream.bytesToString());
      return (map as List)
          .map<CreditCard>((e) => CreditCard.fromJson(e))
          .toList();
    }
    print(response.reasonPhrase);
    return null;
  }

  Future<void> desactivateCard(String cardId) async {
    final String _url = "$url/cards/$cardId";

    var request = http.Request('PUT', Uri.parse(_url));

    request.body = json.encode({"Active": "false"});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return print('SUCCESS');
    }
    print(response.reasonPhrase);
    return print('FAILED');
  }

  Future<String?> _createKYCDocument(String userId, KYCType type) async {
    final String _url = "$url/users/$userId/kyc/documents/";

    var request = http.Request('POST', Uri.parse(_url));

    request.body = json.encode({"Type": describeEnum(type)});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return json.decode(await response.stream.bytesToString())["Id"];
    }
    print(response.reasonPhrase);
    return null;
  }

  Future<String?> _createKYCPage(String userId, File file, KYCType type) async {
    final String? _documentId = await _createKYCDocument(userId, type);
    if (_documentId == null) {
      return null;
    }

    final String _url = "$url/users/$userId/kyc/documents/$_documentId/pages/";
    final String _file = base64Encode(await file.readAsBytes());

    var request = http.Request('POST', Uri.parse(_url));

    request.body = json.encode({"File": _file});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return json.decode(await response.stream.bytesToString())["Id"];
    }
    print(response.reasonPhrase);
    return null;
  }

  Future<void> submitKYCDocument(String userId, File file,
      {KYCType type = KYCType.IDENTITY_PROOF}) async {
    final String? _documentId = await _createKYCPage(userId, file, type);
    if (_documentId == null) {
      return;
    }
    final String _url = "$url/users/$userId/kyc/documents/$_documentId";

    var request = http.Request('PUT', Uri.parse(_url));

    request.body = json.encode({"Status": "VALIDATION_ASKED"});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return print('SUCCESS');
    }
    print(response.reasonPhrase);
    return print("FAILED");
  }

  Future<void> cardDirectPayin(String userId, int amount, String cardId) async {
    final Wallet? wallet = await getWalletByUserId(userId);
    if (wallet == null) {
      return;
    }

    final String _url = "$url/payins/card/direct";
    final String _currency = 'EUR';

    var request = http.Request('POST', Uri.parse(_url));

    request.body = json.encode({
      "AuthorId": userId,
      "CreditedWalletId": wallet.id,
      "DebitedFunds": {
        "Currency": _currency,
        "Amount": amount,
      },
      "Fees": {
        "Currency": _currency,
        "Amount": getTransactionFees(amount),
      },
      "CardId": cardId,
      "SecureMode": "DEFAULT",
      "SecureModeReturnURL": "https://google.com"
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return print('SUCCESS');
    }
    print(response.reasonPhrase);
    return print('FAILED');
  }

  Future<String?> addIBANBankAccount(
      String userId, String fullname, Address address, String iban) async {
    final String _url = "$url/users/$userId/bankaccounts/iban/";

    var request = http.Request('POST', Uri.parse(_url));

    request.body = json.encode({
      "OwnerName": fullname,
      "OwnerAddress": {
        "AddressLine1": address.streetName,
        "City": address.city,
        "Region": address.region,
        "PostalCode": address.postalCode,
        "Country": "FR",
      },
      "IBAN": iban,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return json.decode(await response.stream.bytesToString())['Id'];
    }
    print(response.reasonPhrase);
    return null;
  }

  Future<List<BankAccount>?> getUserBankAccounts(String userId) async {
    final String _url = "$url/users/$userId/bankaccounts/";

    var request = http.Request('GET', Uri.parse(_url));

    request.body = json.encode({
      "Page": 1,
      "Per_Page": 20,
      "Sort": "CreationDate:DESC",
      "Active": true,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var map = json.decode(await response.stream.bytesToString()) as List;
      return map.map<BankAccount>((e) => BankAccount.fromJson(e)).toList();
    }
    print(response.reasonPhrase);
    return null;
  }

  Future<void> withdraw(String userId, String bankAccountId, int amount) async {
    final Wallet? wallet = await getWalletByUserId(userId);
    if (wallet == null) {
      return;
    }

    final String _url = "$url/payouts/bankwire/";
    final String _currency = "EUR";

    var request = http.Request('POST', Uri.parse(_url));

    request.body = json.encode({
      "AuthorId": userId,
      "DebitedFunds": {
        "Currency": _currency,
        "Amount": amount,
      },
      "Fees": {
        "Currency": _currency,
        "Amount": 0,
      },
      "BankAccountId": bankAccountId,
      "DebitedWalletId": wallet.id,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return print('SUCCESS');
    }
    print(response.reasonPhrase);
    return print('FAILED');
  }

  Future<String?> transfer(
      String userId, String creditedWalletId, int amount) async {
    final Wallet? wallet = await getWalletByUserId(userId);
    if (wallet == null) {
      return null;
    }

    final String _url = "$url/transfers/";
    final String _currency = "EUR";

    var request = http.Request('POST', Uri.parse(_url));

    request.body = json.encode({
      "AuthorId": userId,
      "DebitedFunds": {
        "Currency": _currency,
        "Amount": amount,
      },
      "Fees": {
        "Currency": _currency,
        "Amount": 0,
      },
      "DebitedWalletId": wallet.id,
      "CreditedWalletId": creditedWalletId,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return json.decode(await response.stream.bytesToString())['Status'];
    }
    print(response.reasonPhrase);
    return null;
  }

  int getTransactionFees(int amount) {
    double fees = (amount * 0.01) * 0.18;
    return (double.parse(fees.toStringAsFixed(2)) * 100).toInt();
  }
}

class InsufficientFundsError extends Error {
  InsufficientFundsError();
  @override
  String toString() {
    return "InsufficientFundsError: founds must be more than 0";
  }
}




// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

// import 'package:http/http.dart' as http;

// class PaymentService {
//   late int _amount;

//   PaymentService({required int amount}) {
//     this._amount = amount;
//   }

//   static Future<void> init() async {
//     Stripe.publishableKey =
//         "pk_test_51J7plnEBJbFZnzaljRUZVHTAnpFgFrXEH2F6WIaAkkIwS9pGJpNbjpXLtrs1C834HdVmAgvfwzNFLQfftTLmbbWr00xFpraPsC";
//     Stripe.merchantIdentifier = 'pts';
//     // Stripe.urlSc
//     await Stripe.instance.applySettings();
//   }

//   // Future<PaymentMethod?> createPaymentMethod() async {
//   //   print('transaction amount: $_amount');

//   //   // PaymentMethod? paymentMethod = await Stripe.instance.initPaymentSheet(paymentSheetParameters: paymentSheetParameters);
//   // }

//   Future<bool> initPaymentSheet(BuildContext context,
//       {required String? email, int? amount}) async {
//     int pAmount = amount ?? _amount;
//     try {
//       final res = await http.post(
//         Uri.parse(
//             "https://us-central1-pts-beta-yog.cloudfunctions.net/stripePaymentIntentRequest"),
//         body: {
//           'email': email,
//           'amount': pAmount.toString(),
//         },
//       );

//       final json = jsonDecode(res.body);

//       log(json.toString());

//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: json['paymentIntent'],
//           merchantDisplayName: "PTS",
//           customerId: json['customer'],
//           customerEphemeralKeySecret: json['ephemeralKey'],
//           style: ThemeMode.light,
//           testEnv: true,
//           merchantCountryCode: 'FRA',
//         ),
//       );

//       await Stripe.instance.presentPaymentSheet();

//       return true;
//     } catch (e) {
//       print("payment failed: $e");
//       return false;
//     }
//   }
// }
