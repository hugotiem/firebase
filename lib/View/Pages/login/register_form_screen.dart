import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/services/auth_service.dart';

class RegisterFormScreen extends StatefulWidget {
  final user;

  const RegisterFormScreen({Key key, this.user}) : super(key: key);
  @override
  _RegisterFormScreenState createState() => _RegisterFormScreenState();
}

class _RegisterFormScreenState extends State<RegisterFormScreen> {
  String _name;
  String _surname;
  String _number;

  PickedFile _image;

  TextEditingController _nameController;
  TextEditingController _surnameController;

  @override
  void initState() {
    _name = (widget.user.displayName as String).split(" ")[0] ?? "";
    _surname = (widget.user.displayName as String).split(" ")[1] ?? "";

    _nameController = TextEditingController(text: _name);
    _surnameController = TextEditingController(text: _surname);
    super.initState();
  }

  Future<void> _getImage(ImageSource imageSource) async {
    var imagePicker = new ImagePicker();

    var image = await imagePicker.getImage(
      source: imageSource,
    );

    setState(() {
      _image = image;
      print("image : ${_image.readAsString()}");
    });
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
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: TextField(
                        controller: _surnameController,
                        keyboardAppearance: Brightness.light,
                        decoration: InputDecoration(
                          labelText: "Nom :",
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          _surname = value;
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: TextField(
                        controller: _nameController,
                        keyboardAppearance: Brightness.light,
                        decoration: InputDecoration(
                          labelText: "Prénom :",
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          _name = value;
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: TextField(
                        // controller: _editingController,
                        keyboardAppearance: Brightness.light,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Téléphone (facultatif) :",
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          _number = value;
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: TextButton(
                        onPressed: () => showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                            actions: [
                              CupertinoActionSheetAction(
                                onPressed: () => _getImage(ImageSource.gallery),
                                child: Text("Gallerie"),
                              ),
                              CupertinoActionSheetAction(
                                onPressed: () => _getImage(ImageSource.camera),
                                child: Text("Camera"),
                              ),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              child: Text("Annuler"),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        child: Text("Sélectionner une image"),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: GestureDetector(
                    child: Container(
                      width: size.width - 100,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: ICONCOLOR,
                        borderRadius: BorderRadius.all(
                          Radius.circular(200),
                        ),
                      ),
                      child: Text(
                        "enregister".toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () {
                      var user = AuthService.auth.currentUser;
                      user
                          .updateProfile(displayName: _name + " " + _surname)
                          .then((value) => Navigator.of(context).pop());
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
