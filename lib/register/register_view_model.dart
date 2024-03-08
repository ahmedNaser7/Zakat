import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../provider/base.dart';
import '../database_utils.dart';
import '../provider/firebase_errors.dart';
import '../provider/my_user.dart';
import 'navigator.dart';

// provider
class RegisterViewModel extends BaseViewModel<RegisterNavigator> {
  // Logic- hold Data
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void register(String email, String password, String firstName,
      String lastName, String userName) async {
    String? message;
    try {
      navigator?.showLoading();
      var result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      // add user in databse
      var user = MyUser(
          id: result.user?.uid ?? "",
          fName: firstName,
          lName: lastName,
          userName: userName,
          email: email);
      var task =  await DataBaseUtils.createDBUser(user);
      navigator?.gotoHome(user);
      return;
    } on FirebaseAuthException catch (e) {
      if (e.code == FirebaseErrors.weakPassword) {
        message = 'The password provided is too weak.';
      } else if (e.code == FirebaseErrors.email_in_use) {
        message = 'The account already exists for that email';
      } else {
        message = 'Wrong username or password';
      }
    } catch (e) {
      message = e.toString();
    }
    navigator?.hideDialog();
    if (message != null) {
      navigator?.showMessage(message);
    }
  }
}