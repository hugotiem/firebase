import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pts/components/components_creation/date_hour_picker.dart';
import 'package:pts/const.dart';
import 'package:pts/pages/login/id_form_screen.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/components/components_creation/tff_text.dart';

class RegisterFormScreen extends StatefulWidget {
  const RegisterFormScreen({Key? key}) : super(key: key);
  @override
  _RegisterFormScreenState createState() => _RegisterFormScreenState();
}

class _RegisterFormScreenState extends State<RegisterFormScreen> {
  String? _name;
  String? _surname;
  String? _phonenumber;
  String? _gender;
  var _date;

  TextEditingController? _nameController;
  TextEditingController? _surnameController;
  TextEditingController? _phonenumbercontroller;
  TextEditingController dateCtl = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _nameController = TextEditingController()
      ..addListener(() {
        _name = _nameController!.text;
      });
    _surnameController = TextEditingController()
      ..addListener(() {
        _surname = _surnameController!.text;
      });
    _phonenumbercontroller = TextEditingController()
      ..addListener(() {
        _phonenumber = _phonenumbercontroller!.text;
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        }
        return true;
      },
      child: BlocProvider(
        create: (context) => UserCubit()..init(),
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            var data = state.user;
            var id = state.token;
            if (data != null) {
              _nameController?.text = data.name ?? '';
              _surnameController?.text = data.surname ?? '';
            }
            return Scaffold(
              body: SafeArea(
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    toolbarHeight: 0,
                    elevation: 0,
                    systemOverlayStyle: SystemUiOverlayStyle.dark,
                  ),
                  body: Center(
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 50,
                            ),
                            Center(
                              child: TFFText(
                                controller: _surnameController,
                                keyboardAppearance: Brightness.light,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Le champs ne dois pas être vide";
                                  }
                                  return null;
                                },
                                hintText: 'Nom :',
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Center(
                              child: TFFText(
                                controller: _nameController,
                                keyboardAppearance: Brightness.light,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "le champs ne dois pas être vide";
                                  }
                                  return null;
                                },
                                hintText: 'Prénom :',
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            DateHourPicker(
                              onTap: () async {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                await _selectionDate();
                                dateCtl.text =
                                    DateFormat.MMMMEEEEd('fr').format(_date);
                              },
                              hintText: "Date de naissance",
                              controller: dateCtl,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Vous devez choisir une date";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Center(
                              child: Container(
                                height: HEIGHTCONTAINER,
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                    color: PRIMARY_COLOR,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 16, right: 8),
                                  child: Center(
                                    child: DropdownButtonFormField<String>(
                                      value: _gender,
                                      items: [
                                        'Homme',
                                        'Femme',
                                        'Autre',
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                                fontSize: TEXTFIELDFONTSIZE),
                                          ),
                                        );
                                      }).toList(),
                                      hint: Text(
                                        "Genre",
                                        style: TextStyle(
                                            fontSize: TEXTFIELDFONTSIZE),
                                      ),
                                      elevation: 0,
                                      decoration: InputDecoration(
                                        errorStyle: TextStyle(
                                          height: 0,
                                          background: Paint()
                                            ..color = Colors.transparent,
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                      ),
                                      onChanged: (String? value) {
                                        setState(() {
                                          _gender = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Vous devez sélectionner un genre';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Center(
                              child: TFFText(
                                controller: _phonenumbercontroller,
                                keyboardAppearance: Brightness.light,
                                keyboardType: TextInputType.phone,
                                hintText: 'Téléphone (facultatif) :',
                                validator: (value) {
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 100,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  bottomSheet: Wrap(
                    children: <Widget>[
                      Center(
                        child: GestureDetector(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            width: size.width - 100,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: ICONCOLOR,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Text(
                              "suivant".toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            print(_name);
                            print(_surname);
                            await BlocProvider.of<UserCubit>(context)
                                .updateUserInfo(
                                  id,
                                  name: _name,
                                  surname: _surname,
                                  phonenumber: _phonenumber,
                                  gender: _gender,
                                  birthday: _date
                                )
                                .then(
                                  (_) => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          IdFormScreen(token: id),
                                    ),
                                  ),
                                );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<Null> _selectionDate() async {
    DateTime? _dateChoisie = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1921),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light()
                    .copyWith(primary: SECONDARY_COLOR, onPrimary: ICONCOLOR),
              ),
              child: child!);
        });

    if (_dateChoisie != null && _dateChoisie != _date) {
      setState(() {
        _date = _dateChoisie;
      });
    }
  }
}
