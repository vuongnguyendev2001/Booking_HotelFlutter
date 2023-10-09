import 'package:app_booking/screens/sign_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../layout/layout_screen.dart';
import '../model/user_model.dart';

class AuthenticationMethods {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  handleAuthState() {
    FirebaseAuth.instance.authStateChanges();
    return StreamBuilder(
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return const NavbarScreen();
        } else {
          return const SignInScreen();
        }
      },
      stream: null,
    );
  }

  final googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  // Future<GoogleSignInAccount?> handleGoogleSignIn() async {
  //   try {
  //     postDetailsToFirestore();
  //     return googleSignIn.signIn();
  //   } catch (error) {
  //     rethrow;
  //   }
  // }
  final fireStore = FirebaseFirestore.instance;

  /// Google sign in
  Future<UserCredential> handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: ["email"]).signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      // if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // postDetailsToFirestore();
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (error) {
      rethrow;
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    UserModel userModel = UserModel();
    userModel.email = user!.email!;
    userModel.uid = user.uid;
    userModel.userName = user.displayName;
    userModel.phoneNumber = user.phoneNumber;
    userModel.avatar = user.photoURL;
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
  }

  Future<String> signUpUser(
      {required String name,
      required String address,
      required String email,
      required String password}) async {
    name.trim();
    address.trim();
    email.trim();
    password.trim();
    String output = "Something went wrong";
    if (name != "" && address != "" && email != "" && password != "") {
      try {
        await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        // UserModel user = UserModel(name: name, address: address);
        // await cloudFirestoreClass.uploadNameAndAddressToDatabase(user: user);
        output = "success";
      } on FirebaseAuthException catch (e) {
        output = e.message.toString();
      }
    } else {
      output = "Please fill up all the fields.";
    }
    return output;
  }

  Future<String> signInUser(
      {required String email, required String password}) async {
    email.trim();
    password.trim();
    String output = "Something went wrong";
    if (email != "" && password != "") {
      try {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        output = "success";
      } on FirebaseAuthException catch (e) {
        output = e.message.toString();
      }
    } else {
      output = "Please fill up all the fields.";
    }
    return output;
  }

  Future<void> handleSignOut() async {
    try {
      return FirebaseAuth.instance.signOut();
    } catch (error) {
      rethrow;
    }
  }
}
