import 'package:app_booking/screens/order_screen.dart';
import 'package:app_booking/services/room_management/addKindofRoom.dart';
import 'package:app_booking/services/room_management/editKindofRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'book_now_next_screen.dart';

class BookNowScreen extends StatefulWidget {
  const BookNowScreen(
      {Key? key,
      required this.documentSnapshot,
      required this.idHotel,
      required this.idCity})
      : super(key: key);
  final DocumentSnapshot documentSnapshot;
  final String idHotel;
  final String idCity;
  @override
  State<BookNowScreen> createState() => _BookNowScreenState();
}

late User loggedInUser;

class _BookNowScreenState extends State<BookNowScreen> {
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
  int _countRoom = 0;
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

  final String admin = 'admin@email.com';
  int selectedBed = 0;
  @override
  Widget build(BuildContext context) {
    String? selectedRole;
    List Role = ['Sinh viên', 'Giảng viên', 'Kĩ thuật viên'];
    var currentuser = loggedInUser.email;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                color: Colors.black45,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(FontAwesomeIcons.arrowLeft),
                ),
              ),
            ),
            Text(
              'ĐƠN ĐẶT PHÒNG',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                color: Colors.black45,
                child: currentuser == admin
                    ? IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => addKindofRoom(
                                      documentSnapshot: widget.documentSnapshot,
                                      idHotel: widget.idHotel,
                                      idCity: widget.idCity)));
                        },
                        icon: Icon(FontAwesomeIcons.plus),
                      )
                    : SizedBox(),
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('allCity')
                  .doc(widget.idCity)
                  .collection('allHotel')
                  .doc(widget.idHotel)
                  .collection('Kindofroom')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot koroom = snapshot.data!.docs[index];
                      // List rooms = koroom['countnumber'];
                      List rooms = ['1', '2', '3'];
                      String? selected;
                      print(rooms);
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: width,
                              height: width * 0.45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  image: DecorationImage(
                                      image: NetworkImage(koroom['imageRoom']),
                                      fit: BoxFit.cover)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  alignment: Alignment.topRight,
                                  width: width,
                                  height: height * 0.05,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      currentuser == admin
                                          ? GestureDetector(
                                              onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      editKindofRoom(
                                                          documentSnapshot:
                                                              koroom),
                                                ),
                                              ),
                                              child: Container(
                                                  height: width * 0.12,
                                                  width: width * 0.12,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade600,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Icon(
                                                    FontAwesomeIcons.edit,
                                                    color: Colors.white,
                                                  )),
                                            )
                                          : SizedBox(),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    koroom['nameRoom'],
                                    style: TextStyle(
                                        fontSize: 21,
                                        color: Colors.blueAccent.shade700,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.bed_rounded,
                                        size: 23,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        koroom['bedroom'],
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.maximize,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Cỡ phòng: ' + koroom['area'],
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.person,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Dành cho: ' + koroom['size'],
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    koroom['description'],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity,
                              height: width * 0.12,
                              color: Colors.blueGrey,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'VND '
                                    '${NumberFormat.simpleCurrency(locale: 'vi-VN', decimalDigits: 0).format(koroom['price'])}',
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    alignment: Alignment.center,
                                    height:
                                        MediaQuery.of(context).size.width * 0.1,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextButton(
                                      child: Text(
                                        "CHỌN PHÒNG",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 21),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BookNowNextScreen(
                                                      documentSnapshotHotel:
                                                          widget
                                                              .documentSnapshot,
                                                      documentSnapshot: koroom,
                                                      idHotel: widget.idHotel,
                                                      idCity: widget.idCity,
                                                      idRoom: koroom.id,
                                                    )));
                                      },
                                    ),
                                  ),
                                  //   ],
                                  // ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ]);
                    });
              }),
        ],
      ),
    );
  }

  void booking_Hotel() {
    _booking.collection('booking').add({
      "nameHotel": widget.documentSnapshot['nameHotel'],
      "addressHotel": widget.documentSnapshot['address'],
      "startDate": _startDate,
      "checkIn": widget.documentSnapshot['checkIn'],
      "checkOut": widget.documentSnapshot['checkOut'],
      "endDate": _endDate,
      "room": _countRoom,
      'bed': selectedBed,
      "price": widget.documentSnapshot['price'],
      "emailUser": loggedInUser.email,
      "DateTimebooking": DateTime.now(),
      "imageUrl": widget.documentSnapshot['imageUrl'],
    });
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        builder: (context) => OrderScreen(), maintainState: true));
    EasyLoading.showSuccess(
      'Đặt phòng thành công!',
      duration: Duration(milliseconds: 1300),
      maskType: EasyLoadingMaskType.black,
    );
  }
}
