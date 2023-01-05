import 'package:app_booking/layout/layout_screen.dart';
import 'package:app_booking/screens/account_screen.dart';
import 'package:app_booking/screens/home_screen.dart';
import 'package:app_booking/screens/order_screen.dart';
import 'package:app_booking/screens/sign_in_screen.dart';
import 'package:app_booking/screens/splash_screen.dart';
import 'package:app_booking/screens/welcome_screen.dart';
import 'package:app_booking/services/city_management/Location_Screen.dart';
import 'package:app_booking/services/famousHotel_management/addFamousHotel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'screens/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      initialRoute: SplashScreen.id,
      routes: {
        WelcomeScreenn.id: (context) => const WelcomeScreenn(),
        SignInScreen.id: (context) => const SignInScreen(),
        SignUpScreen.id: (context) => const SignUpScreen(),
        SplashScreen.id: (context) => SplashScreen(),
        location_Screen.id: (context) => location_Screen(),
        NavbarScreen.id: (context) => NavbarScreen(),
        AccountScreen.id: (context) => AccountScreen(),
        addfamousHotel_Screen.id: (context) => addfamousHotel_Screen(),
        HomeScreen.id: (context) => HomeScreen(),
        OrderScreen.id: (context) => OrderScreen(),
      },
    );
  }
}
