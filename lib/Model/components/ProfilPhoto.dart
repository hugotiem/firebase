import 'package:flutter/material.dart';

class ProfilPhoto extends Container{
  @override 
  Widget build(BuildContext context) {
    return Container( 
      height: 60,
      width: 60,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Image.network(
        'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
      ),
    );
  }
}