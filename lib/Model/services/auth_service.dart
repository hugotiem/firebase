import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pts/Model/services/firestore_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FireStoreServices services = FireStoreServices("user");
  final FlutterSecureStorage storage = FlutterSecureStorage();

  FirebaseAuth get instance => _auth;

  User? get currentUser => _auth.currentUser;

  Future<void> setToken(String? token) async {
    await storage.write(key: "token", value: token);
  }

  Future<String?> getToken() async {
    var token = await storage.read(key: "token");
    return token;
  }

  Future<void> deleteToken() async {
    await storage.delete(key: "token");
    return;
  }

  Future<User?> register(String _email, String _password,
      {Map<String, dynamic>? data}) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      services.add(data: data);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // if (e.code == 'weak-password') {
      //   return 'The password provided is too weak.';
      // } else if (e.code == 'email-already-in-use') {
      //   return 'The account already exists for that email.';
      // } else if (e.code == 'invalid-email') {
      //   return 'Adresse email invalide.';
      // }
      throw e;
    }
  }

  Future<User?> signIn(String _email, String _password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // if (e.code == 'user-not-found') {
      //   return 'No user found for that email.';
      // } else if (e.code == 'wrong-password') {
      //   return 'Wrong password provided for that user.';
      // } else if (e.code == 'invalid-email') {
      //   return 'Adresse email invalide.';
      // }
      throw e;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return _auth.signInWithCredential(credential);
  }

  Future<void> reauthentification(
      {required String email, required String password}) async {
    EmailAuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password)
            as EmailAuthCredential;

    await _auth.currentUser!.reauthenticateWithCredential(credential);
  }

  Future<void> updateDisplayName(String name) async {
    await _auth.currentUser!.updateDisplayName(name);
    notifyListeners();
  }

  Future<String> updateEmail(String newEmail) async {
    try {
      await _auth.currentUser!.updateEmail(newEmail);
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        return "Email invalide";
      } else if (e.code == "email-already-in-use") {
        return "Email déjà utilisé par un autre compte";
      } else if (e.code == "requires-recent-login") {
        return "has to confirm";
      }
    }
    return "success";
  }
}
