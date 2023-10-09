import 'package:app_booking/layout/layout_screen.dart';
import 'package:app_booking/screens/order_hotel_screen.dart';
import 'package:app_booking/screens/order_ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({Key? key}) : super(key: key);

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

late User loggedInUser;

class _TabBarScreenState extends State<TabBarScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getCurrentUser();
  }

  final _auth = FirebaseAuth.instance;

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _user = loggedInUser;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _user.email != 'admin@email.com'
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      color: Colors.black45,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const NavbarScreen()));
                        },
                        icon: const Icon(FontAwesomeIcons.arrowLeft),
                      ),
                    ),
                  )
                : SizedBox(),
            const SizedBox(
              width: 30,
            ),
            const Text(
              'ĐƠN ĐẶT VÉ & ĐẶT PHÒNG',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.lightBlue.shade900,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            unselectedLabelColor: Colors.blue.shade200,
            labelColor: Colors.blue.shade900,
            tabs: [
              Tab(
                icon: Icon(FontAwesomeIcons.ticket),
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.hotel),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                OrderTicketScreen(),
                OrderHotelScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
