import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'card_validation_detail.dart';

Widget buildValidationCard(BuildContext context, DocumentSnapshot party) {  
  return CardValidation(
    name: party['wait list'].toString(),
  );
}