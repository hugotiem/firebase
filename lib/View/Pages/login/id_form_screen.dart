import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:pts/Constant.dart';

class IdFormScreen extends StatefulWidget {
  final String name;
  final String surname;
  const IdFormScreen({Key key, this.name, this.surname}) : super(key: key);

  @override
  _IdFormScreenState createState() => _IdFormScreenState();
}

class _IdFormScreenState extends State<IdFormScreen> {
  PickedFile _idFrontImage;
  PickedFile _idBackImage;
  PickedFile _faceImage;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: () {},
              child: Text(
                "Passer",
                style: TextStyle(color: SECONDARY_COLOR),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
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
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextButton(
                  style: ButtonStyle(),
                  onPressed: () => _idFrontImage != null
                      ? _showBottomModalSheet(
                          image: _idFrontImage,
                          onPressed: () => _showCupertinoModalPopup('front'),
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
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextButton(
                  onPressed: () => _idBackImage != null
                      ? _showBottomModalSheet(
                          image: _idBackImage,
                          onPressed: () => _showCupertinoModalPopup('back'),
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
                    Radius.circular(200),
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
              onTap: () {
                sendPicturesByEmail(
                  "${widget.surname.toUpperCase()} ${widget.name}",
                  File(_idFrontImage.path),
                  File(_idBackImage.path),
                  File(_faceImage.path),
                ).then((value) => null);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<PickedFile> _getImage(ImageSource imageSource) async {
    var imagePicker = new ImagePicker();

    return await imagePicker.getImage(source: imageSource);
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
      {PickedFile image, void Function() onPressed, String type}) {
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
            File(image.path),
            fit: BoxFit.cover,
          ),
        ),
        persistentFooterButtons: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            height: 100,
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

Future<void> sendPicturesByEmail(
    String mail, File idFront, File idBack, File selfie) async {
  String username = 'pourtasoiree@gmail.com';
  String password = 'MHJ.du_1461';

  final smtpServer = hotmail(username, password);

  final message = Message()
    ..from = Address(username, 'PTS')
    ..recipients.add(username)
    ..subject = '$mail - ID Verification :: ${DateTime.now()}'
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>"
    ..attachments = [
      FileAttachment(idFront),
      FileAttachment(idBack),
      FileAttachment(selfie)
    ];

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent. ${e.message}');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}
