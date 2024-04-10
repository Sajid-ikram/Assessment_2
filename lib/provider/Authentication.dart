import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../view/Auth/widgets/snackBar.dart';

class Authentication with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();


  Future<String> signIn(
      String email, String password, BuildContext context) async {
    try {
      var user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      FirebaseFirestore.instance
          .collection("users")
          .doc(user.user?.uid)
          .update(
        {
          "token": "",
        },
      );
      return "Success";
    } on FirebaseAuthException catch (e) {
      print(e);
      print(e.code);
      print("-------------------------------------------- e.code");
      switch (e.code) {

        case "invalid-email":
          return "Your email address appears to be malformed.";
        case "wrong-password":
          return "Wrong password";

        case "user-not-found":
          return "User with this email doesn't exist.";

        case "user-disabled":
          return "User with this email has been disabled.";

        case "invalid-credential":
          return "invalid credential";

        default:
          return "An undefined Error happened.";
      }
    } catch (e) {
      return "An Error occur";
    }
  }

  Future<String> signUp(
      {required String name,
      required String email,
      required String password,
      required String fCode,
      required context,
      bool isRegistration = true}) async {
    try {
      _firebaseAuth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then(
        (value) async {
          Navigator.of(context, rootNavigator: true).pop();
          if (isRegistration)
            Navigator.of(context).pushReplacementNamed("HoldingPage");
          FirebaseFirestore.instance
              .collection("users")
              .doc(value.user!.uid)
              .set(
            {
              "name": name,
              "email": value.user!.email,
              "url": "",
              "role": fCode.isEmpty ? "" : "contractor",
              "token": ""
            },
          );
        },
      ).catchError((error) {
        Navigator.of(context, rootNavigator: true).pop();
        switch (error.code) {
          case "weak-password":
            snackBar(context, "Your password is too weak");

          case "invalid-email":
            snackBar(context, "Your email is invalid");

          case "email-already-in-use":
            snackBar(context, "Email is already in use on different account");

          default:
            snackBar(context, "An undefined Error happened.");
        }
      });

      return "Success";
    } on FirebaseAuthException catch (e) {
      print("--------------------------+++++++++++++++++++++++0");
      Navigator.of(context, rootNavigator: true).pop();
      switch (e.code) {
        case "weak-password":
          return "Your password is too weak";

        case "invalid-email":
          return "Your email is invalid";

        case "email-already-in-use":
          return "Email is already in use on different account";

        default:
          return "An undefined Error happened.";
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      print("--------------------------+++++++++++++++++++++++1 11 1");
      return "An Error occur";
    }
  }

  Future signOut() async {
    await _firebaseAuth.signOut();
    notifyListeners();
  }

  Future<String> resetPassword(String email, BuildContext context) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);

      return "Success";
    } catch (e) {
      return "Error";
    }
  }

  Future deleteUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .delete();
      user.delete();
    }
  }
}


