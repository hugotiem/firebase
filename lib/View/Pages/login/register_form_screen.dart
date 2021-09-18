import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/Constant.dart';
import 'package:pts/View/Pages/login/id_form_screen.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/components/components_creation/tff_text.dart';

class RegisterFormScreen extends StatefulWidget {
  const RegisterFormScreen({Key key}) : super(key: key);
  @override
  _RegisterFormScreenState createState() => _RegisterFormScreenState();
}

class _RegisterFormScreenState extends State<RegisterFormScreen> {
  String _name;
  String _surname;

  TextEditingController _nameController;
  TextEditingController _surnameController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _nameController = TextEditingController()
      ..addListener(() {
        _name = _nameController.text;
      });
    _surnameController = TextEditingController()
      ..addListener(() {
        _surname = _surnameController.text;
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
            if (data != null) {
              _nameController.text = data.name;
              _surnameController.text = data.surname;
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
                                  if (value.isEmpty) {
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
                                  if (value.isEmpty) {
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
                            Center(
                              child: TFFText(
                                // controller: _editingController,
                                keyboardAppearance: Brightness.light,
                                keyboardType: TextInputType.phone,
                                onChanged: (value) {
                                  // _number = value;
                                },
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
                            if (!_formKey.currentState.validate()) {
                              return;
                            }
                            print(_name);
                            print(_surname);
                            await BlocProvider.of<UserCubit>(context)
                                .updateUserInfo(name: _name, surname: _surname)
                                .then(
                                  (_) => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => IdFormScreen(),
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
}
