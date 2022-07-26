// ignore_for_file: unnecessary_statements

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/components/custom_text.dart';
import 'package:pts/components/form/custom_text_form.dart';
import 'package:pts/const.dart';
import 'package:pts/models/user.dart';
import 'package:pts/widgets/widgets_export.dart';

class InformationPage extends StatefulWidget {
  final User user;
  const InformationPage(this.user, {Key? key}) : super(key: key);

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  String? _name;
  String? _surname;
  String? _gender;
  var _date;
  var _dateNonFormat;
  String? _email;
  String? _phone;
  String? _desc;

  TextEditingController? _nameController;
  TextEditingController? _surnameController;
  TextEditingController? _dateController;
  TextEditingController? _emailController;
  TextEditingController? _phoneController;
  TextEditingController? _descController;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.user.name)
      ..addListener(() {
        _name = _nameController!.text.trim();
      });
    _surnameController = TextEditingController(text: widget.user.surname)
      ..addListener(() {
        _surname = _surnameController!.text.trim();
      });
    _dateController = TextEditingController(
        text: widget.user.birthday == null
            ? ""
            : DateFormat.yMd('fr').format(widget.user.birthday!))
      ..addListener(() {
        _date = _dateController!.text;
      });
    _emailController = TextEditingController(text: widget.user.email)
      ..addListener(() {
        _email = _emailController!.text;
      });
    _phoneController =
        TextEditingController(text: widget.user.phone ?? 'Non fournie')
          ..addListener(() {
            _phone = _phoneController!.text;
          });
    _descController =
        TextEditingController(text: widget.user.desc ?? 'Aucune description')
          ..addListener(() {
            _desc = _descController!.text;
          });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit()..init(),
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          User? user = state.user;
          bool? verified = user?.verified;

          _name == null ? _name = user?.name : _name;
          _surname == null ? _surname = user?.surname : _surname;
          _gender == null ? _gender = user?.gender : _gender;
          _date == null ? _date = user?.birthday : _dateNonFormat;
          _email == null ? _email = user?.email : _email;
          _phone == null ? _phone = user?.phone : _phone;
          _desc == null ? _desc = user?.desc : _desc;

          if (user == null) {
            return Scaffold(
              backgroundColor: PRIMARY_COLOR,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (verified == true) {
            return Scaffold(
              backgroundColor: PRIMARY_COLOR,
              appBar: CustomAppBar(
                onPressed: () => Navigator.pop(context),
                actions: [
                  TextButton(
                    onPressed: () async {
                      saveVerifiedProfile(
                        _email,
                        _phone,
                        _desc,
                      );
                    },
                    child: CText('sauvegarder',
                        color: PRIMARY_COLOR, fontSize: 16),
                  )
                ],
              ),
              body: Container(
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: [SECONDARY_COLOR, ICONCOLOR])),
                child: Container(
                  decoration: BoxDecoration(
                      color: PRIMARY_COLOR,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(40))),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HeaderText1(
                              text: 'Modifie tes informations personnelles'),
                          ttf("Prénom", _nameController, readOnly: true),
                          ttf('Nom', _surnameController, readOnly: true),
                          ttf1('Genre', user.gender, readOnly: true),
                          ttf('Date de naissance', _dateController,
                              readOnly: true),
                          ttf('Adresse mail', _emailController),
                          ttf('Téléphone', _phoneController),
                          ttf("Description", _descController),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: PRIMARY_COLOR,
              appBar: CustomAppBar(
                onPressed: () => Navigator.pop(context),
                actions: [
                  TextButton(
                    onPressed: () async {
                      saveNonVerifiedProfile(
                          _name,
                          _surname,
                          _dateNonFormat == null ? _date : _dateNonFormat,
                          _gender,
                          _email,
                          _phone,
                          _desc);
                    },
                    child: CText('sauvegarder',
                        color: PRIMARY_COLOR, fontSize: 16),
                  )
                ],
              ),
              body: Container(
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: [SECONDARY_COLOR, ICONCOLOR])),
                child: Container(
                  decoration: BoxDecoration(
                      color: PRIMARY_COLOR,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(40))),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HeaderText1(
                              text: 'Modifie tes informations personnelles'),
                          ttf("Prénom", _nameController),
                          ttf('Nom', _surnameController),
                          dropdown('Genre', user.gender),
                          datePicker('Date de naissance', _dateController),
                          ttf('Adresse mail', _emailController),
                          ttf('Téléphone', _phoneController),
                          ttf("Description", _descController),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget ttf(String text, TextEditingController? controller, {bool? readOnly}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Stack(
        children: [
          Opacity(opacity: 0.65, child: CText(text)),
          TextFormField(
            readOnly: readOnly == null ? false : readOnly,
            textAlignVertical: TextAlignVertical.bottom,
            controller: controller,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: SECONDARY_COLOR),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ttf1(String text, String? hint, {bool? readOnly}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Stack(
        children: [
          Opacity(opacity: 0.65, child: CText(text)),
          TextFormField(
            initialValue: hint,
            readOnly: readOnly == null ? false : readOnly,
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: SECONDARY_COLOR),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dropdown(String text, String? gender) {
    return Stack(
      children: [
        hintText1(text),
        Padding(
          padding: const EdgeInsets.only(bottom: 22, top: 2),
          child: DropdownButtonFormField<String>(
            value: _gender,
            items: [
              'Homme',
              'Femme',
              'Autre',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: CText(
                  value,
                  fontSize: 16,
                ),
              );
            }).toList(),
            hint: Text(
              gender!,
            ),
            elevation: 0,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 15),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            onChanged: (String? value) {
              setState(() {
                _gender = value;
              });
            },
            alignment: Alignment.bottomLeft,
          ),
        ),
      ],
    );
  }

  Widget datePicker(String text, TextEditingController? controller) {
    return Stack(
      children: [
        hintText1(text),
        Padding(
          padding: const EdgeInsets.only(bottom: 22, top: 2),
          child: TextFormField(
            controller: controller,
            textAlignVertical: TextAlignVertical.bottom,
            readOnly: true,
            onTap: () async {
              FocusScope.of(context).requestFocus(new FocusNode());
              await _selectionDate();
              _dateController!.text = DateFormat.yMd('fr').format(_date);
            },
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: SECONDARY_COLOR),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<Null> _selectionDate() async {
    DateTime? _dateChoisie = await showDatePicker(
        context: context,
        initialDate: widget.user.birthday ?? DateTime.now(),
        firstDate: DateTime(1900),
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
        _dateNonFormat = _dateChoisie;
      });
    }
  }

  Widget hintText1(String text) {
    return Opacity(opacity: 0.65, child: CText(text));
  }

  Future saveNonVerifiedProfile(String? name, String? surname, var birthday,
      String? gender, String? email, String? phone, String? desc) async {
    FirebaseFirestore.instance.collection('user').doc(widget.user.id).update({
      'name': name,
      'surname': surname,
      'birthday': birthday,
      'gender': gender,
      'email': email,
      'phone number': phone,
      'desc': desc,
    });
  }

  Future saveVerifiedProfile(String? email, String? phone, String? desc) async {
    FirebaseFirestore.instance.collection('user').doc(widget.user.id).update({
      'email': email,
      'phone number': phone,
      'desc': desc,
    });
  }
}
