import 'package:app_booking/layout/layout_screen.dart';
import 'package:app_booking/layout/navbar_admin_screen.dart';
import 'package:app_booking/screens/account_screen.dart';
import 'package:app_booking/screens/admin_screen/list_location/location_screen.dart';
import 'package:app_booking/screens/admin_screen/list_user/list_user_screen.dart';
import 'package:app_booking/screens/chat_home/chat_home_screen.dart';
import 'package:app_booking/screens/home_screen.dart';
import 'package:app_booking/screens/order_hotel_screen.dart';
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
        SplashScreen.id: (context) => const SplashScreen(),
        location_Screen.id: (context) => const location_Screen(),
        NavbarScreen.id: (context) => const NavbarScreen(),
        NavbarAdminScreen.id: (context) => const NavbarAdminScreen(),
        AccountScreen.id: (context) => const AccountScreen(),
        addfamousHotel_Screen.id: (context) => const addfamousHotel_Screen(),
        HomeScreen.id: (context) => HomeScreen(),
        OrderHotelScreen.id: (context) => const OrderHotelScreen(),
        chatHomePage.id: (context) => const chatHomePage(),
        LocationScreen.id: (context) => const LocationScreen(),
        ListUserScreen.id: (context) => const ListUserScreen(),
      },
    );
  }
}
