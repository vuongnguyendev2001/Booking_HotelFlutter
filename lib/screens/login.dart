import 'package:app_booking/screens/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../component/button.dart';
import '../component/contrast.dart';
import 'gegister.dart';

void main() {}

final GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = FirebaseFirestore.instance.collection('users');

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static const String id = 'login';
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool? showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  GoogleSignInAccount? _currentUser;

  @override
  login() {
    googleSignIn.signIn();
  }
  // createUserInFirestore() async {
  //   login();
  //   final GoogleSignInAccount user = googleSignIn.currentUser!;
  //   DocumentSnapshot documentSnapshot = await usersRef.doc(user.id).get();
  //     // 3) get username from create account, use it to make new user document in users collection
  //     usersRef.doc(user.id).set({
  //       "uid": user.id,
  //       "username": user.displayName,
  //       "photoUrl": user.photoUrl,
  //       "email": user.email,
  //     });
  //   // documentSnapshot = await usersRef.doc(user.id).get();
  //   }

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
                Flexible(
                  child: Center(
                    child: Text(
                      'CHÀO MỪNG BẠN TRỞ LẠI,',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        prefixIcon: Icon(
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        prefixIcon: Icon(
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
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: MediaQuery.of(context).size.width * 0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade600,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                              side: BorderSide(color: Colors.white),
                              activeColor: Colors.blueGrey,
                              checkColor: Colors.white,
                              focusColor: Colors.white,
                              value: showSpinner,
                              onChanged: (value) {
                                setState(() {
                                  showSpinner = value;
                                  print(showSpinner);
                                });
                              }),
                          Text(
                            'Nhớ thông tin đăng nhập',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          // Text('Quên mật khẩu',
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.bold,
                          //       color: Colors.white,
                          //       fontSize: 18),),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
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
                          if (users != null && showSpinner == false) {
                            Navigator.pushNamed(context, NavbarScreen.id);
                            EasyLoading.showSuccess(
                              'Đăng nhập thành công !',
                              duration: Duration(milliseconds: 1300),
                              maskType: EasyLoadingMaskType.black,
                            );
                          } else if (users != null && showSpinner == true) {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            preferences.setString(
                                'email', emailController.text);
                            Navigator.pushNamed(context, NavbarScreen.id);
                            EasyLoading.showSuccess(
                              'Đăng nhập thành công !',
                              duration: Duration(milliseconds: 1300),
                              maskType: EasyLoadingMaskType.black,
                            );
                          }
                          // setState(() async {
                          //   showSpinner = false;
                          // });
                        } catch (e) {
                          EasyLoading.showError(
                            'Sai tài khoản hoặc mật khẩu!',
                            duration: Duration(milliseconds: 1300),
                            maskType: EasyLoadingMaskType.black,
                          );
                        }
                      },
                    ),
                    // RoundeButton(
                    //   title: 'Login with Google',
                    //   color: Colors.lightBlue,
                    //   onPressed: () {
                    //       //  createUserInFirestore();
                    //       // Navigator.pushNamed(context, NavbarScreen.id);
                    //       // print(email);
                    //   },
                    // ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Register.id);
                  },
                  child: Container(
                    child: Text(
                      'Tạo tài khoản mới',
                      style: TextStyle(
                        fontFamily: 'Vollkorn',
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
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
