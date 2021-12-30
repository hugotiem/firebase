import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/blocs/parties/build_parties_cubit.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/components/components_creation/fab_form.dart';
import 'package:pts/components/components_creation/headertext_one.dart';

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

  List<Map<String, String>> themes = [
    {
      'title': 'Festive',
      'img': 'assets/festive.jpg',
    },
    {
      'title': 'Jeux de société',
      'img': 'assets/jeuxdesociete.jpg',
    },
    {
      'title': 'Thème',
      'img': 'assets/theme.jpg',
    },
    {
      'title': 'Gaming',
      'img': 'assets/gaming.jpg',
    },
  ];

  Widget _buildThemeCard(BuildContext context, String title, String img) {
    return GestureDetector(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            border: Border.all(
                color: _theme == title ? Colors.green : Colors.black,
                width: _theme == title ? 5 : 1),
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(image: AssetImage(img)),
          ),
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
              HeaderText1(text: 'Choissis un thème'),
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
                        child: _buildThemeCard(
                            context, themes[0]['title']!, themes[0]['img']!),
                      ),
                      Expanded(
                        child: _buildThemeCard(
                            context, themes[1]['title']!, themes[1]['img']!),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: _buildThemeCard(
                            context, themes[2]['title']!, themes[2]['img']!),
                      ),
                      Expanded(
                        child: _buildThemeCard(
                            context, themes[3]['title']!, themes[3]['img']!),
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
