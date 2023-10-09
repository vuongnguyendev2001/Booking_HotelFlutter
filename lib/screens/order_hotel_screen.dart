import 'package:app_booking/component/currency_formatter.dart';
import 'package:app_booking/layout/layout_screen.dart';
import 'package:app_booking/screens/detail_order_hotel.dart';
import 'package:app_booking/screens/detail_order_ticket/detail_order_ticket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class OrderHotelScreen extends StatefulWidget {
  const OrderHotelScreen({Key? key}) : super(key: key);
  static const String id = 'myorder_Screen';
  @override
  State<OrderHotelScreen> createState() => _OrderHotelScreenState();
}

late User loggedInUser;

class _OrderHotelScreenState extends State<OrderHotelScreen> {
  final _auth = FirebaseAuth.instance;
  final _booking = FirebaseFirestore.instance;

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

  String formattedDate(timeStamp) {
    var dateFormTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd/MM/yyyy').format(dateFormTimeStamp);
  }

  String formattedDatebook(timeStamp) {
    var dateFormTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd/MM/yyyy hh:mm a').format(dateFormTimeStamp);
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = loggedInUser.email;
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: StreamBuilder(
        stream: _booking
            .collection('booking')
            .orderBy('DateTimebooking', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> document) {
          if (!document.hasData)
            return const Center(
              child: Text('erorr'),
            );
          return ListView.builder(
            itemCount: document.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  document.data!.docs[index];
              // final int price = NumberFormat.simpleCurrency(
              // locale: 'vi-VN', decimalDigits: 0)
              //     .format(documentSnapshot['price']);
              print(loggedInUser.email);
              var room = documentSnapshot['room'].toString();
              if (documentSnapshot['emailUser'] == loggedInUser.email ||
                  loggedInUser.email == 'admin@email.com') {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailOrderHotelScreen(
                          detailOrderHotel: documentSnapshot,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 10, right: 20, left: 20, top: 10),
                    child: Column(
                      children: [
                        // ClipRRect(
                        //   borderRadius: const BorderRadius.only(
                        //       topRight: Radius.circular(15),
                        //       topLeft: Radius.circular(15)),
                        //   child: Container(
                        //     width: MediaQuery.of(context).size.width,
                        //     height: MediaQuery.of(context).size.height * 0.2,
                        //     decoration: BoxDecoration(
                        //       image: DecorationImage(
                        //         image: NetworkImage(documentSnapshot['imageUrl']),
                        //         fit: BoxFit.cover,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.grey.shade400,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  documentSnapshot['isCancel'] == false
                                      ? const SizedBox.shrink()
                                      : Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: const Text(
                                            'Đơn đã bị hủy',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      const Icon(
                                        FontAwesomeIcons.hotel,
                                        size: 20,
                                      ),
                                      Text(
                                        '  ' + documentSnapshot['nameHotel'],
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Vollkorn',
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Text(
                                  //   documentSnapshot['nameRoom'],
                                  //   style: const TextStyle(
                                  //     fontSize: 22.5,
                                  //     fontWeight: FontWeight.w400,
                                  //     fontFamily: 'Vollkorn',
                                  //   ),
                                  // ),
                                  Row(
                                    children: [
                                      const Icon(
                                        FontAwesomeIcons.solidCalendarDays,
                                        size: 18,
                                      ),
                                      Text(
                                        ' : ' +
                                            formattedDate(
                                                documentSnapshot['startDate']),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Icon(FontAwesomeIcons.rightLong),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        formattedDate(
                                            documentSnapshot['endDate']),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  // Text(
                                  //   'Số lượng phòng: ' + room,
                                  //   style: const TextStyle(
                                  //     fontSize: 18,
                                  //     fontWeight: FontWeight.w500,
                                  //   ),
                                  // ),
                                  // const SizedBox(
                                  //   height: 3,
                                  // ),
                                  // Text(
                                  //   ' Địa chỉ: ' +
                                  //       documentSnapshot['addressHotel'],
                                  //   style: const TextStyle(
                                  //     fontSize: 18,
                                  //     fontWeight: FontWeight.w500,
                                  //   ),
                                  //   maxLines: 1,
                                  // ),
                                  // const SizedBox(
                                  //   height: 3,
                                  // ),
                                  // Row(
                                  //   children: [
                                  //     const Icon(
                                  //       FontAwesomeIcons.calendarDays,
                                  //       size: 18,
                                  //     ),
                                  //     Text(
                                  //       ' Ngày đặt : ' +
                                  //           formattedDatebook(
                                  //             documentSnapshot['DateTimebooking'],
                                  //           ),
                                  //       style: const TextStyle(
                                  //         fontSize: 18,
                                  //         fontWeight: FontWeight.w500,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  // const SizedBox(
                                  //   height: 3,
                                  // ),
                                  currentUser == 'admin@email.com'
                                      ? SizedBox(
                                          width: screenSize.width * 0.8,
                                          child: Row(
                                            children: [
                                              const Icon(
                                                FontAwesomeIcons.userTie,
                                                size: 18,
                                              ),
                                              Text(
                                                documentSnapshot['emailUser'],
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(
                                          height: 5,
                                        ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Text(
                                        '  Tổng tiền: ',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        CurrencyFormatter.convertPrice(
                                            price: documentSnapshot['price']),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          );
        },
      ),
    );
  }
}
