import 'package:flutter/material.dart';
import 'package:pts/components/appbar.dart';
import 'package:pts/components/custom_text.dart';
import 'package:pts/const.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(
          title: TitleAppBar('Nous contacter'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 22),
            CText(
              "Pour nous contacter il vous suffit de nous envoyer un mail à l'addresse suivante:",
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
    );
  }
}
