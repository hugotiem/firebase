import 'package:flutter/material.dart';

class HourInformation extends StatelessWidget {
  final String heuredebut;
  final String heurefin;

  const HourInformation({ 
    this.heuredebut,
    this.heurefin,
    Key key
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 21),
        child: Opacity(
          opacity: 0.7,
          child: Column(  
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                this.heuredebut,
                style: TextStyle(  
                  fontSize: 20,
                  fontWeight: FontWeight.w500
                ),
              ),
              Text(
                this.heurefin,
                style: TextStyle(  
                  fontSize: 20,
                  fontWeight: FontWeight.w500
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}