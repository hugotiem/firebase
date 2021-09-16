import 'package:flutter/material.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/constant.dart';

class ChatPage extends StatelessWidget {
  final otherUserID;
  final otherUserName;
  final otherUserSurname;

  const ChatPage(String this.otherUserID, this.otherUserName, this.otherUserSurname,
  { Key key }) 
  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: BackAppBar(
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage("assets/roundBlankProfilPicture.png"),
              ),
              SizedBox(width: 20),
              Text(  
                "$otherUserName $otherUserSurname",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(  
                  color: SECONDARY_COLOR
                ),
              )
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        color: PRIMARY_COLOR,
      )
    );
  }
}