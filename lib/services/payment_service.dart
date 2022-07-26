import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pts/models/address.dart';
import 'package:pts/models/payments/bank_account.dart';
import 'package:pts/models/payments/card_registration.dart';
import 'package:pts/models/payments/credit_card.dart';
import 'package:pts/models/payments/transaction.dart';
import 'package:pts/models/payments/wallet.dart';

enum KYCType { IDENTITY_PROOF, ADDRESS_PROOF }

enum KYCStatus { VALIDATION_ASKED, SUCCEEDED, OUT_OF_DATE }

enum QueryState { success, failed }

class PaymentService {
  // final String prefixUrl = "https://api.sandbox.mangopay.com";
  // final String apiVersion = "v2.01";
  // final String clientId = "ptstest";
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

  Future<String?> createMangopayWallet(WalletType type, String id) async {
    final String _url = "$url/wallets";

    var request = http.Request('POST', Uri.parse(_url));

    request.body = json.encode({
      "Owners": [id],
      "Description": describeEnum(type),
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

  Future<Map<WalletType, Wallet>?> getWalletByUserId(String? userId) async {
    final String _url = "$url/users/$userId/wallets/";

    var request = http.Request('GET', Uri.parse(_url));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var list = json.decode(await response.stream.bytesToString()) as List;
      Map<WalletType, Wallet> map = {};
      map[WalletType.MAIN] = Wallet.fromJson(list
          .where((element) => element["Description"] == "MAIN")
          .toList()[0]);
      map[WalletType.PENDING] = Wallet.fromJson(list
          .where((element) => element["Description"] == "PENDING")
          .toList()[0]);
      return map;
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

  Future<String> saveCardToMangopay(String userId, String cardNumber,
      String expirationDate, String csv) async {
    final CardRegistration? _cardRegistration =
        await _createCardRegistration(userId);

    if (_cardRegistration == null) {
      return "null";
    }

    final String? _registrationData = await _postCardDataInfo(
        userId, _cardRegistration, cardNumber, expirationDate, csv);

    if (_registrationData == null) {
      return "null";
    }

    var _url = "$url/CardRegistrations/${_cardRegistration.id}";

    var request = http.Request('PUT', Uri.parse(_url));

    request.body = json.encode({"RegistrationData": _registrationData});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return "SUCCESS";
    }
    return response.reasonPhrase.toString();
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
    print("creating document ...");
    final String _url = "$url/users/$userId/kyc/documents/";

    var request = http.Request('POST', Uri.parse(_url));

    request.body = json.encode({"Type": describeEnum(type)});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("Document created");
      return json.decode(await response.stream.bytesToString())["Id"];
    }
    print(response.reasonPhrase);
    return null;
  }

  Future<String?> _createKYCPage(String userId, File file, KYCType type,
      {File? verso}) async {
    print("creating page ...");
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

    if (response.statusCode == 204) {
      print("page created");
      if (verso != null) {
        final String _file2 = base64Encode(await verso.readAsBytes());

        var request = http.Request('POST', Uri.parse(_url));

        request.body = json.encode({"File": _file2});

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 204) {
          print("page 2 created");
          return _documentId;
        }
      }
      return _documentId;
    }
    print(response.reasonPhrase);
    return null;
  }

  Future<QueryState> submitKYCDocument(String userId, File file,
      {File? verso, KYCType type = KYCType.IDENTITY_PROOF}) async {
    final String? _documentId =
        await _createKYCPage(userId, file, type, verso: verso);
    if (_documentId == null) {
      return QueryState.failed;
    }
    final String _url = "$url/users/$userId/kyc/documents/$_documentId";

    var request = http.Request('PUT', Uri.parse(_url));

    request.body = json.encode({"Status": "VALIDATION_ASKED"});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return QueryState.success;
    }
    print(response.reasonPhrase);
    return QueryState.failed;
  }

  Future<void> cardDirectPayin(String? userId, int amount, String cardId,
      {String? sellerId}) async {
    final Map<WalletType, Wallet>? _wallets =
        await getWalletByUserId(sellerId ?? userId);

    if (_wallets == null) {
      return;
    }

    final WalletType _walletType =
        sellerId == null ? WalletType.MAIN : WalletType.PENDING;

    final Wallet _wallet = _wallets[_walletType]!;

    final String _url = "$url/payins/card/direct";
    final String _currency = 'EUR';

    var request = http.Request('POST', Uri.parse(_url));

    request.body = json.encode({
      "AuthorId": userId,
      "CreditedWalletId": _wallet.id,
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

  Future<QueryState> addIBANBankAccount(
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
      return QueryState.success;
      // return json.decode(await response.stream.bytesToString())['Id'];
    }
    print(response.reasonPhrase);
    return QueryState.failed;
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

  Future<QueryState> withdraw(String bankAccountId, int amount,
      {String? userId, String? walletId}) async {
    if (walletId == null) {
      if (userId == null) {
        print("WalletId or userId should not be null");
        return QueryState.failed;
      }
      final Map<WalletType, Wallet>? _wallets = await getWalletByUserId(userId);
      if (_wallets == null) {
        return QueryState.failed;
      }
      final Wallet? wallet = _wallets[WalletType.MAIN];

      if (wallet == null) return QueryState.failed;

      walletId = wallet.id;
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
      "DebitedWalletId": walletId,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('SUCCESS');
      return QueryState.success;
    }
    print(response.reasonPhrase);
    print('FAILED');
    return QueryState.failed;
  }

  Future<String?> transfer(String? userId, String creditedWalletId, int amount,
      {bool refound = false}) async {
    if (userId == null) return null;
    final Map<WalletType, Wallet>? _wallets = await getWalletByUserId(userId);
    if (_wallets == null) {
      return null;
    }

    final Wallet? _wallet =
        _wallets[refound ? WalletType.MAIN : WalletType.PENDING];

    if (_wallet == null) return null;

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
      "DebitedWalletId": _wallet.id,
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

  Future<Wallet?> getWalletById(String walletId) async {
    final String _url = "$url/wallets/$walletId";

    var request = http.Request('GET', Uri.parse(_url));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var wallet = json.decode(await response.stream.bytesToString());
      return Wallet.fromJson(wallet);
    }
    return null;
  }

  Future<List<Transaction>?> getUserTransactions(String walletId,
      {int? page}) async {
    final String _url =
        "$url/wallets/$walletId/transactions?Sort=CreationDate:DESC";

    var request = http.Request('GET', Uri.parse(_url));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var transactions =
          json.decode(await response.stream.bytesToString()) as List;
      return transactions
          .map<Transaction>((e) => Transaction.fromJson(e))
          .toList();
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
