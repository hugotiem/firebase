import 'package:equatable/equatable.dart';

class BankAccount extends Equatable {
  final String id;
  final String owner;
  final String accountNumber;
  final String? bankName;
  final String iban;
  final String bic;

  const BankAccount(
      this.id, this.owner, this.accountNumber, this.iban, this.bic,
      {this.bankName});

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    var id = json['Id'];
    var owner = json['OwnerName'];
    var accountNumber = json['AccountNumber'];
    var iban = json['IBAN'];
    var bic = json['BIC'];
    var bankName = json['BankName'];
    return BankAccount(id, owner, accountNumber, iban, bic, bankName: bankName);
  }

  @override
  List<Object?> get props => [owner, accountNumber, iban, bic, bankName];
}
