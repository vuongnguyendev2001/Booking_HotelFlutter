import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:app_booking/screens/login.dart';
import 'package:app_booking/screens/navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? finalEmail;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String id = 'splash_screen';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    getValidationDate().whenComplete(() async {});
    super.initState();
  }

  Future getValidationDate() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var get = sharedPreferences.getString('email');
    setState(() {
      finalEmail = get;
    });
    print(finalEmail);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashIconSize: 2500,
      splash: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                  'https://nld.mediacdn.vn/291774122806476800/2021/9/10/hagiang-nld-3-1631246603578128307665.jpg',
                ),
                fit: BoxFit.cover,
                colorFilter:
                    ColorFilter.mode(Colors.black45, BlendMode.darken))),
        child: Container(
          margin: EdgeInsets.only(top: 200, left: 20, right: 20, bottom: 140),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: "Vollkorn",
                    ),
                    child: finalEmail != null
                        ? AnimatedTextKit(
                            animatedTexts: [
                              ScaleAnimatedText('ĐẶT PHÒNG NHANH CHÓNG',
                                  duration: Duration(milliseconds: 2400)),
                              ScaleAnimatedText(
                                'XIN CHÀO !\n $finalEmail',
                                textAlign: TextAlign.center,
                                duration: Duration(milliseconds: 2400),
                                textStyle: TextStyle(
                                  fontSize: 30,
                                ),
                              )
                            ],
                            onTap: () {
                              EasyLoading.showSuccess(
                                'Đăng nhập thành công !',
                                duration: Duration(milliseconds: 1300),
                                maskType: EasyLoadingMaskType.black,
                              );
                            },
                          )
                        : AnimatedTextKit(
                            animatedTexts: [
                              ScaleAnimatedText('ĐẶT PHÒNG NHANH CHÓNG',
                                  duration: Duration(milliseconds: 2000)),
                            ],
                            onTap: () {},
                          ),
                  ),
                  Center(
                    child: SpinKitFadingCircle(
                      size: 65,
                      itemBuilder: (_, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color:
                                index.isEven ? Colors.white70 : Colors.blueGrey,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      duration: 5000,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.rightToLeftWithFade,
      nextScreen: finalEmail == null ? Login() : NavbarScreen(),
      // nextScreen: Login(),
    );
  }
}
