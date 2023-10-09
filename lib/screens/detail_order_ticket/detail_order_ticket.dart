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

class DetailOrderTicketScreen extends StatefulWidget {
  final DocumentSnapshot? detailOrderTicket;
  const DetailOrderTicketScreen({
    Key? key,
    this.detailOrderTicket,
  }) : super(key: key);

  @override
  State<DetailOrderTicketScreen> createState() =>
      _DetailOrderTicketScreenState();
}

late User loggedInUser;

class _DetailOrderTicketScreenState extends State<DetailOrderTicketScreen> {
  final _auth = FirebaseAuth.instance;
  void initState() {
    super.initState();
    getCurrentUser();
  }

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

  // Future sendEmailCancelOrderTicket() async {
  //   final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  //   const serviceId = "service_mjlbj5v";
  //   const templateId = "template_wriwruq";
  //   const userId = "CWHenK88Ngphy24tC";
  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode(
  //       {
  //         "service_id": serviceId,
  //         "template_id": templateId,
  //         "user_id": userId,
  //         "template_params": {
  //           "user_name": loggedInUser.displayName,
  //           "ticket_name": widget.detailOrderTicket!['nameTicket'],
  //           "quantity": widget.detailOrderTicket!['quantity'],
  //           "date_use": CurrencyFormatter.formattedDate(
  //               widget.detailOrderTicket!['chooseDate']),
  //           "price_ticket": CurrencyFormatter.convertPrice(
  //               price: widget.detailOrderTicket!['priceTicket']),
  //           "total": CurrencyFormatter.convertPrice(
  //               price: widget.detailOrderTicket!['price']),
  //           "to_email": loggedInUser.email,
  //         }
  //       },
  //     ),
  //   );
  //   return response.statusCode;
  // }

  bool isCancel = true;
  bool _isLoading = false;
  Future showCancelOrder() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Hủy đơn'),
        content: const Text('Bạn có chắc chắn hủy đơn ?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Quay lại'),
          ),
          TextButton(
            onPressed: () async {
              try {
                setState(() {
                  _isLoading = true;
                  EasyLoading.show(status: 'Đang xử lý');
                });
                // await sendEmailCancelOrderTicket();
                await FirebaseFirestore.instance
                    .collection('bookTicket')
                    .doc(widget.detailOrderTicket!.id)
                    .update(
                  {
                    'isCancel': isCancel,
                  },
                );
                setState(() {
                  _isLoading = false;
                  EasyLoading.dismiss();
                });
                Navigator.pop(context);
                Navigator.pop(context);
                EasyLoading.showSuccess('Hủy đơn thành công');
              } catch (error) {
                print(error);
              }
            },
            child: const Text('Đồng ý'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _user = loggedInUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text(
          "Chi tiết đơn",
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
                                  image: NetworkImage(
                                      widget.detailOrderTicket!['imageUrl']),
                                  fit: BoxFit.cover,
                                )),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Center(
                            child: Text(
                              widget.detailOrderTicket!['nameTicket'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Vollkorn',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            'Địa chỉ : ' +
                                widget.detailOrderTicket!['nameCity'],
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Ngày sử dụng : ' +
                                CurrencyFormatter.formattedDate(
                                    widget.detailOrderTicket!['chooseDate']),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Số lượng vé: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                widget.detailOrderTicket!['quantity']
                                    .toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Ngày giờ đặt : ' +
                                CurrencyFormatter.formattedDatebook(widget
                                    .detailOrderTicket!['DateTimebooking']),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          _user.email == 'admin@email.com'
                              ? Row(
                                  children: [
                                    const Icon(FontAwesomeIcons.userAstronaut),
                                    Text(
                                      ' ' +
                                          widget
                                              .detailOrderTicket!['emailUser'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tổng giá tiền thanh toán: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                CurrencyFormatter.convertPrice(
                                    price: widget.detailOrderTicket!['price']),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                          widget.detailOrderTicket!['isCancel'] == false
                              ? InkWell(
                                  onTap: () {
                                    showCancelOrder();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                          padding: const EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Text(
                                            'Hủy đơn',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.red,
                                            ),
                                          )),
                                    ),
                                  ))
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      padding: const EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: Text(
                                        'Đơn đã bị hủy',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
