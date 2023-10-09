import 'dart:convert';

import 'package:app_booking/component/currency_formatter.dart';
import 'package:app_booking/layout/tabbar_screen.dart';
import 'package:app_booking/screens/order_hotel_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class BookTicketScreen extends StatefulWidget {
  final DocumentSnapshot documentSnapshotTicket;
  final DocumentSnapshot? documentSnapshot;
  final String idTicket;
  final String idCity;
  BookTicketScreen(
      {Key? key,
      this.documentSnapshot,
      required this.idTicket,
      required this.idCity,
      required this.documentSnapshotTicket})
      : super(key: key);

  @override
  State<BookTicketScreen> createState() => _BookTicketScreenState();
}

late User loggedInUser;

class _BookTicketScreenState extends State<BookTicketScreen> {
  final _auth = FirebaseAuth.instance;
  final _booking = FirebaseFirestore.instance;
  DateTime? chooseDate = DateTime.now();
  bool _loading = false;
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
  int _countTicket = 1;
  int _diference = 0;
  void _incrementCount() {
    setState(() {
      _countTicket++;
    });
  }

  void _decrementCount() {
    if (_countTicket <= 1) {
      return;
    }
    setState(() {
      _countTicket--;
    });
  }

  bool isCancel = false;
  Future bookTicket() async {
    await _booking.collection('bookTicket').add({
      "imageUrl": widget.documentSnapshotTicket['imageUrl'],
      "nameTicket": widget.documentSnapshotTicket['nameTicket'],
      "nameCity": widget.documentSnapshot!['nameCity'],
      "quantity": _countTicket,
      "chooseDate": chooseDate,
      "priceTicket": widget.documentSnapshot!['price'],
      "price": widget.documentSnapshot!['price'] * _countTicket,
      "emailUser": loggedInUser.email,
      "DateTimebooking": DateTime.now(),
      "isCancel": isCancel
    });
    EasyLoading.showSuccess(
      'Đặt vé thàng công!',
      duration: const Duration(milliseconds: 1300),
      maskType: EasyLoadingMaskType.black,
    );
    await Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        builder: (context) => const TabBarScreen(), maintainState: true));
  }

  Future sendEmailOrderTicket() async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    const serviceId = "service_mjlbj5v";
    const templateId = "template_wriwruq";
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
            "ticket_name": widget.documentSnapshotTicket['nameTicket'],
            "quantity": _countTicket,
            "date_use":
                '${chooseDate!.day}/${chooseDate!.month}/${chooseDate!.year}'
                    .toString(),
            "price_ticket": CurrencyFormatter.convertPrice(
                price: widget.documentSnapshotTicket['price']),
            "total": CurrencyFormatter.convertPrice(
                price: widget.documentSnapshot!['price'] * _countTicket),
            "to_email": loggedInUser.email,
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
    int price = widget.documentSnapshot!['price'] * _countTicket;
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
                                  image: NetworkImage(widget
                                      .documentSnapshotTicket['imageUrl']),
                                  fit: BoxFit.cover,
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  widget.documentSnapshotTicket['nameTicket'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Vollkorn',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Chọn ngày: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          GestureDetector(
                            onTap: () async {
                              DateTime? startDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2023),
                                lastDate: DateTime(2030),
                              );
                              setState(() {
                                chooseDate = startDate;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              width: MediaQuery.of(context).size.width * 0.4,
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
                                      '${chooseDate!.day}/${chooseDate!.month}/${chooseDate!.year}',
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
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Chọn số lượng vé: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
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
                                      radius: 15,
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
                                      '$_countTicket',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    CircleAvatar(
                                      radius: 15,
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
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Giá vé: ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                CurrencyFormatter.convertPrice(
                                    price:
                                        widget.documentSnapshotTicket['price']),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tổng giá tiền: ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                CurrencyFormatter.convertPrice(
                                    price: widget.documentSnapshot!['price'] *
                                        _countTicket),
                                style: const TextStyle(
                                  fontSize: 20,
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
            onTap: () async {
              try {
                setState(() {
                  _loading = true;
                  EasyLoading.show(status: 'Đang xử lý');
                });
                await sendEmailOrderTicket();
                await bookTicket();
                setState(() {
                  _loading = false;
                });
              } catch (e) {
                EasyLoading.showError(e.toString());
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.07,
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'ĐẶT VÉ',
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
