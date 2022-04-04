import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/blocs/parties/build_parties_cubit.dart';
import 'package:pts/components/form/background_form.dart';
import 'package:pts/components/form/custom_text_form.dart';

import 'package:pts/const.dart';

class ThemePage extends StatefulWidget {
  final void Function()? onNext;
  final void Function()? onPrevious;

  const ThemePage({Key? key, this.onNext, this.onPrevious}) : super(key: key);
  @override
  _ThemePageState createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  String? _theme;

  List<Map<String, dynamic>> themes = [
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

  Widget _buildThemeCard(BuildContext context, Map<String, dynamic> data) {
    String title = data['title'];
    bool _selected = _theme == title;
    return GestureDetector(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
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
            if (_selected)
              Positioned.fill(
                right: 10,
                left: 10,
                bottom: 10,
                top: 10,
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(40),
                        border:
                            Border.all(width: 4, color: data["iconColor"]))),
              ),
          ],
        ),
      ),
      onTap: () => setState(() {
        _theme = title;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundForm(
      onPrevious: () => widget.onPrevious!(),
      onPressedFAB: () {
        if (_theme == null) return;

        BlocProvider.of<BuildPartiesCubit>(context).addItem("theme", _theme);
        widget.onNext!();
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
