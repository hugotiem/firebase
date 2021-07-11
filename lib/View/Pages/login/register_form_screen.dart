import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
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

  PickedFile _idImage;
  PickedFile _faceImage;

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

  Future<PickedFile> _getImage(ImageSource imageSource) async {
    var imagePicker = new ImagePicker();

    return await imagePicker.getImage(source: imageSource);
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
          brightness: Brightness.light,
        ),
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
                    child: TextButton(
                      style: ButtonStyle(),
                      onPressed: () => _idImage != null
                          ? _showBottomModalSheet(
                              image: _idImage,
                              onPressed: () => _showCupertinoModalPopup(),
                              isID: true,
                            )
                          : _showCupertinoModalPopup(),
                      child: _idImage == null
                          ? Text("Sélectionner une image")
                          : Text("Voir l'image"),
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
                    child: TextButton(
                      onPressed: () => _faceImage == null
                          ? _getImage(ImageSource.camera).then((value) {
                              setState(() {
                                _faceImage = value;
                              });
                            })
                          : _showBottomModalSheet(
                              image: _faceImage,
                              onPressed: () =>
                                  _getImage(ImageSource.camera).then((value) {
                                setState(() {
                                  _faceImage = value;
                                });
                              }),
                              isID: false,
                            ),
                      child: _faceImage == null
                          ? Text("Sélectionner une image")
                          : Text("Voir l'image"),
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

  Future<dynamic> _showCupertinoModalPopup() {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              _getImage(ImageSource.gallery).then((value) {
                setState(() {
                  _idImage = value;
                });
              });
              Navigator.of(context).pop();
            },
            child: Text("Gallerie"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              _getImage(ImageSource.camera).then((value) {
                setState(() {
                  _idImage = value;
                });
              });
              Navigator.of(context).pop();
            },
            child: Text("Camera"),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text("Annuler"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  Future<dynamic> _showBottomModalSheet(
      {PickedFile image, void Function() onPressed, bool isID}) {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => Scaffold(
        backgroundColor: SECONDARY_COLOR,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 150,
          actions: [
            TextButton(
              onPressed: () => onPressed,
              child: Text("Reprendre"),
            ),
          ],
        ),
        body: Center(
          child: Image.file(
            File(image.path),
          ),
        ),
        bottomSheet: Container(
          color: SECONDARY_COLOR,
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: TextButton(
            onPressed: () {
              setState(() {
                if (isID)
                  _idImage = null;
                else
                  _faceImage = null;
              });
              Navigator.of(context).pop();
            },
            child: Text(
              "Supprimer",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
