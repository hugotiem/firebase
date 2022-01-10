import 'package:flutter/material.dart';
import 'package:pts/components/appbar.dart';
import 'package:pts/components/custom_text.dart';
import 'package:pts/const.dart';
import 'package:pts/models/Capitalize.dart';

import 'help_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(
          title: TitleAppBar('à propos'.inCaps),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 22),
          onTapBox(
            context,
            'Aide',
            'Posez-nous ici les questions que vous avez concernant PTS',
            to: HelpPage(),
          ),
          onTapBox(
            context,
            'Politique de confidentialité',
            'Lisez la politique de confidentialité',
          ),
          onTapBox(
            context,
            "Version de l'application",
            "1.0.0",
          )
        ],
      ),
    );
  }

  Widget onTapBox(BuildContext context, String headerText, String hintText,
      {Widget? to, bool? separator = true}) {
    return InkWell(
      onTap: to == null
          ? null
          : () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => to)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CText(
                headerText,
                fontSize: 16,
              ),
            ),
            Opacity(
              opacity: 0.7,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.70,
                child: CText(hintText),
              ),
            ),
            separator == true
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 2, color: FOCUS_COLOR),
                        ),
                      ),
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
