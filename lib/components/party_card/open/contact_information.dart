import 'package:flutter/material.dart';

class ContactInformation extends StatelessWidget {
  final Function() onPressed;
  final String contact;

  const ContactInformation({ 
    this.contact,
    this.onPressed,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 30),
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.topLeft,
        child: TextButton(  
          onPressed: this.onPressed,
          child: Text(
            this.contact,
            style: TextStyle(  
              fontSize: 16
            ),
          ),
        ),
      ),
    );
  }
}