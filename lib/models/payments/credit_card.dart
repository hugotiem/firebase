import 'package:equatable/equatable.dart';

class CreditCard extends Equatable {
  final String id;
  final String alias;
  final String expirationDate;
  final String mangopayUserId;
  final String cardProvider;
  final bool validity;

  CreditCard(
    this.id,
    this.mangopayUserId,
    this.alias,
    this.expirationDate,
    this.cardProvider,
    this.validity,
  );

  factory CreditCard.fromJson(Map<String, dynamic> json) {
    var id = json['Id'];
    var alias = json['Alias'];
    var expirationDate = json['ExpirationDate'];
    var mangopayUserId = json['UserId'];
    var cardProvider = json['CardProvider'];
    var validity = json['Validity'] == 'VALID';
    return CreditCard(
        id, mangopayUserId, alias, expirationDate, cardProvider, validity);
  }

  @override
  List<Object?> get props =>
      [id, alias, expirationDate, mangopayUserId, cardProvider, validity];
}
