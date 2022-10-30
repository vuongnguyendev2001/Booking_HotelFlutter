import 'package:app_booking/screens/addKindofRoom.dart';
import 'package:app_booking/screens/editKindofRoom.dart';
import 'package:app_booking/screens/myorder_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'booknow1.dart';

class booknow_Screen extends StatefulWidget {
  const booknow_Screen(
      {Key? key,
      required this.documentSnapshot,
      required this.idHotel,
      required this.idCity})
      : super(key: key);
  final DocumentSnapshot documentSnapshot;
  final String idHotel;
  final String idCity;
  @override
  State<booknow_Screen> createState() => _booknow_ScreenState();
}

late User loggedInUser;

class _booknow_ScreenState extends State<booknow_Screen> {
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
                                    '${koroom['price']}',
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Container(
                                      //   width: MediaQuery.of(context)
                                      //           .size
                                      //           .width *
                                      //       0.4,
                                      //   height: MediaQuery.of(context)
                                      //           .size
                                      //           .width *
                                      //       0.1,
                                      //   decoration: BoxDecoration(
                                      //     color: Colors.grey.shade400,
                                      //     borderRadius:
                                      //         BorderRadius.circular(10),
                                      //   ),
                                      //   // child: Row(
                                      //   //   mainAxisAlignment:
                                      //   //       MainAxisAlignment.center,
                                      //   //   children: [
                                      //   //     CircleAvatar(
                                      //   //       radius: 17,
                                      //   //       child: FloatingActionButton(
                                      //   //         onPressed: _decrementCount,
                                      //   //         child: Icon(Icons.remove),
                                      //   //         backgroundColor:
                                      //   //             Colors.black38,
                                      //   //       ),
                                      //   //     ),
                                      //   //     SizedBox(
                                      //   //       width: 15,
                                      //   //     ),
                                      //   //     Text(
                                      //   //       '$_countRoom',
                                      //   //       style: TextStyle(
                                      //   //         color: Colors.black,
                                      //   //         fontSize: 22,
                                      //   //       ),
                                      //   //     ),
                                      //   //     SizedBox(
                                      //   //       width: 15,
                                      //   //     ),
                                      //   //     CircleAvatar(
                                      //   //       radius: 17,
                                      //   //       child: FloatingActionButton(
                                      //   //         onPressed: _incrementCount,
                                      //   //         child: Icon(Icons.add),
                                      //   //         backgroundColor:
                                      //   //             Colors.black38,
                                      //   //       ),
                                      //   //     ),
                                      //   //   ],
                                      //   // ),
                                      // ),
                                      // Container(
                                      //   alignment: Alignment.center,
                                      //   width:
                                      //       MediaQuery.of(context).size.width *
                                      //           0.4,
                                      //   height:
                                      //       MediaQuery.of(context).size.width *
                                      //           0.1,
                                      //   decoration: BoxDecoration(
                                      //       color: Colors.grey.shade400,
                                      //       borderRadius:
                                      //           BorderRadius.circular(10)),
                                      //   child: DropdownButton(
                                      //     borderRadius:
                                      //         BorderRadius.circular(10),
                                      //     icon:
                                      //         Icon(FontAwesomeIcons.caretDown),
                                      //     hint: Text(
                                      //       "CHỌN",
                                      //       style:
                                      //           TextStyle(color: Colors.black),
                                      //     ),
                                      //     value: myInitialItem,
                                      //     onChanged: (value) {
                                      //       myInitialItem = value as int?;
                                      //       setState(() {
                                      //         print(myInitialItem);
                                      //       });
                                      //     },
                                      //     items: numberroom.map((room) {
                                      //       return DropdownMenuItem(
                                      //           value: room,
                                      //           child: Text('$room'));
                                      //     }).toList(),
                                      //   ),
                                      //
                                      //   // Row(
                                      //   //   mainAxisAlignment: MainAxisAlignment.center,
                                      //   //   children: [
                                      //   //     CircleAvatar(
                                      //   //       radius: 17,
                                      //   //       child: FloatingActionButton(
                                      //   //         onPressed: () {
                                      //   //           if (_countRoom < 1 ||
                                      //   //               koroom['idroom'] != koroom.id) {
                                      //   //             return;
                                      //   //           }
                                      //   //           setState(() {
                                      //   //             _countRoom--;
                                      //   //           });
                                      //   //         },
                                      //   //         child: const Icon(Icons.remove),
                                      //   //         backgroundColor: Colors.black38,
                                      //   //       ),
                                      //   //     ),
                                      //   //     SizedBox(
                                      //   //       width: 20,
                                      //   //     ),
                                      //   //     Text(
                                      //   //       koroom['idroom'] == koroom.id
                                      //   //           ? '$_countRoom'
                                      //   //           : '0',
                                      //   //       style: TextStyle(
                                      //   //         color: Colors.black,
                                      //   //         fontSize: 22,
                                      //   //       ),
                                      //   //     ),
                                      //   //     SizedBox(
                                      //   //       width: 20,
                                      //   //     ),
                                      //   //     CircleAvatar(
                                      //   //       radius: 17,
                                      //   //       child: FloatingActionButton(
                                      //   //         onPressed: () {
                                      //   //           if (koroom.id != koroom['idroom']) {
                                      //   //             print(_countRoom);
                                      //   //           }
                                      //   //           setState(() {
                                      //   //             _countRoom++;
                                      //   //             print(_countRoom);
                                      //   //           });
                                      //   //         },
                                      //   //         child: const Icon(Icons.add),
                                      //   //         backgroundColor: Colors.black38,
                                      //   //       ),
                                      //   //     ),
                                      //   //   ],
                                      //   // ),
                                      // ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        alignment: Alignment.center,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade400,
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                                        Booknow1_Screen(
                                                          documentSnapshotHotel:
                                                              widget
                                                                  .documentSnapshot,
                                                          documentSnapshot:
                                                              koroom,
                                                          idHotel:
                                                              widget.idHotel,
                                                          idCity: widget.idCity,
                                                          idRoom: koroom.id,
                                                        )));
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ]);
                    });
              }),
          // GestureDetector(
          //   onTap: booking_Hotel,
          //   child: Container(
          //     width: MediaQuery.of(context).size.width,
          //     height: MediaQuery.of(context).size.height * 0.075,
          //     decoration: const BoxDecoration(
          //       color: Colors.blueGrey,
          //     ),
          //     child: Padding(
          //       padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceAround,
          //         children: [
          //           Text(
          //             'VND ',
          //             style: TextStyle(
          //               fontSize: 25,
          //               fontWeight: FontWeight.w500,
          //             ),
          //           ),
          //           Text(
          //             'ĐẶT PHÒNG',
          //             style: TextStyle(
          //               color: Colors.black,
          //               fontWeight: FontWeight.bold,
          //               fontSize: 25,
          //               fontFamily: 'Vollkorn',
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
      // body: Stack(
      //   alignment: Alignment.bottomCenter,
      //   fit: StackFit.loose,
      //   children: [
      //     // ListView(
      //     //   children: [
      //     //     Column(
      //     //       children: [
      //     //         Padding(
      //     //           padding: const EdgeInsets.all(20),
      //     //           child: Container(
      //     //             child: Column(
      //     //               crossAxisAlignment: CrossAxisAlignment.start,
      //     //               children: [
      //     //                 Container(
      //     //                   height: MediaQuery.of(context).size.width * 0.55,
      //     //                   width: MediaQuery.of(context).size.width,
      //     //                   decoration: BoxDecoration(
      //     //                       borderRadius: BorderRadius.circular(20),
      //     //                       image: DecorationImage(
      //     //                         image: NetworkImage(
      //     //                             widget.documentSnapshot['imageUrl']),
      //     //                         fit: BoxFit.cover,
      //     //                       )),
      //     //                 ),
      //     //                 SizedBox(
      //     //                   height: 10,
      //     //                 ),
      //     //                 Container(
      //     //                   height: MediaQuery.of(context).size.width * 0.2,
      //     //                   width: MediaQuery.of(context).size.width,
      //     //                   decoration: BoxDecoration(
      //     //                     color: Colors.grey.shade400,
      //     //                     borderRadius: BorderRadius.circular(15),
      //     //                   ),
      //     //                   child: Column(
      //     //                     crossAxisAlignment: CrossAxisAlignment.center,
      //     //                     mainAxisAlignment: MainAxisAlignment.center,
      //     //                     children: [
      //     //                       Center(
      //     //                         child: Text(
      //     //                           widget.documentSnapshot['nameHotel'],
      //     //                           style: TextStyle(
      //     //                             fontSize: 25,
      //     //                             fontWeight: FontWeight.w600,
      //     //                             fontFamily: 'Vollkorn',
      //     //                           ),
      //     //                         ),
      //     //                       ),
      //     //                       Padding(
      //     //                         padding: const EdgeInsets.only(
      //     //                             left: 20, right: 20),
      //     //                         child: Text(
      //     //                           widget.documentSnapshot['address'],
      //     //                           style: TextStyle(
      //     //                             fontSize: 20,
      //     //                           ),
      //     //                         ),
      //     //                       ),
      //     //                     ],
      //     //                   ),
      //     //                 ),
      //     //                 SizedBox(
      //     //                   height: 10,
      //     //                 ),
      //     //                 Row(
      //     //                   children: [
      //     //                     ClipRRect(
      //     //                       borderRadius: BorderRadius.circular(10),
      //     //                       child: Container(
      //     //                         width:
      //     //                             MediaQuery.of(context).size.width * 0.4,
      //     //                         height:
      //     //                             MediaQuery.of(context).size.width * 0.12,
      //     //                         color: Colors.grey.shade400,
      //     //                         child: Row(
      //     //                           mainAxisAlignment: MainAxisAlignment.center,
      //     //                           crossAxisAlignment:
      //     //                               CrossAxisAlignment.center,
      //     //                           children: [
      //     //                             Padding(
      //     //                               padding: const EdgeInsets.only(left: 1),
      //     //                               child: Text(
      //     //                                 'Nhận: ' +
      //     //                                     widget
      //     //                                         .documentSnapshot['checkIn'],
      //     //                                 style: TextStyle(
      //     //                                   fontSize: 20,
      //     //                                 ),
      //     //                               ),
      //     //                             ),
      //     //                             SizedBox(
      //     //                               width: 15,
      //     //                             ),
      //     //                             Icon(
      //     //                               FontAwesomeIcons.hourglassStart,
      //     //                               color: Colors.blueGrey,
      //     //                             ),
      //     //                           ],
      //     //                         ),
      //     //                       ),
      //     //                     ),
      //     //                     SizedBox(
      //     //                       width: 40,
      //     //                     ),
      //     //                     ClipRRect(
      //     //                       borderRadius: BorderRadius.circular(10),
      //     //                       child: Container(
      //     //                         width:
      //     //                             MediaQuery.of(context).size.width * 0.4,
      //     //                         height:
      //     //                             MediaQuery.of(context).size.width * 0.12,
      //     //                         color: Colors.grey.shade400,
      //     //                         child: Row(
      //     //                           mainAxisAlignment: MainAxisAlignment.center,
      //     //                           crossAxisAlignment:
      //     //                               CrossAxisAlignment.center,
      //     //                           children: [
      //     //                             Padding(
      //     //                               padding: const EdgeInsets.only(left: 1),
      //     //                               child: Text(
      //     //                                 'Trả: ' +
      //     //                                     widget
      //     //                                         .documentSnapshot['checkOut'],
      //     //                                 style: TextStyle(
      //     //                                   fontSize: 20,
      //     //                                 ),
      //     //                               ),
      //     //                             ),
      //     //                             SizedBox(
      //     //                               width: 15,
      //     //                             ),
      //     //                             Icon(
      //     //                               FontAwesomeIcons.hourglassEnd,
      //     //                               color: Colors.blueGrey,
      //     //                             ),
      //     //                           ],
      //     //                         ),
      //     //                       ),
      //     //                     ),
      //     //                   ],
      //     //                 ),
      //     //                 SizedBox(
      //     //                   height: 5,
      //     //                 ),
      //     //                 Text(
      //     //                   'Chọn ngày: ',
      //     //                   style: TextStyle(
      //     //                     fontSize: 20,
      //     //                     fontWeight: FontWeight.w500,
      //     //                   ),
      //     //                 ),
      //     //                 SizedBox(
      //     //                   height: 7,
      //     //                 ),
      //     //                 Row(
      //     //                   children: [
      //     //                     GestureDetector(
      //     //                       onTap: () async {
      //     //                         DateTime? startDate = await showDatePicker(
      //     //                           context: context,
      //     //                           initialDate: DateTime.now(),
      //     //                           firstDate: DateTime(2020),
      //     //                           lastDate: DateTime(2023),
      //     //                         );
      //     //                         setState(() {
      //     //                           _startDate = startDate;
      //     //                           print(_startDate);
      //     //                         });
      //     //                       },
      //     //                       child: Container(
      //     //                         width:
      //     //                             MediaQuery.of(context).size.width * 0.4,
      //     //                         height:
      //     //                             MediaQuery.of(context).size.width * 0.12,
      //     //                         decoration: BoxDecoration(
      //     //                           borderRadius: BorderRadius.circular(10),
      //     //                           color: Colors.grey.shade400,
      //     //                         ),
      //     //                         child: Row(
      //     //                           mainAxisAlignment: MainAxisAlignment.center,
      //     //                           crossAxisAlignment:
      //     //                               CrossAxisAlignment.center,
      //     //                           children: [
      //     //                             Padding(
      //     //                               padding: const EdgeInsets.only(left: 1),
      //     //                               child: Text(
      //     //                                 '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
      //     //                                 style: TextStyle(
      //     //                                   fontSize: 20,
      //     //                                 ),
      //     //                               ),
      //     //                             ),
      //     //                             SizedBox(
      //     //                               width: 15,
      //     //                             ),
      //     //                             Icon(
      //     //                               FontAwesomeIcons.calendarDays,
      //     //                               color: Colors.blueGrey,
      //     //                             ),
      //     //                           ],
      //     //                         ),
      //     //                       ),
      //     //                     ),
      //     //                     SizedBox(
      //     //                       width: 9,
      //     //                     ),
      //     //                     Icon(FontAwesomeIcons.rightLong),
      //     //                     SizedBox(
      //     //                       width: 9,
      //     //                     ),
      //     //                     GestureDetector(
      //     //                       onTap: () async {
      //     //                         DateTime? endDate = await showDatePicker(
      //     //                           context: context,
      //     //                           initialDate: DateTime.now(),
      //     //                           firstDate: DateTime(2020),
      //     //                           lastDate: DateTime(2030),
      //     //                         );
      //     //                         setState(() {
      //     //                           _endDate = endDate;
      //     //                           print(_endDate);
      //     //                         });
      //     //                       },
      //     //                       child: Container(
      //     //                         width:
      //     //                             MediaQuery.of(context).size.width * 0.4,
      //     //                         height:
      //     //                             MediaQuery.of(context).size.width * 0.12,
      //     //                         decoration: BoxDecoration(
      //     //                           borderRadius: BorderRadius.circular(10),
      //     //                           color: Colors.grey.shade400,
      //     //                         ),
      //     //                         child: Row(
      //     //                           mainAxisAlignment: MainAxisAlignment.center,
      //     //                           crossAxisAlignment:
      //     //                               CrossAxisAlignment.center,
      //     //                           children: [
      //     //                             Padding(
      //     //                               padding: const EdgeInsets.only(left: 1),
      //     //                               child: Text(
      //     //                                 '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
      //     //                                 style: TextStyle(
      //     //                                   fontSize: 20,
      //     //                                 ),
      //     //                               ),
      //     //                             ),
      //     //                             SizedBox(
      //     //                               width: 15,
      //     //                             ),
      //     //                             Icon(
      //     //                               FontAwesomeIcons.calendarDays,
      //     //                               color: Colors.blueGrey,
      //     //                             ),
      //     //                           ],
      //     //                         ),
      //     //                       ),
      //     //                     ),
      //     //                   ],
      //     //                 ),
      //     //                 SizedBox(
      //     //                   height: 5,
      //     //                 ),
      //     //                 Row(
      //     //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     //                   crossAxisAlignment: CrossAxisAlignment.start,
      //     //                   children: [
      //     //                     Text(
      //     //                       'Số lượng phòng: ',
      //     //                       style: TextStyle(
      //     //                         fontSize: 20,
      //     //                         fontWeight: FontWeight.w500,
      //     //                       ),
      //     //                     ),
      //     //                     Padding(
      //     //                       padding: const EdgeInsets.only(right: 10),
      //     //                       child: Text(
      //     //                         'Số lượng giường:',
      //     //                         style: TextStyle(
      //     //                           fontSize: 20,
      //     //                           fontWeight: FontWeight.w500,
      //     //                         ),
      //     //                       ),
      //     //                     ),
      //     //                   ],
      //     //                 ),
      //     //                 SizedBox(
      //     //                   height: 5,
      //     //                 ),
      //     //                 Row(
      //     //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     //                   children: [
      //     //                     Container(
      //     //                       width: MediaQuery.of(context).size.width * 0.4,
      //     //                       height: MediaQuery.of(context).size.width * 0.1,
      //     //                       decoration: BoxDecoration(
      //     //                         color: Colors.grey.shade400,
      //     //                         borderRadius: BorderRadius.circular(10),
      //     //                       ),
      //     //                       child: Row(
      //     //                         mainAxisAlignment: MainAxisAlignment.center,
      //     //                         children: [
      //     //                           CircleAvatar(
      //     //                             radius: 17,
      //     //                             child: FloatingActionButton(
      //     //                               onPressed: _decrementCount,
      //     //                               child: Icon(Icons.remove),
      //     //                               backgroundColor: Colors.black38,
      //     //                             ),
      //     //                           ),
      //     //                           SizedBox(
      //     //                             width: 15,
      //     //                           ),
      //     //                           Text(
      //     //                             '$_countRoom',
      //     //                             style: TextStyle(
      //     //                               color: Colors.black,
      //     //                               fontSize: 22,
      //     //                             ),
      //     //                           ),
      //     //                           SizedBox(
      //     //                             width: 15,
      //     //                           ),
      //     //                           CircleAvatar(
      //     //                             radius: 17,
      //     //                             child: FloatingActionButton(
      //     //                               onPressed: _incrementCount,
      //     //                               child: Icon(Icons.add),
      //     //                               backgroundColor: Colors.black38,
      //     //                             ),
      //     //                           ),
      //     //                         ],
      //     //                       ),
      //     //                     ),
      //     //                     Container(
      //     //                       width: MediaQuery.of(context).size.width * 0.4,
      //     //                       height: MediaQuery.of(context).size.width * 0.1,
      //     //                       decoration: BoxDecoration(
      //     //                         color: Colors.grey.shade400,
      //     //                         borderRadius: BorderRadius.circular(10),
      //     //                       ),
      //     //                       // child: DropdownButton<String>(
      //     //                       //   value: value,
      //     //                       //   items: room.map(e).toList(),
      //     //                       //   onChanged: (value){
      //     //                       //     setState(() {
      //     //                       //
      //     //                       //     });
      //     //                       //   },
      //     //                       // ),
      //     //                       child: Container(
      //     //                         alignment: Alignment.center,
      //     //                         width:
      //     //                             MediaQuery.of(context).size.width * 0.4,
      //     //                         height:
      //     //                             MediaQuery.of(context).size.width * 0.1,
      //     //                         decoration: BoxDecoration(
      //     //                             color: Colors.grey.shade400,
      //     //                             borderRadius: BorderRadius.circular(10)),
      //     //                         child: DropdownButton<String>(
      //     //                             borderRadius: BorderRadius.circular(10),
      //     //                             icon: Icon(FontAwesomeIcons.caretDown),
      //     //                             value: selectedBed,
      //     //                             items: rooms
      //     //                                 .map((room) =>
      //     //                                     DropdownMenuItem<String>(
      //     //                                       value: room,
      //     //                                       child: Text(
      //     //                                         room + '  ',
      //     //                                         style:
      //     //                                             TextStyle(fontSize: 21),
      //     //                                       ),
      //     //                                     ))
      //     //                                 .toList(),
      //     //                             onChanged: (room) {
      //     //                               setState(() {
      //     //                                 selectedBed = room;
      //     //                               });
      //     //                             }),
      //     //                       ),
      //     //                     ),
      //     //                   ],
      //     //                 ),
      //     //                 // Container(
      //     //                 //   alignment: Alignment.center,
      //     //                 //   width: MediaQuery.of(context).size.width * 0.4,
      //     //                 //   height: MediaQuery.of(context).size.width * 0.1,
      //     //                 //   color: Colors.grey,
      //     //                 //   child: DropdownButton<String>(
      //     //                 //       value: selectedRoom,
      //     //                 //       items: rooms
      //     //                 //           .map((room) => DropdownMenuItem<String>(
      //     //                 //               value: room, child: Text(room)))
      //     //                 //           .toList(),
      //     //                 //       onChanged: (room) {
      //     //                 //         setState(() {
      //     //                 //           selectedRoom = room;
      //     //                 //         });
      //     //                 //       }),
      //     //                 // ),
      //     //                 SizedBox(
      //     //                   height: 15.0,
      //     //                 ),
      //     //                 Row(
      //     //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     //                   crossAxisAlignment: CrossAxisAlignment.start,
      //     //                   children: [
      //     //                     Text(
      //     //                       'Tổng giá tiền: ',
      //     //                       style: TextStyle(
      //     //                         fontSize: 25,
      //     //                         fontWeight: FontWeight.w500,
      //     //                       ),
      //     //                     ),
      //     //                     Text(
      //     //                       '\$' + widget.documentSnapshot['price'],
      //     //                       style: TextStyle(
      //     //                         fontSize: 25,
      //     //                         fontWeight: FontWeight.w500,
      //     //                       ),
      //     //                     ),
      //     //                   ],
      //     //                 ),
      //     //               ],
      //     //             ),
      //     //           ),
      //     //         ),
      //     //       ],
      //     //     ),
      //     //   ],
      //     // ),
      //     // GestureDetector(
      //     //   onTap: booking_Hotel,
      //     //   child: Container(
      //     //     width: MediaQuery.of(context).size.width,
      //     //     height: MediaQuery.of(context).size.height * 0.1,
      //     //     decoration: const BoxDecoration(
      //     //       color: Colors.blueGrey,
      //     //     ),
      //     //     child: Padding(
      //     //       padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
      //     //       child: Row(
      //     //         mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     //         children: [
      //     //           Text(
      //     //             'VND ' + widget.documentSnapshot['price'],
      //     //             style: TextStyle(
      //     //               fontSize: 25,
      //     //               fontWeight: FontWeight.w500,
      //     //             ),
      //     //           ),
      //     //           Text(
      //     //             'ĐẶT PHÒNG',
      //     //             style: TextStyle(
      //     //               color: Colors.black,
      //     //               fontWeight: FontWeight.bold,
      //     //               fontSize: 25,
      //     //               fontFamily: 'Vollkorn',
      //     //             ),
      //     //           ),
      //     //         ],
      //     //       ),
      //     //     ),
      //     //   ),
      //     // ),
      //   ],
      // ),
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
        builder: (context) => myorder_Screen(), maintainState: true));
    EasyLoading.showSuccess(
      'Đặt phòng thành công!',
      duration: Duration(milliseconds: 1300),
      maskType: EasyLoadingMaskType.black,
    );
  }
}
