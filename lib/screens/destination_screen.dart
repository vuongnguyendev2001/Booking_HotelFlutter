import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'book_now_screen.dart';

final _activities = FirebaseFirestore.instance;
late User loggedInUser;

class DestinationScreen extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final String idCity;
  final String idHotel;
  DestinationScreen(
      {required this.documentSnapshot,
      required this.idCity,
      required this.idHotel});
  @override
  State<DestinationScreen> createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  final _auth = FirebaseAuth.instance.currentUser;

  @override
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  void _doSomething() async {
    Timer(Duration(seconds: 3), () {
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
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width * 0.8,
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
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25)),
                            image: DecorationImage(
                              image: NetworkImage(
                                  widget.documentSnapshot['imageUrl']),
                              colorFilter: ColorFilter.mode(
                                  Colors.black45, BlendMode.darken),
                              fit: BoxFit.cover,
                            ))),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 42),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white24,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
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
                        const EdgeInsets.only(top: 280, left: 10, right: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.locationArrow,
                              size: 25,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.documentSnapshot['nameCity'],
                              style: TextStyle(
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
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  alignment: Alignment.topLeft,
                  height: 360,
                  // width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.hotel,
                              size: 22,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              widget.documentSnapshot['nameHotel'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.8,
                                fontFamily: 'Vollkorn',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.moneyBill,
                              size: 21,
                            ),
                            Text(
                              ' ' +
                                  NumberFormat.simpleCurrency(
                                          locale: 'vi-VN', decimalDigits: 0)
                                      .format(
                                          widget.documentSnapshot['price']) +
                                  '/ đêm',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.calendarDays,
                              size: 19,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Nhận phòng: ' +
                                  widget.documentSnapshot['checkIn'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              FontAwesomeIcons.calendarDays,
                              size: 19,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Trả phòng: ' +
                                  widget.documentSnapshot['checkOut'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Địa chỉ: ' + widget.documentSnapshot['address'],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.4),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Mô tả: ' + widget.documentSnapshot['description'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.6,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookNowScreen(
                      idCity: widget.idCity,
                      idHotel: widget.idHotel,
                      documentSnapshot: widget.documentSnapshot),
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
              color: Colors.blueGrey,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                child: Center(
                  child: Text(
                    'XEM CÁC LỰA CHỌN',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
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
