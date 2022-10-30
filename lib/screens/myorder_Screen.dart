import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../screens/navbar.dart';

class myorder_Screen extends StatefulWidget {
  const myorder_Screen({Key? key}) : super(key: key);
  static const String id = 'myorder_Screen';
  @override
  State<myorder_Screen> createState() => _myorder_ScreenState();
}

late User loggedInUser;

class _myorder_ScreenState extends State<myorder_Screen> {
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
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey.shade200,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                color: Colors.black45,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NavbarScreen()));
                  },
                  icon: Icon(FontAwesomeIcons.arrowLeft),
                ),
              ),
            ),
            SizedBox(
              width: 60,
            ),
            Text(
              'PHÒNG ĐÃ ĐẶT',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: _booking
            .collection('booking')
            .orderBy('DateTimebooking', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> document) {
          if (!document.hasData)
            return Center(
              child: Text('erorr'),
            );
          return ListView.builder(
            itemCount: document.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  document.data!.docs[index];
              var price = int.parse(documentSnapshot['price']);
              print(loggedInUser.email);
              var room = documentSnapshot['room'].toString();
              if (documentSnapshot['emailUser'] == loggedInUser.email ||
                  loggedInUser.email == 'admin@email.com') {
                return Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10, right: 20, left: 20, top: 10),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15)),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(documentSnapshot['imageUrl']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.3,
                          color: Colors.grey.shade400,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  documentSnapshot['nameHotel'],
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Vollkorn',
                                  ),
                                ),
                                Text(
                                  documentSnapshot['nameRoom'],
                                  style: TextStyle(
                                    fontSize: 22.5,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Vollkorn',
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      formattedDate(
                                          documentSnapshot['startDate']),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(FontAwesomeIcons.rightLong),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      formattedDate(
                                          documentSnapshot['endDate']),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  'Số lượng phòng: ' + room,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Địa chỉ: ' +
                                      documentSnapshot['addressHotel'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Ngày đặt: ' +
                                          formattedDatebook(
                                            documentSnapshot['DateTimebooking'],
                                          ),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Người đặt: ' + documentSnapshot['emailUser'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Tổng tiền: ',
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'đ' '$price',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
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
                );
              }
              return SizedBox();
            },
          );
        },
      ),
    );
  }
}
