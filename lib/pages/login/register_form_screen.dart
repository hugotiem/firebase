import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pts/components/custom_text.dart';
import 'package:pts/components/form/custom_text_form.dart';
import 'package:pts/components/form/custom_ttf_form.dart';
import 'package:pts/components/form/date_hour_picker.dart';
import 'package:pts/const.dart';
import 'package:pts/pages/login/id_form_screen.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/pages/login/nationnality_form_screen.dart';
import 'package:pts/services/payment_service.dart';

class RegisterFormScreen extends StatefulWidget {
  final String? mail;
  const RegisterFormScreen({this.mail, Key? key}) : super(key: key);
  @override
  _RegisterFormScreenState createState() => _RegisterFormScreenState();
}

class _RegisterFormScreenState extends State<RegisterFormScreen> {
  String? _name;
  String? _surname;
  String? _gender = "Homme";
  var _date;
  bool? _hSelect = true;
  bool? _fSelect;
  bool? _oSelect;

  TextEditingController? _nameController;
  TextEditingController? _surnameController;
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return true;
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
              body: Scaffold(
                backgroundColor: FORMBACKGROUNDCOLOR,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  toolbarHeight: 0,
                  elevation: 0,
                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                ),
                body: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        children: <Widget>[
                          HeaderText1(text: "Crée ton compte"),
                          HeaderText2(text: "Comment t'appelles tu ?"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TFFText(
                                width: MediaQuery.of(context).size.width * 0.4,
                                controller: _nameController,
                                hintText: "Prénom",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Rentrez votre prénom";
                                  }
                                  return null;
                                },
                              ),
                              TFFText(
                                width: MediaQuery.of(context).size.width * 0.4,
                                controller: _surnameController,
                                hintText: "Nom",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Rentrez votre nom";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          HeaderText2(
                            text: "Quelle est ta date de naissance ?",
                            padding: EdgeInsets.only(bottom: 20, top: 40),
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
                          HeaderText2(
                            text: "Sélectionne ton genre :",
                            padding: EdgeInsets.only(bottom: 20, top: 40),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              selectedContainer("Homme", () {
                                setState(() {
                                  _fSelect = false;
                                  _hSelect = true;
                                  _oSelect = false;
                                  _gender = 'Homme';
                                });
                              }, _hSelect),
                              selectedContainer("Femme", () {
                                setState(() {
                                  _fSelect = true;
                                  _hSelect = false;
                                  _oSelect = false;
                                  _gender = 'Femme';
                                });
                              }, _fSelect),
                              selectedContainer("Autre", () {
                                setState(() {
                                  _fSelect = false;
                                  _hSelect = false;
                                  _oSelect = true;
                                  _gender = 'Autre';
                                });
                              }, _oSelect),
                            ],
                          ),
                          SizedBox(height: 125),
                        ],
                      ),
                    ),
                  ),
                ),
                bottomSheet: Container(
                  decoration: BoxDecoration(
                    color: FORMBACKGROUNDCOLOR,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Wrap(
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
                            await BlocProvider.of<UserCubit>(context)
                                .updateUserInfo(
                                  id,
                                  name: _name,
                                  surname: _surname,
                                  gender: _gender,
                                  birthday: _date,
                                )
                                .then(
                                  (_) => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => NationnalityForm(id: id, name: _name, surname: _surname, birth: Timestamp.fromDate(_date), email: widget.mail,)
                                          // IdFormScreen(token: id),
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

  Widget selectedContainer(String text, void Function()? onTap, bool? select) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: HEIGHTCONTAINER,
        width: MediaQuery.of(context).size.width * .25,
        decoration: BoxDecoration(
          color: select == true ? SECONDARY_COLOR : PRIMARY_COLOR,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: CText(
            text,
            fontSize: 18,
            color: select == true ? PRIMARY_COLOR : SECONDARY_COLOR,
          ),
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
                colorScheme: ColorScheme.light().copyWith(
                    primary: SECONDARY_COLOR, onPrimary: PRIMARY_COLOR),
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
