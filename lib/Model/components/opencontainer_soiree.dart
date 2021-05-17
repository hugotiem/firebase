import 'package:flutter/material.dart';
import 'package:pts/Model/components/ProfilPhoto.dart';
import 'package:pts/Model/components/back_appbar.dart';

class OpenBuilderContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: PreferredSize(  
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(),
      ),
      body: Container( 
        child: Column(
          children: <Widget> [
            Center(
              child: Container(
                height: 100,
                width: 100,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 20
                ),
              child: Container( 
                child: Text(
                  'Nom Soirée',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900
                  ),
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container( 
                alignment: Alignment.centerLeft,
                child: Text(
                  'Date :',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container( 
                alignment: Alignment.centerLeft,
                child: Text(
                  'Heure :',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container( 
                alignment: Alignment.centerLeft,
                child: Text(
                  'Description :',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}