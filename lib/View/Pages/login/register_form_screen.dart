import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/services/auth_service.dart';
import 'package:pts/View/Pages/login/id_form_screen.dart';

class RegisterFormScreen extends StatefulWidget {
  final user;

  const RegisterFormScreen({Key key, this.user}) : super(key: key);
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
    _name = (widget.user.displayName as String).split(" ")[0] ?? "";
    _surname = (widget.user.displayName as String).split(" ")[1] ?? "";

    _nameController = TextEditingController(text: _name);
    _surnameController = TextEditingController(text: _surname);
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
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          toolbarHeight: 0,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: TextFormField(
                          controller: _surnameController,
                          keyboardAppearance: Brightness.light,
                          decoration: InputDecoration(
                            labelText: "Nom :",
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            _surname = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Le champs ne dois pas être vide";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: TextFormField(
                          controller: _nameController,
                          keyboardAppearance: Brightness.light,
                          decoration: InputDecoration(
                            labelText: "Prénom :",
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            _name = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "le champs ne dois pas être vide";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: TextFormField(
                          // controller: _editingController,
                          keyboardAppearance: Brightness.light,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: "Téléphone (facultatif) :",
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            // _number = value;
                          },
                        ),
                      ),
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
                      Radius.circular(200),
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
                onTap: () {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }
                  // var user = AuthService.auth.currentUser;
                  // user.updateProfile(displayName: _name + " " + _surname).then(
                  //       (value) => Navigator.of(context).push(
                  //         MaterialPageRoute(
                  //           builder: (context) => IdFormScreen(
                  //             name: _name,
                  //             surname: _surname,
                  //           ),
                  //         ),
                  //       ),
                  //     );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
