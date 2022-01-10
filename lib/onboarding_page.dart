import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/const.dart';

class IntroScreen extends StatefulWidget {
  IntroScreen({Key? key}) : super(key: key);

  @override
  IntroScreenState createState() => new IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  // ignore: deprecated_member_use
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        styleTitle: TextStyle(fontSize: 60,  color: PRIMARY_COLOR),
        styleDescription: TextStyle(fontSize: 20,  color: PRIMARY_COLOR),
        title: "BIENVENUE",
        description:
            "Merci d’avoir rejoint notre application PTS, nous allons te la présenter.",
//        pathImage: "images/photo_eraser.png",
        backgroundColor: SECONDARY_COLOR,
      ),
    );
    slides.add(
      new Slide(
        styleTitle: TextStyle(fontSize: 60,  color: PRIMARY_COLOR),
        styleDescription: TextStyle(fontSize: 20,  color: PRIMARY_COLOR),
        title: "REJOINS",
        description:
            "Cette application va te permettre de rejoindre des soirées proches de chez toi.\n\n Les soirées proposées sont suivant différents thèmes: (Festive, Gaming, À thème et Jeux de Société).\n\n D’autres informations sont présentes comme l’heure d’entrée, le nombre de personnes …",
//        pathImage: "images/photo_pencil.png",
        backgroundColor: SECONDARY_COLOR,
      ),
    );
    slides.add(
      new Slide(
        styleTitle: TextStyle(fontSize: 60,  color: PRIMARY_COLOR),
        styleDescription: TextStyle(fontSize: 20,  color: PRIMARY_COLOR),
        title: "ORGANISE",
        description:
            "C’est à toi de définir tous les critères d’entrées Pour Ta Soirée (le titre, gratuit ou payant…).\n\n Maintenant tu n’as plus qu’à décider qui viendra Pour Ta Soirée!",
//        pathImage: "images/photo_ruler.png",
        backgroundColor: SECONDARY_COLOR,
      ),
    );
    slides.add(
      new Slide(
        styleTitle: TextStyle(fontSize: 60,  color: PRIMARY_COLOR),
        styleDescription: TextStyle(fontSize: 20,  color: PRIMARY_COLOR),
        title: "BONNE SOIREE",
        description:
            "PTS te souhaite sincèrement de faire de superbes rencontres lors de tes soirées.",
//        pathImage: "images/photo_ruler.png",
        backgroundColor: SECONDARY_COLOR,
      ),
    );
    slides.add(new Slide(
      backgroundColor: SECONDARY_COLOR,
    ));
  }

  void onDonePress() {}

  Widget renderNextBtn() {
    return Icon(
      Ionicons.arrow_forward_outline,
      color: ICONCOLOR,
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Ionicons.checkmark_outline,
      color: ICONCOLOR,
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Ionicons.play_skip_forward_outline,
      color: ICONCOLOR,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      // List slides
      slides: this.slides,

      // Skip button
      renderSkipBtn: this.renderSkipBtn(),

      // Next button
      renderNextBtn: this.renderNextBtn(),

      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,

      colorDot: ICONCOLOR,

      hideStatusBar: true,

      sizeDot: 8.0,
    );
  }
}
