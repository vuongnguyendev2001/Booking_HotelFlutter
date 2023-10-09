import 'dart:convert';

import 'package:app_booking/component/currency_formatter.dart';
import 'package:app_booking/layout/tabbar_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'order_hotel_screen.dart';
import 'package:http/http.dart' as http;

class BookNowNextScreen extends StatefulWidget {
  final DocumentSnapshot documentSnapshotHotel;
  final DocumentSnapshot documentSnapshot;
  final String idHotel;
  final String idCity;
  final String idRoom;
  BookNowNextScreen(
      {Key? key,
      required this.documentSnapshot,
      required this.idHotel,
      required this.idCity,
      required this.idRoom,
      required this.documentSnapshotHotel})
      : super(key: key);

  @override
  State<BookNowNextScreen> createState() => _BookNowNextScreenState();
}

late User loggedInUser;

class _BookNowNextScreenState extends State<BookNowNextScreen> {
  final _auth = FirebaseAuth.instance;
  final _booking = FirebaseFirestore.instance;
  bool _loading = false;
  bool isCancel = false;
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate = DateTime.now();
  List<DateTime> dates = [DateTime(2021, 7, 30), DateTime(2021, 6, 25)];
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
    });
  }

  void _decrementCount() {
    if (_countRoom <= 1) {
      EasyLoading.showError('Số lượng phòng bằng 0');
      return;
    }
    setState(() {
      _countRoom--;
    });
  }

  Future booking_Hotel() async {
    await _booking.collection('booking').add({
      "imageUrl": widget.documentSnapshotHotel['imageUrl'],
      "nameHotel": widget.documentSnapshotHotel['nameHotel'],
      "nameRoom": widget.documentSnapshot['nameRoom'],
      "addressHotel": widget.documentSnapshotHotel['address'],
      "startDate": _startDate,
      "endDate": _endDate,
      "room": _countRoom,
      "price": widget.documentSnapshot['price'] * _countRoom,
      "emailUser": loggedInUser.email,
      "DateTimebooking": DateTime.now(),
      "isCancel": isCancel
    });
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        builder: (context) => const TabBarScreen(), maintainState: true));
    EasyLoading.showSuccess(
      'Đặt phòng thành công!',
      duration: const Duration(milliseconds: 1300),
      maskType: EasyLoadingMaskType.black,
    );
  }

  Future sendEmailOrderHotel() async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    const serviceId = "service_mjlbj5v";
    const templateId = "template_y1ggzmc";
    const userId = "CWHenK88Ngphy24tC";
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {
          "service_id": serviceId,
          "template_id": templateId,
          "user_id": userId,
          "template_params": {
            "user_name": loggedInUser.displayName,
            "name_hotel": widget.documentSnapshotHotel['nameHotel'],
            "kind_room": widget.documentSnapshot['nameRoom'],
            "address": widget.documentSnapshotHotel['address'],
            "start_day":
                '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                    .toString(),
            "end_day": '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                .toString(),
            "quantity_room": _countRoom,
            "price_room": CurrencyFormatter.convertPrice(
                price: widget.documentSnapshot['price']),
            "total": CurrencyFormatter.convertPrice(
                    price: widget.documentSnapshot['price'] * _countRoom)
                .toString(),
            "email_user": loggedInUser.email,
          }
        },
      ),
    );
    print(response.body);
    return response.statusCode;
  }

  int selectedBed = 0;
  @override
  Widget build(BuildContext context) {
    final int price = widget.documentSnapshot['price'] * _countRoom;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text(
          "Xác nhận đơn hàng",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Container(
                        //   height: MediaQuery.of(context).size.width * 0.4,
                        //   width: MediaQuery.of(context).size.width,
                        //   decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(20),
                        //       image: DecorationImage(
                        //         image: NetworkImage(
                        //             widget.documentSnapshotHotel['imageUrl']),
                        //         fit: BoxFit.cover,
                        //       )),
                        // ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        Container(
                          alignment: Alignment.topLeft,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  widget.documentSnapshotHotel['nameHotel'],
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Vollkorn',
                                  ),
                                ),
                                Text(
                                  widget.documentSnapshot['nameRoom'],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  'Địa chỉ: ' +
                                      widget.documentSnapshotHotel['address'],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                color: Colors.grey.shade400,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 1),
                                      child: Text(
                                        'Nhận: ' +
                                            widget.documentSnapshotHotel[
                                                'checkIn'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Icon(
                                      FontAwesomeIcons.hourglassStart,
                                      color: Colors.blueGrey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                color: Colors.grey.shade400,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 1),
                                      child: Text(
                                        'Trả: ' +
                                            widget.documentSnapshotHotel[
                                                'checkOut'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    const Icon(
                                      FontAwesomeIcons.hourglassEnd,
                                      color: Colors.blueGrey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'Chọn ngày: ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                DateTime? startDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2024),
                                );
                                setState(() {
                                  _startDate = startDate;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade400,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 1),
                                      child: Text(
                                        '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    const Icon(
                                      FontAwesomeIcons.calendarDays,
                                      color: Colors.blueGrey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Icon(FontAwesomeIcons.rightLong),
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
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade400,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 1),
                                      child: Text(
                                        '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    const Icon(
                                      FontAwesomeIcons.calendarDays,
                                      color: Colors.blueGrey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Số lượng phòng: ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
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
                                      child: const Icon(Icons.remove),
                                      backgroundColor: Colors.black38,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    '$_countRoom',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  CircleAvatar(
                                    radius: 17,
                                    child: FloatingActionButton(
                                      onPressed: _incrementCount,
                                      child: const Icon(Icons.add),
                                      backgroundColor: Colors.black38,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Giá phòng: ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              CurrencyFormatter.convertPrice(
                                  price: widget.documentSnapshot['price']),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tổng giá tiền: ',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              CurrencyFormatter.convertPrice(price: price),
                              style: const TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              try {
                setState(() {
                  _loading = true;
                  EasyLoading.show(status: 'Đang xử lý');
                });
                await sendEmailOrderHotel();
                await booking_Hotel();
                setState(() {
                  _loading = false;
                });
              } catch (e) {
                EasyLoading.showError(e.toString());
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.08,
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'ĐẶT PHÒNG',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
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
