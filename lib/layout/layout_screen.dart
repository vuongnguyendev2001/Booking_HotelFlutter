import 'package:app_booking/component/contrast.dart';
import 'package:app_booking/resources/cloudfirestore_methods.dart';
import 'package:app_booking/screens/home_screen.dart';
import 'package:app_booking/screens/account_screen.dart';
import 'package:app_booking/screens/all_city_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavbarScreen extends StatefulWidget {
  const NavbarScreen({Key? key}) : super(key: key);
  static const String id = 'navbar_screen';
  @override
  State<NavbarScreen> createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen> {
  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void initState() {
    super.initState();
    CloudFirestoreMethod().getAvatarNameandEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 16,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey.shade400,
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: Colors.lightBlue.shade900,
        unselectedItemColor: Colors.blueGrey.shade700,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        elevation: 1,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.home,
              ),
              label: 'Trang chủ'),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.locationDot,
              ),
              label: 'Địa điểm'),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.userTie,
              ),
              label: "Tài khoản"),
        ],
      ),
    );
  }
}
