import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/blocs/parties/build_parties_cubit.dart';
import 'package:pts/components/appbar.dart';
import 'package:pts/components/form/custom_text_form.dart';
import 'package:pts/components/form/fab_form.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> themes = [
    {
      'title': 'Festive',
      'img': 'assets/festive.jpg',
      'iconColor': SECONDARY_COLOR,
    },
    {
      'title': 'Jeux de société',
      'img': 'assets/jeuxdesociete.jpg',
      'iconColor': PRIMARY_COLOR,
    },
    {
      'title': 'Thème',
      'img': 'assets/theme.jpg',
      'iconColor': PRIMARY_COLOR,
    },
    {
      'title': 'Gaming',
      'img': 'assets/gaming.jpg',
      'iconColor': SECONDARY_COLOR,
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
              margin: EdgeInsets.symmetric(
                  horizontal: _selected ? 15 : 20,
                  vertical: _selected ? 15 : 20),
              decoration: BoxDecoration(
                boxShadow: _selected
                    ? [
                        BoxShadow(
                            color: SECONDARY_COLOR.withOpacity(0.2),
                            offset: Offset(0, 0),
                            blurRadius: 20,
                            spreadRadius: 10),
                      ]
                    : null,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(image: AssetImage(data['img'])),
              ),
            ),
            if (_selected)
              Positioned(
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Icon(
                    Icons.check_circle_outline_rounded,
                    color: data['iconColor'],
                  ),
                ),
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
    return Scaffold(
      backgroundColor: FORMBACKGROUNDCOLOR,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(
          onPressed: () {
            widget.onPrevious!();
          },
        ),
      ),
      floatingActionButton: FABForm(
        tag: 'theme',
        onPressed: () {
          if (!_formKey.currentState!.validate()) {
            return;
          }

          BlocProvider.of<BuildPartiesCubit>(context).addItem("theme", _theme);
          widget.onNext!();
        },
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText1(text: 'Choisis un thème'),
              // Center(
              //   child: Container(
              //     height: HEIGHTCONTAINER,
              //     width: MediaQuery.of(context).size.width * 0.9,
              //     decoration: BoxDecoration(
              //         color: PRIMARY_COLOR,
              //         borderRadius: BorderRadius.circular(15)),
              //     child: Padding(
              //       padding: const EdgeInsets.only(left: 16, right: 8),
              //       child: Center(
              //         child: DropdownButtonFormField<String>(
              //           value: _theme,
              //           items: [
              //             'Festive',
              //             'Gaming',
              //             'Jeux de société',
              //             'Thème',
              //           ].map<DropdownMenuItem<String>>((String value) {
              //             return DropdownMenuItem<String>(
              //               value: value,
              //               child: Text(
              //                 value,
              //                 style: TextStyle(fontSize: TEXTFIELDFONTSIZE),
              //               ),
              //             );
              //           }).toList(),
              //           hint: Text(
              //             "Choisir un thème",
              //             style: TextStyle(fontSize: TEXTFIELDFONTSIZE),
              //           ),
              //           elevation: 0,
              //           decoration: InputDecoration(
              //             errorStyle: TextStyle(
              //               height: 0,
              //               background: Paint()..color = Colors.transparent,
              //             ),
              //             errorBorder: OutlineInputBorder(
              //               borderSide: BorderSide(color: Colors.transparent),
              //             ),
              //             border: OutlineInputBorder(
              //               borderSide: BorderSide.none,
              //               borderRadius: BorderRadius.circular(15),
              //             ),
              //             enabledBorder: UnderlineInputBorder(
              //               borderSide: BorderSide(color: Colors.transparent),
              //             ),
              //           ),
              //           onChanged: (String? value) {
              //             setState(() {
              //               _theme = value;
              //             });
              //           },
              //           validator: (value) {
              //             if (value == null) {
              //               return 'Vous devez choisir un thème';
              //             } else {
              //               return null;
              //             }
              //           },
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Column(
                children: [
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
