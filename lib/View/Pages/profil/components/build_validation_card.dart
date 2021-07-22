import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'card_validation_detail.dart';

Widget buildValidationCard(BuildContext context, DocumentSnapshot party) {  
  int itemCount = party['wait list'].length;
  return Stack(
    children: [
      CardValidation(
        title: party['Name'],
        name: party['wait list'].toString(),
        itemCount: itemCount,
      ),
    ]
  );
}