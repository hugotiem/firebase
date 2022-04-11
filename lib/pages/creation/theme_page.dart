import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/blocs/parties/build_parties_cubit.dart';
import 'package:pts/components/form/background_form.dart';
import 'package:pts/components/form/custom_text_form.dart';

import 'package:pts/const.dart';
import 'package:pts/models/party.dart';

class ThemePage extends StatelessWidget {
  final void Function()? onNext;
  final void Function()? onPrevious;
  final Party? party;

  final List<Map<String, dynamic>> themes = [
    {
      'title': 'Festive',
      'img': 'assets/festive.jpg',
      'iconColor': ICONCOLOR,
    },
    {
      'title': 'Jeux de société',
      'img': 'assets/jeuxdesociete.jpg',
      'iconColor': SECONDARY_COLOR,
    },
    {
      'title': 'Thème',
      'img': 'assets/theme.jpg',
      'iconColor': SECONDARY_COLOR,
    },
    {
      'title': 'Gaming',
      'img': 'assets/gaming.jpg',
      'iconColor': ICONCOLOR,
    },
  ];

  ThemePage({Key? key, this.onNext, this.onPrevious, this.party})
      : super(key: key);

  Widget _buildThemeCard(BuildContext context, Map<String, dynamic> data) {
    String title = data['title'];
    bool _selected = party?.theme == title;
    return GestureDetector(
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Stack(
            children: [
              Center(
                child: AnimatedContainer(
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 200),
                  margin: EdgeInsets.all(_selected ? 10 : 30),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(_selected ? 40 : 20),
                    border: Border.all(
                      width: 4,
                      color: data["iconColor"],
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                    image: AssetImage(data['img']),
                    colorFilter: _selected
                        ? null
                        : ColorFilter.mode(Colors.grey, BlendMode.saturation),
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () =>
            BlocProvider.of<BuildPartiesCubit>(context).setTheme(title));
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundForm(
      onPrevious: () => onPrevious!(),
      onPressedFAB: () {
        if (party == null || party!.theme == null) return;
        onNext!();
      },
      children: [
        HeaderText1Form(text: "Choisis un thème"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: _buildThemeCard(context, themes[0]),
            ),
            Expanded(
              child: _buildThemeCard(context, themes[1]),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: _buildThemeCard(context, themes[2]),
            ),
            Expanded(
              child: _buildThemeCard(context, themes[3]),
            ),
          ],
        ),
      ],
    );
  }
}
