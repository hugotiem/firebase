import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/components/party_card/open/fab_join.dart';
import 'package:pts/components/title_appbar.dart';

import '../../../../constant.dart';

class NewCreditCard extends StatefulWidget {
  const NewCreditCard({ Key key }) : super(key: key);

  @override
  _NewCreditCardState createState() => _NewCreditCardState();
}

class _NewCreditCardState extends State<NewCreditCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(  
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(  
          title: TitleAppBar(
            title: 'Ajouter une carte',
          ),
        ),
      ),
      floatingActionButton: FABJoin(  
        label: 'Ajouter',
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(  
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextNewCreditCard(
                text: 'Titulaire de la carte'
              ),
              TTFNewCreditCard(  
                hintText: 'ex: Martin Morel',
                onChanged: (value) {},
                validator: (value) {},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(  
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextNewCreditCard(
                          text: "Date d'expiration",
                        ),
                      ),
                      TTFNewCreditCard(  
                        width: MediaQuery.of(context).size.width * 0.4,
                        hintText: 'XX/XX',
                        onChanged: (value) {},
                        validator: (value) {},
                      ),
                    ],
                  ),
                  Column(  
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextNewCreditCard(
                          text: "CVV",
                        ),
                      ),
                      TTFNewCreditCard(  
                        width: MediaQuery.of(context).size.width * 0.4,
                        hintText: 'XXX',
                        onChanged: (value) {},
                        validator: (value) {},
                      ),
                    ],
                  )
                ],
              ),
              TextNewCreditCard(
                text: 'Numéro de carte'
              ),
              TTFNewCreditCard(  
                hintText: 'XXXX XXXX XXXX XXXX',
                onChanged: (value) {},
                validator: (value) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextNewCreditCard extends StatelessWidget {
  final String text;
  const TextNewCreditCard({ 
    this.text,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 21, top: 16, bottom: 8),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Opacity(
          opacity: 0.7,
          child: Text(  
            this.text,
            style: TextStyle(  
              color: SECONDARY_COLOR,
              fontSize: 16,
              fontWeight: FontWeight.w500
            ),
          ),
        ),
      ),
    );
  }
}

class TTFNewCreditCard extends StatelessWidget {
  final void Function(String) onChanged;
  final String hintText;
  final int maxLength;
  final String Function(String) validator;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final double width;

  const TTFNewCreditCard({ 
    @required this.onChanged,
    @required this.hintText,
    this.maxLength,
    @required this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.width,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: HEIGHTCONTAINER,
        width: this.width == null
        ? MediaQuery.of(context).size.width * 0.9
        : this.width,
        decoration: BoxDecoration(
          color: PRIMARY_COLOR,
          borderRadius: BorderRadius.circular(15)
        ),
        child: Padding( 
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: TextFormField(  
              onChanged: this.onChanged,
              style: TextStyle(  
                fontSize: TEXTFIELDFONTSIZE,
              ),
              decoration: InputDecoration(  
                hintText: this.hintText,
                border: InputBorder.none,
                counterText: '',
                errorStyle: TextStyle(  
                  height: 0
                )
              ),
              maxLength: this.maxLength,
              validator: this.validator,
              keyboardType: this.keyboardType,
              inputFormatters: this.inputFormatters,
            ),
          ),
        ),
      ),
    );
  }
}