import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:pts/Constant.dart';
import 'package:pts/blocs/user/user_cubit.dart';

class IdFormScreen extends StatefulWidget {
  final String? name;
  final String? surname;
  const IdFormScreen({Key? key, this.name, this.surname}) : super(key: key);

  @override
  _IdFormScreenState createState() => _IdFormScreenState();
}

class _IdFormScreenState extends State<IdFormScreen> {
  XFile? _idFrontImage;
  XFile? _idBackImage;
  XFile? _faceImage;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => UserCubit(),
          child: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: Builder(
                    builder: (context) => IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: SECONDARY_COLOR,
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        child: Text(
                          "Passer",
                          style: TextStyle(color: SECONDARY_COLOR),
                        ),
                      ),
                    ),
                  ],
                ),
                body: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text("Photo carte d'identité (Recto) :"),
                      Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          clipBehavior: Clip.antiAlias,
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            style: ButtonStyle(),
                            onPressed: () => _idFrontImage != null
                                ? _showBottomModalSheet(
                                    image: _idFrontImage,
                                    onPressed: () =>
                                        _showCupertinoModalPopup('front'),
                                    type: 'front',
                                  )
                                : _showCupertinoModalPopup('front'),
                            child: _idFrontImage == null
                                ? Text("Sélectionner une image")
                                : Text("Voir l'image"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Photo carte d'identité (Verso) :"),
                      Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          clipBehavior: Clip.antiAlias,
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: () => _idBackImage != null
                                ? _showBottomModalSheet(
                                    image: _idBackImage,
                                    onPressed: () =>
                                        _showCupertinoModalPopup('back'),
                                    type: 'front',
                                  )
                                : _showCupertinoModalPopup('back'),
                            child: _idBackImage == null
                                ? Text("Sélectionner une image")
                                : Text("Voir l'image"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Selfie : "),
                      Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          clipBehavior: Clip.antiAlias,
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
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
                                        _getImage(ImageSource.camera)
                                            .then((value) {
                                      setState(() {
                                        _faceImage = value;
                                      });
                                    }),
                                    type: 'selfie',
                                  ),
                            child: _faceImage == null
                                ? Text("Prendre une photo")
                                : Text("Voir l'image"),
                          ),
                        ),
                      ),
                    ],
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
                              Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            "enregistrer".toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onTap: () async {
                          if (_idFrontImage == null) {
                            //var message = "Veuillez saisir une image";
                            return;
                          }
                          if (_idBackImage == null) {
                            return;
                          }
                          if (_faceImage == null) {
                            return;
                          }
                          await BlocProvider.of<UserCubit>(context)
                              .addId(File(_idFrontImage!.path), "idFront")
                              .whenComplete(
                                () => BlocProvider.of<UserCubit>(context)
                                    .addId(File(_idBackImage!.path), "idBack")
                                    .whenComplete(() =>
                                        BlocProvider.of<UserCubit>(context)
                                            .addId(File(_faceImage!.path),
                                                "selfie")),
                              );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<XFile?> _getImage(ImageSource imageSource) async {
    var imagePicker = new ImagePicker();

    return await imagePicker.pickImage(source: imageSource);
  }

  Future<dynamic> _showCupertinoModalPopup(String idImage) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              _getImage(ImageSource.gallery).then((value) {
                setState(() {
                  switch (idImage) {
                    case 'front':
                      _idFrontImage = value;
                      break;
                    case 'back':
                      _idBackImage = value;
                      break;
                    default:
                      break;
                  }
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
                  switch (idImage) {
                    case 'front':
                      _idFrontImage = value;
                      break;
                    case 'back':
                      _idBackImage = value;
                      break;
                    default:
                      break;
                  }
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
      {XFile? image, void Function()? onPressed, String? type}) {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => Scaffold(
        backgroundColor: SECONDARY_COLOR,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
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
            File(image!.path),
            fit: BoxFit.cover,
          ),
        ),
        persistentFooterButtons: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            // height: 100,
            child: TextButton(
              onPressed: () {
                setState(() {
                  switch (type) {
                    case 'front':
                      _idFrontImage = null;
                      break;
                    case 'back':
                      _idBackImage = null;
                      break;
                    case 'selfie':
                      _faceImage = null;
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text(
                "Supprimer",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
