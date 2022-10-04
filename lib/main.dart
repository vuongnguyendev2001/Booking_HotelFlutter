import 'package:app_booking/screens/Home_Screen.dart';
import 'package:app_booking/screens/account_screen.dart';
import 'package:app_booking/screens/addFamousHotel.dart';
import 'package:app_booking/screens/editprofile_screen.dart';
import 'package:app_booking/screens/Location_Screen.dart';
import 'package:app_booking/screens/login.dart';
import 'package:app_booking/screens/myorder_Screen.dart';
import 'package:app_booking/screens/navbar.dart';
import 'package:app_booking/screens/splash_screen.dart';
import 'package:app_booking/screens/welcome.dart';
import '../screens/gegister.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
        Welcome.id: (context) => const Welcome(),
        Login.id: (context) => const Login(),
        Register.id: (context) => const Register(),
        SplashScreen.id: (context) => SplashScreen(),
        location_Screen.id: (context) => location_Screen(),
        NavbarScreen.id: (context) => NavbarScreen(),
        AccountScreen.id: (context) => AccountScreen(),
        addfamousHotel_Screen.id: (context) => addfamousHotel_Screen(),
        HomeScreen.id: (context) => HomeScreen(),
        myorder_Screen.id: (context) => myorder_Screen(),
      },
    );
  }
}
