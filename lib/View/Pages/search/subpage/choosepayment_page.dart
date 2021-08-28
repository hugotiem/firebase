import 'package:flutter/material.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/components/title_appbar.dart';
import 'package:pts/view/pages/profil/subpage/existingcard_page.dart';

class ChoosePayment extends StatefulWidget {
  const ChoosePayment({ Key key }) : super(key: key);

  @override
  _ChoosePaymentState createState() => _ChoosePaymentState();
}

class _ChoosePaymentState extends State<ChoosePayment> {

  onItemPress(BuildContext context, int index) {
    switch(index) {
      case 0:
      // payer via nouvelle carte
      break;
      case 1:
        Navigator.push(context, 
          MaterialPageRoute(builder: (context) => ExistingCard())
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(  
          title: TitleAppBar(
            title: 'Paiement',
          )
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.separated(
          itemBuilder: (context, index) {
            Icon icon;
            Text text;

            switch(index) {
              case 0:
                icon = Icon(Icons.add_circle_outline);
                text = Text("Payer via une nouvelle carte");
                break;
              case 1:
                icon = Icon(Icons.credit_card_outlined);
                text = Text('Payer via une carte déja enregistrer');
                break;
            }

            return InkWell(
              onTap: () {
                onItemPress(context, index);
              },
              child: ListTile(
                title: text,
                leading: icon,
              ),
            );
          }, 
          separatorBuilder: (context, index) => Divider(thickness: 1), 
          itemCount: 2
        )
      ),
    );
  }
}