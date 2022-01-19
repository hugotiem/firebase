import 'package:flutter/material.dart';

class ProfilePhoto extends StatelessWidget {
  final String? photo;
  final double? radius;
  const ProfilePhoto(this.photo, {this.radius = 30, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? image;
    if (photo == "") {
      image = "assets/roundBlankProfilPicture.png";
    } else {
      image = photo;
    }

    return image == "assets/roundBlankProfilPicture.png"
        ? CircleAvatar(
            radius: radius,
            backgroundImage: AssetImage(image!),
          )
        : CircleAvatar(
            radius: radius,
            backgroundImage: NetworkImage(image!),
          );
  }
}
