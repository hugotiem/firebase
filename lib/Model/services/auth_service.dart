import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static FirebaseAuth _auth;
  static bool isLogged = false;

  static FirebaseAuth get auth => _auth;

  static void setAuth() {
    _auth = FirebaseAuth.instance;
  }

  static set logged(bool val) {
    isLogged = val;
  }

  Future<Map<String, User>> register(String _email, String _password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      return {"success": userCredential.user};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return {'The password provided is too weak.': null};
      } else if (e.code == 'email-already-in-use') {
        return {'The account already exists for that email.': null};
      } else if (e.code == 'invalid-email') {
        return {'Adresse email invalide.': null};
      }
      return {e.code: null};
    }
  }

  Future<Map<String, User>> signIn(String _email, String _password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      return {"success": userCredential.user};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return {'No user found for that email.': null};
      } else if (e.code == 'wrong-password') {
        return {'Wrong password provided for that user.': null};
      } else if (e.code == 'invalid-email') {
        return {'Adresse email invalide.': null};
      }
      return {e.code: null};
    }
  }
}
