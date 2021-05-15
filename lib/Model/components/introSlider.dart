import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class IntroScreen extends StatefulWidget {
  IntroScreen({Key key}) : super(key: key);

  @override
  IntroScreenState createState() => new IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  // ignore: deprecated_member_use
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "BIENVENUE",
        description: "Merci d’avoir rejoint notre application Pour Ta Soirée, nous allons vous la présenter.",
//        pathImage: "images/photo_eraser.png",
        backgroundColor: Color(0xff203152),
      ),
    );
    slides.add(
      new Slide(
        title: "REJOINS",
        description: "Cette application va te permettre de rejoindre des soirées proches de chez toi. Ces soirées sont proposées suivant différents thèmes, elles peuvent être payantes ou gratuites suivant ce que l’organisateur souhaite.",
//        pathImage: "images/photo_pencil.png",
        backgroundColor: Color(0xff203152),
      ),
    );
    slides.add(
      new Slide(
        title: "ORGANISE",
        description:
        "C’est à toi de décider le thème de ta soirée le nombre de personnes qui seront présentes à ta soirée et dernière chose tu pourras choisir qui viendra à Ta Soirée.",
//        pathImage: "images/photo_ruler.png",
        backgroundColor: Color(0xff203152),
      ),
    );
    slides.add(
      new Slide(
        title: "BONNE SOIREE A VOUS TOUS !",
        description:
        "PTS vous souhaite sincèrement de faire de superbes rencontres lors de vos soirées.",
//        pathImage: "images/photo_ruler.png",
        backgroundColor: Color(0xff203152),
      ),
    );
  }

  void onDonePress() {
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color : Color(0xffffcc5c),
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Color(0xffffcc5c),
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Color(0xffffcc5c),
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

      hideStatusBar: true,

      sizeDot: 8.0,
    );
  }
}