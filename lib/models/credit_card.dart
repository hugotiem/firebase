import 'package:cloud_firestore/cloud_firestore.dart';

class CreditCard {
  String? cardNumber;
  String? expiryDate;
  String? cardHolderName;
  String? cvvCode;
  String? showBackView;

  CreditCard(  
    this.cardHolderName,
    this.cardNumber,
    this.cvvCode,
    this.expiryDate,
    this.showBackView,
  );

  factory CreditCard.fromSnapShots(  
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
      var data = snapshot.data();
      var cardNumber = data['cardNumber'];
      var expiryDate = data['expiryDate'];
      var cardHolderName = data['cardHolderName'];
      var cvvCode = data['cvvCode'];
      var showBackView = data['showBackView'];
      return CreditCard(  
        cardNumber,
        expiryDate,
        cardHolderName,
        cvvCode,
        showBackView 
      );
  }
}