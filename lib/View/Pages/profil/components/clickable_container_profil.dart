import 'package:flutter/material.dart';
import 'package:pts/Model/pts_components.dart';

class CickableContainerProfil extends StatelessWidget {
  final Widget to;
  final bool bottomBorder;
  final String text;
  final IconData icon;

  const CickableContainerProfil({ 
    this.to,
    this.bottomBorder = true,
    this.text,
    this.icon,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClickableContainer(
      to: this.to,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Container(  
        padding: EdgeInsets.only(top: 15, bottom: 15),
        decoration: this.bottomBorder == true 
        ? BoxDecoration(
            border: Border(  
              bottom: BorderSide(  
                color: Colors.grey.withOpacity(0.23)
              )
            )
          )
        : null,
        child: Row(  
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              this.text,
              style: TextStyle(
                fontSize: 20
              ),
            ),
            Icon(
              this.icon
            )
          ],
        ),
      ),
    );
  }
}