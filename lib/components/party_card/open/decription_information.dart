import 'package:flutter/material.dart';

import '../../../../../Constant.dart';

class DescriptionInformation extends StatelessWidget {
  final String nomOrganisateur;
  final String avis;
  final String description;

  const DescriptionInformation({ 
    this.nomOrganisateur,
    this.avis,
    this.description,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(  
        children: [
          Row(  
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container( 
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16, top: 30),
                  child: Column(  
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding( 
                        padding: EdgeInsets.only(left: 5),
                        child: Opacity(
                          opacity: 0.9,
                          child: Text( 
                            this.nomOrganisateur,
                            style: TextStyle(  
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: SECONDARY_COLOR
                            ),
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: 0.7,
                        child: Row(  
                          children: [
                            Icon(  
                              Icons.star_rate_outlined,
                              color: ICONCOLOR,
                            ),
                            Text(
                              this.avis,
                              style: TextStyle(  
                                fontSize: 16,
                                color: SECONDARY_COLOR,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(  
                child: Padding(
                  padding: EdgeInsets.only(top: 30, right: 21),
                  child: Container(
                    height: 50,
                    width: 50,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(  
                      shape: BoxShape.circle
                    ),
                    child: Image.network(
                      'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding( 
            padding: EdgeInsets.only(left: 21, right: 21, top: 30),
            child: Container( 
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.topLeft,
              child: Opacity(
                opacity: 0.7,
                child: Text(
                  this.description,
                  style: TextStyle(  
                    fontSize: 16,
                    color: SECONDARY_COLOR
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}