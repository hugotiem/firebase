import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/blocs/parties/build_parties_cubit.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/components/components_creation/fab_form.dart';
import 'package:pts/components/components_creation/headertext_one.dart';

import '../../../Constant.dart';

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

          // Soiree.setDataThemePage(
          //   _theme
          // );
          // Navigator.push(context,
          //   MaterialPageRoute(builder: (context) => DateHourPage())
          // );
        },
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText1(text: 'Choississez un thème'),
              Center(
                child: Container(
                  height: HEIGHTCONTAINER,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      color: PRIMARY_COLOR,
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: Center(
                      child: DropdownButtonFormField<String>(
                        value: _theme,
                        items: [
                          'Festive',
                          'Gaming',
                          'Jeu de société',
                          'Soirée à thème',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: TEXTFIELDFONTSIZE),
                            ),
                          );
                        }).toList(),
                        hint: Text(
                          "Choisir un thème",
                          style: TextStyle(fontSize: TEXTFIELDFONTSIZE),
                        ),
                        elevation: 0,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            height: 0,
                            background: Paint()..color = Colors.transparent,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _theme = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Vous devez choisir un thème';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
