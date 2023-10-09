import 'package:app_booking/layout/layout_screen.dart';
import 'package:app_booking/layout/navbar_admin_screen.dart';
import 'package:app_booking/resources/authentication_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../component/button.dart';
import '../component/contrast.dart';
import 'sign_up_screen.dart';

void main() {}

final GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = FirebaseFirestore.instance.collection('users');

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);
  static const String id = 'login';
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool? showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GoogleSignInAccount? _currentUser;

  // login() {
  //   googleSignIn.signIn();
  // }

  // createUserInFirestore() async {
  // login();
  // final GoogleSignInAccount user = googleSignIn.currentUser!;
  // DocumentSnapshot documentSnapshot = await usersRef.doc(user.id).get();
  // // 3) get username from create account, use it to make new user document in users collection
  // usersRef.doc(user.id).set({
  //   "uid": user.id,
  //   "username": user.displayName,
  //   "photoUrl": user.photoUrl,
  //   "email": user.email,
  // });
  // documentSnapshot = await usersRef.doc(user.id).get();
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage(
              'lib/asset/images_welcome/img_7.png',
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
          )),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Flexible(
                  child: Center(
                    child: Text(
                      'CHÀO MỪNG BẠN TRỞ LẠI,',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Vollkorn',
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        prefixIcon: const Icon(
                          FontAwesomeIcons.envelope,
                          color: Colors.white,
                        ),
                        hintText: 'Nhập email...',
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        // contentPadding:
                        // EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        hintText: 'Nhập mật khẩu...',
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    RoundeButton(
                      title: 'Đăng nhập',
                      color: Colors.white60,
                      onPressed: () async {
                        // setState(() {
                        //   showSpinner = true;
                        // });
                        try {
                          final users = (await _auth.signInWithEmailAndPassword(
                              email: email!, password: password!));

                          EasyLoading.showSuccess(
                            'Đăng nhập thành công !',
                            duration: const Duration(milliseconds: 1300),
                            maskType: EasyLoadingMaskType.black,
                          );
                          email == 'admin@email.com'
                              ? Navigator.pushNamed(
                                  context, NavbarAdminScreen.id)
                              : Navigator.pushNamed(context, NavbarScreen.id);
                          EasyLoading.showSuccess(
                            'Đăng nhập thành công !',
                            duration: const Duration(milliseconds: 1300),
                            maskType: EasyLoadingMaskType.black,
                          );
                        } catch (e) {
                          EasyLoading.showError(
                            'Sai tài khoản hoặc mật khẩu!',
                            duration: const Duration(milliseconds: 1300),
                            maskType: EasyLoadingMaskType.black,
                          );
                        }
                      },
                    ),
                    RoundeButton(
                      title: 'Tiếp tục với Google',
                      color: Colors.lightBlue,
                      onPressed: () async {
                        await AuthenticationMethods().handleGoogleSignIn();
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NavbarScreen(),
                          ),
                        );
                        await EasyLoading.showSuccess(
                          'Đăng nhập thành công !',
                          duration: const Duration(milliseconds: 1300),
                          maskType: EasyLoadingMaskType.black,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, SignUpScreen.id);
                  },
                  child: Container(
                    child: const Text(
                      'Tạo tài khoản mới',
                      style: TextStyle(
                        fontFamily: 'Vollkorn',
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
  // Future<UserCredential> signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth = await googleUser!.authentication;
  //
  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  //   UserModel userModel = UserModel();
  //   userModel.email = googleUser.email;
  //   userModel.uid = googleUser.id;
  //   userModel.userName = googleUser.displayName;
  //   // userModel.phoneNumber = phoneNumberEdittingController.text;
  //   userModel.avatar = googleUser.photoUrl;
  //   await firebaseFirestore.collection("users").doc(userModel.uid).set(userModel.toMap());
  //   // Once signed in, return the UserCredential
  //   print(googleAuth);
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }
}
