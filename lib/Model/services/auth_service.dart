import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  static FirebaseAuth _auth;
  static bool isLogged = false;

  static FirebaseAuth get auth => _auth;

  static User get currentUser => _auth.currentUser;

  static void setAuth() {
    _auth = FirebaseAuth.instance;
  }

  static set logged(bool val) {
    isLogged = val;
  }

  Future<User> register(String _email, String _password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
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

  Future<User> signIn(String _email, String _password) async {
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
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return _auth.signInWithCredential(credential);
  }

  Future<void> reauthentification({String email, String password}) async {
    EmailAuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password);

    await _auth.currentUser.reauthenticateWithCredential(credential);
  }

  Future<void> updateDisplayName(String name) async {
    await _auth.currentUser.updateProfile(displayName: name);
    notifyListeners();
  }

  Future<String> updateEmail(String newEmail) async {
    try {
      await _auth.currentUser.updateEmail(newEmail);
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
