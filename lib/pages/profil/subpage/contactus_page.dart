import 'package:flutter/material.dart';
import 'package:pts/components/custom_text.dart';
import 'package:pts/const.dart';
import 'package:pts/widgets/custom_appbar.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: CustomAppBar(
        title: "Nous contacter",
        onPressed: () => Navigator.pop(context),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [SECONDARY_COLOR, ICONCOLOR])),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 22),
                CText(
                  "Pour nous contacter il vous suffit de nous envoyer un mail à l'adresse suivante:",
                  fontSize: 16,
                ),
                SizedBox(height: 8),
                SelectableText(
                  "pourtasoiree@gmail.com",
                  style: TextStyle(
                    fontSize: 14,
                    color: SECONDARY_COLOR,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
