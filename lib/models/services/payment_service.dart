import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:http/http.dart' as http;

class PaymentService {
  late double _amount;

  PaymentService({required double amount}) {
    this._amount = amount;
  }

  static Future<void> init() async {
    Stripe.publishableKey =
        "pk_test_51J7plnEBJbFZnzaljRUZVHTAnpFgFrXEH2F6WIaAkkIwS9pGJpNbjpXLtrs1C834HdVmAgvfwzNFLQfftTLmbbWr00xFpraPsC";
    Stripe.merchantIdentifier = 'pts';
    // Stripe.urlSc
    await Stripe.instance.applySettings();
  }

  Future<PaymentMethod?> createPaymentMethod() async {
    print('transaction amount: $_amount');

    // PaymentMethod? paymentMethod = await Stripe.instance.initPaymentSheet(paymentSheetParameters: paymentSheetParameters);
  }

  Future<void> initPaymentSheet(BuildContext context,
      {required String? email, double? amount}) async {
    double pAmount = amount ?? _amount;
    try {
      final res = await http.post(
        Uri.parse(
            "https://us-central1-pts-beta-yog.cloudfunctions.net/stripePaymentIntentRequest"),
        body: {
          'email': email,
          'amount': pAmount.toString(),
        },
      );

      final json = jsonDecode(res.body);

      log(json.toString());

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: json['paymentIntent'],
          merchantDisplayName: "PTS",
          customerId: json['customer'],
          customerEphemeralKeySecret: json['ephemeralKey'],
          style: ThemeMode.light,
          testEnv: true,
          merchantCountryCode: 'FRA',
          allowsDelayedPaymentMethods: true,
          customFlow: true,
        ),
      );

      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      print("payment failed: $e");
    }
  }

  // Future<void> processPayment(PaymentMethod paymentMethod) async {}
}
