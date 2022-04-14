import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/components/app_text_style.dart';
import 'package:pts/const.dart';
import 'package:pts/models/slide.dart';

class IntroScreen extends StatefulWidget {
  IntroScreen({Key? key}) : super(key: key);

  @override
  IntroScreenState createState() => new IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  late PageController _controller = PageController();

  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();

    slides.add(
      Slide(
        title: "BIENVENUE",
        desc:
            "Merci d’avoir rejoint notre application PTS, nous allons te la présenter.",
        image: "assets/hf_head.png",
      ),
    );
    slides.add(
      Slide(
        title: "REJOINS",
        desc:
            "Cette application va te permettre de rejoindre des soirées proches de chez toi.\n\n Les soirées proposées sont suivant différents thèmes: (Festive, Gaming, À thème et Jeux de Société).",
        image: "assets/join_party.png",
      ),
    );
    slides.add(
      Slide(
        title: "ORGANISE",
        desc:
            "C’est à toi de définir tous les critères d’entrées Pour Ta Soirée (le titre, gratuit ou payant…).\n\n Maintenant tu n’as plus qu’à décider qui viendra Pour Ta Soirée!",
        image: "assets/create_party.png",
      ),
    );
    slides.add(
      Slide(
        title: "Bonne soirée",
        desc:
            "PTS te souhaite sincèrement de faire de superbes rencontres lors de tes soirées.",
        image: "assets/onboarding_img.png",
      ),
    );
  }

  void onDonePress() {}

  Widget renderNextBtn() {
    return Icon(
      Ionicons.arrow_forward_outline,
      color: ICONCOLOR,
      size: 35.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        toolbarHeight: 0,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: SECONDARY_COLOR,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            PageView.builder(
              padEnds: false,
              itemCount: slides.length,
              controller: _controller,
              itemBuilder: (context, index) {
                var slide = slides[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      slide.title?.toUpperCase() ?? "",
                      style: AppTextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        slide.desc ?? "",
                        textAlign: TextAlign.center,
                        style: AppTextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        Image.asset(slide.image ?? ""),
                        Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            colors: [
                              SECONDARY_COLOR,
                              SECONDARY_COLOR.withOpacity(0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )),
                          height: 70,
                        )
                      ],
                    ),
                  ],
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => _controller.animateToPage(slides.length - 1,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut),
                  icon: Icon(
                    Icons.skip_next_rounded,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () => _controller.nextPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut),
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
