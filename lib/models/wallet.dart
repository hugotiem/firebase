import 'package:equatable/equatable.dart';

class Wallet extends Equatable {
  final String id;
  final String desc;
  final double amount;
  final String currency;
  final String ownerId;

  Wallet(this.id, this.desc, this.amount, this.currency, this.ownerId);

  factory Wallet.fromJson(Map<String, dynamic> json) {
    var id = json['Id'];
    var desc = json['Description'];
    var amount = (json["Balance"]['Amount'] as int) * 0.01;
    var currency = json["Balance"]['Currency'];
    var ownerId = json['Owners'][0];

    return Wallet(id, desc, amount, currency, ownerId);
  }

  @override
  List<Object?> get props => [id, desc, amount, currency, ownerId];
}
