import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';

class DescriptionPage extends StatefulWidget {
  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,      
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(  
            children: [
              Row(
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 30, 
                        bottom: 40,
                        left: 20
                        ),
                      child: Text(
                        "Ajouter une Description",
                        style: TextStyle(  
                          wordSpacing: 1.5,
                          fontSize: 25,
                          color: SECONDARY_COLOR,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container( 
                      padding: EdgeInsets.only(
                        top: 30, 
                        bottom: 37,
                        left: 5
                        ),
                      child: Opacity(
                        opacity: 0.7,
                        child: Text(
                          '(optionnel)',
                          style: TextStyle(  
                            fontSize: 18,
                            color: Colors.black
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Center(
                child: Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(  
                    color: PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: TextFormField(  
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      decoration: InputDecoration( 
                        hintText: 'ex: Ambiance boîte de nuit !!', 
                        border: InputBorder.none,
                      )
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 20),
                height: MediaQuery.of(context).size.height * 0.49,
                alignment: Alignment.bottomCenter,
                child: ElevatedButton( 
                  style: ElevatedButton.styleFrom(
                    primary: SECONDARY_COLOR,
                    elevation: 0,
                    shape: StadiumBorder()
                  ),
                  child: Text(
                    "Publier la soirée",
                    style: TextStyle(  
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {},
                ),
              )
            ]
        )
        ),
      );
  }
}