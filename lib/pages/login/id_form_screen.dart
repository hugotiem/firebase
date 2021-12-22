import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:pts/const.dart';
import 'package:pts/blocs/user/user_cubit.dart';

enum VerificationType { idFront, idBack, selfie }

class IdFormScreen extends StatefulWidget {
  final String? name;
  final String? surname;
  final String? token;
  const IdFormScreen({Key? key, this.name, this.surname, this.token}) : super(key: key);

  @override
  _IdFormScreenState createState() => _IdFormScreenState();
}

class _IdFormScreenState extends State<IdFormScreen> {
  File? _idFrontImage;
  File? _idBackImage;
  File? _faceImage;

  GlobalKey<NavigatorState>? loaderKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => UserCubit(),
          child: BlocListener<UserCubit, UserState>(
            listener: (context, state) {
              if (state.status == UserStatus.idUploaded) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }

              if (state.requestInProgress == false && loaderKey != null) {
                Navigator.of(loaderKey!.currentContext!).pop();
                loaderKey = null;
              }
            },
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
                                      type: VerificationType.idFront,
                                    )
                                  : _showCupertinoModalPopup(
                                      VerificationType.idFront),
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
                                      type: VerificationType.idBack,
                                    )
                                  : _showCupertinoModalPopup(
                                      VerificationType.idBack),
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
                                  ? _getImage(ImageSource.camera,
                                      VerificationType.selfie)
                                  : _showBottomModalSheet(
                                      image: _faceImage,
                                      type: VerificationType.selfie,
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
                            if (loaderKey == null) {
                              loaderKey = GlobalKey<NavigatorState>();
                            }
                             _showLoadingPopup();
                            await BlocProvider.of<UserCubit>(context)
                                .addId(_idFrontImage, "idFront", widget.token)
                                .whenComplete(
                                  () => BlocProvider.of<UserCubit>(context)
                                      .addId(_idBackImage, "idBack", widget.token)
                                      .whenComplete(
                                        () =>
                                            BlocProvider.of<UserCubit>(context)
                                                .addId(_faceImage, "selfie", widget.token),
                                      )
                                      .whenComplete(
                                        () =>
                                            BlocProvider.of<UserCubit>(context)
                                                .emit(
                                          UserState.idUploaded(
                                              token: state.token,
                                              user: state.user),
                                        ),
                                      ),
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
      ),
    );
  }

  Future<void> _getImage(
      ImageSource imageSource, VerificationType? type) async {
    try {
      var imagePicker = new ImagePicker();
      var image = await imagePicker.pickImage(source: imageSource);
      print(image);
      if (image == null) return;
      _setState(File(image.path), type);
    } on PlatformException catch (e) {
      print("failed to pick image $e");
    }
  }

  void _setState(File img, VerificationType? type) {
    setState(() {
      switch (type) {
        case VerificationType.idFront:
          _idFrontImage = img;
          break;
        case VerificationType.idBack:
          _idBackImage = img;
          break;
        case VerificationType.selfie:
          _faceImage = img;
          break;
        default:
          break;
      }
    });
  }

  Future<dynamic> _showCupertinoModalPopup(VerificationType? type) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              _getImage(ImageSource.gallery, type);
              Navigator.of(context).pop();
            },
            child: Text("Gallerie"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              _getImage(ImageSource.camera, type);
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

  Future<dynamic> _showBottomModalSheet({File? image, VerificationType? type}) {
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
              onPressed: () => type == VerificationType.selfie
                  ? _getImage(ImageSource.camera, VerificationType.selfie)
                  : _showCupertinoModalPopup(type),
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
                    case VerificationType.idFront:
                      _idFrontImage = null;
                      break;
                    case VerificationType.idBack:
                      _idBackImage = null;
                      break;
                    case VerificationType.selfie:
                      _faceImage = null;
                      break;
                    default:
                      break;
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

  Future<dynamic> _showLoadingPopup() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: SimpleDialog(
          key: loaderKey,
          backgroundColor: Colors.transparent,
          elevation: 0,
          children: [
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}
