import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:app_booking/layout/layout_screen.dart';
import 'package:app_booking/layout/navbar_admin_screen.dart';
import 'package:app_booking/screens/home_screen.dart';
import 'package:app_booking/screens/sign_in_screen.dart';
import 'package:app_booking/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

// String? finalEmail;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String id = 'splash_screen';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // void initState() {
  //   getValidationDate().whenComplete(() async {});
  //   super.initState();
  // }

  // Future getValidationDate() async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //   var get = sharedPreferences.getString('email');
  //   setState(() {
  //     finalEmail = get;
  //   });
  //   print(finalEmail);
  // }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashIconSize: 2500,
      splash: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'lib/asset/add_image/img_2.png',
                ),
                fit: BoxFit.cover,
                colorFilter:
                    ColorFilter.mode(Colors.black45, BlendMode.darken))),
        child: Container(
          padding: const EdgeInsets.all(30),
          margin:
              const EdgeInsets.only(top: 300, left: 20, right: 20, bottom: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // DefaultTextStyle(
              //   style: const TextStyle(
              //     fontSize: 25.0,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.white,
              //     fontFamily: "Vollkorn",
              //   ),
              //   child: finalEmail != null
              //       ? AnimatedTextKit(
              //           animatedTexts: [
              //             ScaleAnimatedText('ĐẶT PHÒNG NHANH CHÓNG',
              //                 duration: Duration(milliseconds: 2400)),
              //             ScaleAnimatedText(
              //               'XIN CHÀO !\n $finalEmail',
              //               textAlign: TextAlign.center,
              //               duration: Duration(milliseconds: 2400),
              //               textStyle: TextStyle(
              //                 fontSize: 30,
              //               ),
              //             )
              //           ],
              //           onTap: () {
              //             EasyLoading.showSuccess(
              //               'Đăng nhập thành công !',
              //               duration: Duration(milliseconds: 1300),
              //               maskType: EasyLoadingMaskType.black,
              //             );
              //           },
              //         )
              //       : AnimatedTextKit(
              //           animatedTexts: [
              //             ScaleAnimatedText('ĐẶT PHÒNG NHANH CHÓNG',
              //                 duration: Duration(milliseconds: 2000)),
              //           ],
              //           onTap: () {},
              //         ),
              // ),
              Center(
                child: SpinKitFadingCircle(
                  size: 65,
                  itemBuilder: (_, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: index.isEven ? Colors.white70 : Colors.blueGrey,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      duration: 1200,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.rightToLeftWithFade,
      // nextScreen:
      //     finalEmail == null ? const SignInScreen() : const NavbarScreen(),
      nextScreen: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> user) {
          if (user.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (user.hasData && user.data?.email != 'admin@email.com') {
            return const NavbarScreen();
          } else if (user.hasData && user.data?.email == 'admin@email.com') {
            return const NavbarAdminScreen();
          } else {
            return const SignInScreen();
          }
        },
      ),
    );
  }
}
