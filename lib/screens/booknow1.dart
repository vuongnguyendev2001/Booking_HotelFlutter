import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'myorder_Screen.dart';

class Booknow1_Screen extends StatefulWidget {
  final DocumentSnapshot documentSnapshotHotel;
  final DocumentSnapshot documentSnapshot;
  final String idHotel;
  final String idCity;
  final String idRoom;
  Booknow1_Screen(
      {Key? key,
      required this.documentSnapshot,
      required this.idHotel,
      required this.idCity,
      required this.idRoom,
      required this.documentSnapshotHotel})
      : super(key: key);

  @override
  State<Booknow1_Screen> createState() => _Booknow1_ScreenState();
}

late User loggedInUser;

class _Booknow1_ScreenState extends State<Booknow1_Screen> {
  final _auth = FirebaseAuth.instance;
  final _booking = FirebaseFirestore.instance;
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate = DateTime.now();
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print('User: $user');
      }
    } catch (e) {
      print(e);
    }
  }

  int? myInitialItem = 0;
  int _countRoom = 1;
  int _diference = 0;
  void _incrementCount() {
    setState(() {
      _countRoom++;
      print(_countRoom);
    });
  }

  void _decrementCount() {
    if (_countRoom < 1) {
      return;
    }
    setState(() {
      _countRoom--;
    });
  }

  void booking_Hotel() {
    _booking.collection('booking').add({
      "imageUrl": widget.documentSnapshotHotel['imageUrl'],
      "nameHotel": widget.documentSnapshotHotel['nameHotel'],
      "nameRoom": widget.documentSnapshot['nameRoom'],
      "addressHotel": widget.documentSnapshotHotel['address'],
      "startDate": _startDate,
      "endDate": _endDate,
      "room": _countRoom,
      "price":
          (int.parse(widget.documentSnapshot['price']) * _countRoom).toString(),
      "emailUser": loggedInUser.email,
      "DateTimebooking": DateTime.now(),
    });
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        builder: (context) => myorder_Screen(), maintainState: true));
    EasyLoading.showSuccess(
      'Đặt phòng thành công!',
      duration: Duration(milliseconds: 1300),
      maskType: EasyLoadingMaskType.black,
    );
  }

  // List<String> rooms = ["1 giường", "2 giường", "3 giường", "4 giường"];
  int selectedBed = 0;
  @override
  Widget build(BuildContext context) {
    final int price = int.parse(widget.documentSnapshot['price']) * _countRoom;
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        fit: StackFit.loose,
        children: [
          ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.width * 0.55,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      widget.documentSnapshotHotel['imageUrl']),
                                  fit: BoxFit.cover,
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.width * 0.3,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    widget.documentSnapshotHotel['nameHotel'],
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Vollkorn',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Text(
                                    widget.documentSnapshot['nameRoom'],
                                    style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Text(
                                    widget.documentSnapshotHotel['address'],
                                    style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.width * 0.12,
                                  color: Colors.grey.shade400,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 1),
                                        child: Text(
                                          'Nhận: ' +
                                              widget.documentSnapshotHotel[
                                                  'checkIn'],
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Icon(
                                        FontAwesomeIcons.hourglassStart,
                                        color: Colors.blueGrey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.width * 0.12,
                                  color: Colors.grey.shade400,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 1),
                                        child: Text(
                                          'Trả: ' +
                                              widget.documentSnapshotHotel[
                                                  'checkOut'],
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Icon(
                                        FontAwesomeIcons.hourglassEnd,
                                        color: Colors.blueGrey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Chọn ngày: ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  DateTime? startDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2023),
                                  );
                                  setState(() {
                                    _startDate = startDate;
                                    print(_startDate);
                                  });
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.width * 0.12,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade400,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 1),
                                        child: Text(
                                          '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Icon(
                                        FontAwesomeIcons.calendarDays,
                                        color: Colors.blueGrey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 9,
                              ),
                              Icon(FontAwesomeIcons.rightLong),
                              SizedBox(
                                width: 9,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  DateTime? endDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );
                                  setState(() {
                                    _endDate = endDate;
                                    print(_endDate);
                                  });
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.width * 0.12,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade400,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 1),
                                        child: Text(
                                          '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Icon(
                                        FontAwesomeIcons.calendarDays,
                                        color: Colors.blueGrey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Số lượng phòng: ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: MediaQuery.of(context).size.width * 0.1,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 17,
                                      child: FloatingActionButton(
                                        onPressed: _decrementCount,
                                        child: Icon(Icons.remove),
                                        backgroundColor: Colors.black38,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      '$_countRoom',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    CircleAvatar(
                                      radius: 17,
                                      child: FloatingActionButton(
                                        onPressed: _incrementCount,
                                        child: Icon(Icons.add),
                                        backgroundColor: Colors.black38,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Container(
                          //   alignment: Alignment.center,
                          //   width: MediaQuery.of(context).size.width * 0.4,
                          //   height: MediaQuery.of(context).size.width * 0.1,
                          //   color: Colors.grey,
                          //   child: DropdownButton<String>(
                          //       value: selectedRoom,
                          //       items: rooms
                          //           .map((room) => DropdownMenuItem<String>(
                          //               value: room, child: Text(room)))
                          //           .toList(),
                          //       onChanged: (room) {
                          //         setState(() {
                          //           selectedRoom = room;
                          //         });
                          //       }),
                          // ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tổng giá tiền: ',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '$price' ' VND',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: booking_Hotel,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'ĐẶT PHÒNG',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        fontFamily: 'Vollkorn',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
