import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:pts/models/card_registration.dart';
import 'package:pts/models/credit_card.dart';
import 'package:pts/models/wallet.dart';

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
      Timestamp birth,
      String nationality,
      String countryOfResidence,
      bool termsAndConditionsAccepted) async {
    final String _url = "$url/users/natural/";

    var request = http.Request('POST', Uri.parse(_url));

    request.body = json.encode({
      "FirstName": name,
      "LastName": surname,
      "Birthday": -258443002,
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
