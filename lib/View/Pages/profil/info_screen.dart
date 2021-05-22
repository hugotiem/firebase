import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/Model/services/auth_service.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  var user;

  //AuthService instance
  AuthService _service = AuthService();

  // Text Editing Controllers
  TextEditingController _surnameController;
  TextEditingController _nameController;
  TextEditingController _emailController;

  TextEditingController _passwordController;

  // variables
  String _surname;
  String _name;
  String _email;

  // has to be compared to know if password is required when save
  String _newEmail;

  @override
  void initState() {
    this.user = AuthService.auth.currentUser;

    this._surname = user.displayName.split(" ")[1];
    this._name = user.displayName.split(" ")[0];
    this._email = user.email;

    this._newEmail = _email;

    _surnameController = new TextEditingController(text: this._surname);
    _nameController = new TextEditingController(text: this._name);
    _emailController = new TextEditingController(text: this._email);

    super.initState();
  }

  @override
  void dispose() {
    _surnameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(
          actions: <Widget>[
            CupertinoButton(
              onPressed: () {
                _service
                    .updateDisplayName(_name + " " + _surname)
                    .then((value) => Navigator.of(context).pop());

                if (_email.compareTo(_newEmail) != 0) {
                  AuthService.auth.currentUser.updateEmail(_newEmail);
                }
              },
              child: Text(
                "Enregistrer",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: SECONDARY_COLOR,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Text("Nom"),
                  CupertinoTextField.borderless(
                    controller: _surnameController,
                    onChanged: (value) => _surname = value,
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Text("Prénom"),
                  CupertinoTextField.borderless(
                    controller: _nameController,
                    onChanged: (value) => _name = value,
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Text("Email"),
                  CupertinoTextField.borderless(
                    controller: _emailController,
                    onChanged: (value) => _email = value,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
