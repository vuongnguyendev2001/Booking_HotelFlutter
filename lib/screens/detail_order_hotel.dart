import 'package:app_booking/component/currency_formatter.dart';
import 'package:app_booking/layout/tabbar_screen.dart';
import 'package:app_booking/screens/order_hotel_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class DetailOrderHotelScreen extends StatefulWidget {
  final DocumentSnapshot? detailOrderHotel;
  const DetailOrderHotelScreen({
    Key? key,
    this.detailOrderHotel,
  }) : super(key: key);

  @override
  State<DetailOrderHotelScreen> createState() => _DetailOrderHotelScreenState();
}

late User loggedInUser;

class _DetailOrderHotelScreenState extends State<DetailOrderHotelScreen> {
  final _auth = FirebaseAuth.instance;
  final _booking = FirebaseFirestore.instance;
  DateTime? chooseDate = DateTime.now();
  // DateTime? _endDate = DateTime.now();
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
                    .collection('booking')
                    .doc(widget.detailOrderHotel!.id)
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
    final screenSize = MediaQuery.of(context).size;
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width * 0.5,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: NetworkImage(
                                    widget.detailOrderHotel!['imageUrl']),
                                fit: BoxFit.cover,
                              )),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Text(
                          widget.detailOrderHotel!['nameHotel'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Vollkorn',
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.bed_rounded),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Loại phòng : ',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    widget.detailOrderHotel!['nameRoom'],
                                    style: const TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(FontAwesomeIcons.locationDot, size: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Địa chỉ chổ nghĩ : ',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 3),
                                  SizedBox(
                                    width: screenSize.width * 0.8,
                                    child: Text(
                                      widget.detailOrderHotel!['addressHotel'],
                                      style: const TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              FontAwesomeIcons.solidCalendarDays,
                              size: 18,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        CurrencyFormatter.formattedDate(widget
                                            .detailOrderHotel!['startDate']),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Icon(
                                        FontAwesomeIcons.rightLong,
                                        color: Colors.black,
                                        size: 18,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        CurrencyFormatter.formattedDate(widget
                                            .detailOrderHotel!['endDate']),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Nhận phòng: từ 14:00',
                                    style: const TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    'Trả phòng: từ 12:00',
                                    style: const TextStyle(
                                      fontSize: 17,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.numbers_sharp),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Số lượng phòng : ',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    widget.detailOrderHotel!['room']
                                            .toString() +
                                        ' phòng',
                                    style: const TextStyle(
                                      fontSize: 17,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              FontAwesomeIcons.solidCalendarDays,
                              size: 18,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Ngày giờ đặt : ',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    CurrencyFormatter.formattedDatebook(widget
                                        .detailOrderHotel!['DateTimebooking']),
                                    style: const TextStyle(
                                      fontSize: 17,
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
                        _user.email == 'admin@email.com'
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.user,
                                    size: 18,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Người đặt : ',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          widget.detailOrderHotel!['emailUser'],
                                          style: const TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(
                                height: 5,
                              ),
                        const SizedBox(height: 5),
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
                                  price: widget.detailOrderHotel!['price']),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                        widget.detailOrderHotel!['isCancel'] == false
                            ? InkWell(
                                onTap: () {
                                  showCancelOrder();
                                },
                                child: Padding(
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
                                        borderRadius: BorderRadius.circular(4)),
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
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
