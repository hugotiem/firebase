import 'package:equatable/equatable.dart';
import 'package:pts/models/user.dart';

enum TransactionType { NONE, PAYIN, TRANSFER, PAYOUT }

class Transaction extends Equatable {
  final int? amount;
  final TransactionType? type;
  final DateTime? date;
  final String? authorId;
  final String? tag;
  final String? recipientId;
  final String? status;
  final User? user;

  Transaction({
    this.amount,
    this.type,
    this.date,
    this.authorId,
    this.tag,
    this.recipientId,
    this.status,
    this.user,
  });

  static TransactionType getType(String type) {
    switch (type) {
      case "PAYIN":
        return TransactionType.PAYIN;
      case "TRANSFER":
        return TransactionType.TRANSFER;
      case "PAYOUT":
        return TransactionType.PAYOUT;
      default:
        return TransactionType.NONE;
    }
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
        amount: json["DebitedFunds"]["Amount"],
        type: getType(json["Type"]),
        date: DateTime.fromMillisecondsSinceEpoch(json["CreationDate"] * 1000),
        authorId: json['AuthorId'],
        tag: json["Tag"],
        recipientId: json["CreditedUserId"],
        status: json["Status"]);
  }

  @override
  List<Object?> get props =>
      [type, amount, date, authorId, tag, recipientId, status];
}
