import 'package:flutter/material.dart';
import 'package:pts/Model/components/ProfilPhoto.dart';
import 'package:pts/Model/components/pts_box.dart';
import 'package:pts/View/Pages/profil/components/title_text_profil.dart';

class CardValidation extends StatelessWidget {
  final String title;
  final String name;
  final int itemCount;

  const CardValidation({ 
    this.title,
    this.name,
    this.itemCount,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PTSBox(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        color: Colors.white,
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleTextProfil(
                text: this.title
              ),
              Expanded(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      primary: false,
                      itemCount: this.itemCount,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ProfilPhoto(),
                            ),
                            Text(
                              this.name
                            )
                          ],
                        );
                      }
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}