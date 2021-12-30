import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/components/components_creation/headertext_one.dart';
import 'package:pts/components/custom_text.dart';
import 'package:pts/const.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/models/user.dart';

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

  TextEditingController? _nameController;
  TextEditingController? _surnameController;
  TextEditingController? _dateController;
  TextEditingController? _emailController;
  TextEditingController? _phoneController;

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
        text: DateFormat.MMMMEEEEd('fr').format(widget.user.birthday))
      ..addListener(() {
        _date = _dateController!.text;
      });
    _emailController = TextEditingController(text: widget.user.email)
      ..addListener(() {
        _email = _emailController!.text;
      });
    _phoneController = TextEditingController(text: widget.user.phone ?? 'Non fournie')
      ..addListener(() {
        _phone = _phoneController!.text;
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

          if (user == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (verified == true) {
            return Text("verifié");
          } else {
            return Scaffold(
              backgroundColor: PRIMARY_COLOR,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: BackAppBar(
                  actions: [
                    TextButton(
                      onPressed: () {},
                      child: CText('sauvegarder'),
                    )
                  ],
                ),
              ),
              body: SingleChildScrollView(
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
                      TextButton(
                          onPressed: () =>
                              print("$_name $_surname $_gender ${_dateNonFormat == null ? _date : _dateNonFormat} $_email $_phone"),
                          child: Text('test'))
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget ttf(String text, TextEditingController? controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Stack(
        children: [
          Opacity(opacity: 0.65, child: CText(text)),
          TextFormField(
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
              _dateController!.text = DateFormat.MMMMEEEEd('fr').format(_date);
              print(_dateNonFormat);
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
        _dateNonFormat = _dateChoisie;
      });
    }
  }

  Widget hintText1(String text) {
    return Opacity(opacity: 0.65, child: CText(text));
  }
}
