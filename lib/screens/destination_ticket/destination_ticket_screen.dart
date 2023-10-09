import 'dart:async';

import 'package:app_booking/component/currency_formatter.dart';
import 'package:app_booking/screens/book_now_screen.dart';
import 'package:app_booking/screens/book_ticket_screen/book_ticket_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

final _activities = FirebaseFirestore.instance;
late User loggedInUser;

class DestinationTicketScreen extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final String idCity;
  final String idHotel;
  final String nameLocation;
  DestinationTicketScreen(
      {required this.documentSnapshot,
      required this.idCity,
      required this.idHotel,
      required this.nameLocation});
  @override
  State<DestinationTicketScreen> createState() =>
      _DestinationTicketScreenState();
}

class _DestinationTicketScreenState extends State<DestinationTicketScreen> {
  final _auth = FirebaseAuth.instance.currentUser;

  @override
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  void _doSomething() async {
    Timer(const Duration(seconds: 3), () {
      _btnController.success();
    });
  }

  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print('e');
    }
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: ListView(
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0.2, 2.0),
                            blurRadius: 6.0,
                          )
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                widget.documentSnapshot['imageUrl']),
                            colorFilter: const ColorFilter.mode(
                                Colors.black26, BlendMode.darken),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 42),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.white24,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                FontAwesomeIcons.angleLeft,
                                color: Colors.white,
                              ),
                              iconSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 250, left: 10, right: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                FontAwesomeIcons.locationArrow,
                                size: 25,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                widget.nameLocation,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.8),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.documentSnapshot['nameTicket'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                            fontFamily: 'Vollkorn',
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              CurrencyFormatter.convertPrice(
                                  price: widget.documentSnapshot['price']),
                              style: TextStyle(
                                  color: Colors.blue.shade900,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Địa chỉ: ' + widget.documentSnapshot['nameCity'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Thông tin vé:',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.documentSnapshot['description'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookTicketScreen(
                    idCity: widget.idCity,
                    documentSnapshot: widget.documentSnapshot,
                    idTicket: widget.idHotel,
                    documentSnapshotTicket: widget.documentSnapshot,
                  ),
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.065,
              color: Colors.blueGrey,
              child: const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                child: Center(
                  child: Text(
                    'XEM CÁC LỰA CHỌN',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'Vollkorn',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
