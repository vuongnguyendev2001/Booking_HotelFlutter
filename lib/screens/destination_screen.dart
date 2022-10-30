import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'booknow_Screen.dart';

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
                        // GestureDetector(
                        //   onTap: (){
                        //     showDialog(context: context,
                        //       builder: (context) => AlertDialog(
                        //         contentPadding: EdgeInsets.only(top: 30, left: 20, bottom: 10, right: 20),
                        //         content: Text('Bạn muốn đặt tour cho $_count người?',style: TextStyle(
                        //           fontSize: 20,
                        //           fontWeight: FontWeight.w600,
                        //         ),),
                        //         actions: [
                        //           // FlatButton(onPressed: (){
                        //           //   Navigator.pop(context);
                        //           //   },
                        //           //     child: Text('HỦY', style: TextStyle(
                        //           //       fontSize: 16,
                        //           //     ),)),
                        //           // FlatButton(
                        //           //     onPressed: (){
                        //           //       Booktour();
                        //           //       Navigator.pop(context);
                        //           //     },
                        //           //     child: Text('ĐỒNG Ý', style: TextStyle(
                        //           //         fontSize: 16,
                        //           //     ),)),
                        //         ],
                        //       ),
                        //     );
                        //   },
                        //   child: Padding(
                        //     padding:  EdgeInsets.only(bottom: 30),
                        //     child: Container(
                        //       alignment: Alignment.center,
                        //       height: 35,
                        //       width: 150,
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(10),
                        //         color: Colors.white54,
                        //       ),
                        //       child: Text('ĐẶT TOUR', style: TextStyle(
                        //         fontSize: 22,
                        //         fontWeight: FontWeight.w900,
                        //       ),)
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  // Positioned(
                  //   right: 35,
                  //   bottom: 4,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text('SL:', style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 18
                  //       ),),
                  //       SizedBox(width: 10,),
                  //       CircleAvatar(
                  //         radius: 13,
                  //         child: FloatingActionButton(
                  //           onPressed: _decrementCount,
                  //           child: Icon(Icons.remove),
                  //           backgroundColor: Colors.black38,
                  //         ),
                  //       ),
                  //       SizedBox(width: 5,),
                  //       Text('$_count', style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 18
                  //       ),),
                  //       SizedBox(width: 5,),
                  //       CircleAvatar(
                  //         radius: 13,
                  //         child: FloatingActionButton(
                  //           onPressed: _incrementCount,
                  //             child: Icon(Icons.add),
                  //           backgroundColor: Colors.black38,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
              // Expanded(
              //   child: StreamBuilder(
              //     stream: _activities.collection('DaNang').snapshots(),
              //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
              //       if(!snapshot.hasData) return Text('error');
              //       return ListView.builder(
              //           padding: EdgeInsets.only(top: 10, bottom: 10),
              //           itemCount: snapshot.data!.docs.length,
              //           itemBuilder: (BuildContext context, int index) {
              //             DocumentSnapshot document = snapshot.data!.docs[index];
              //             return Stack(
              //               children: [
              //                 Container(
              //                   margin: EdgeInsets.fromLTRB(10, 5, 15, 5),
              //                   height: 170,
              //                   width: double.infinity,
              //                   decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(10),
              //                     color: Colors.white,
              //                   ),
              //                   child: Padding(
              //                     padding: const EdgeInsets.fromLTRB(130, 20, 20, 20),
              //                     child: Column(
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       crossAxisAlignment: CrossAxisAlignment.start,
              //                       children: [
              //                         Row(
              //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                           crossAxisAlignment: CrossAxisAlignment.start,
              //                           children: [
              //                             Container(
              //                               width: 120,
              //                               child: Text(document['name'], style: TextStyle(
              //                                 fontWeight: FontWeight.w600,
              //                                 fontSize: 18,
              //                               ),),
              //                             ),
              //                             Column(
              //                               children: [
              //                                 Text(
              //                                   document['price'], style: TextStyle(
              //                                   fontSize: 22.0,
              //                                   fontWeight: FontWeight.w600,
              //                                 ),),
              //                                 Text('1 khách', style: TextStyle(
              //                                     color: Colors.grey
              //                                 ),),
              //                               ],
              //                             ),
              //                           ],
              //                         ),
              //                         Text(document['type'], style: TextStyle(
              //                           color: Colors.grey,
              //                           fontSize: 16,
              //                         ),),
              //                         SizedBox(height: 10,),
              //                         Row(
              //                           children: [
              //                             Container(
              //                               padding: EdgeInsets.all(5),
              //                               width: 70,
              //                               decoration: BoxDecoration(
              //                                 color: Colors.blueGrey.shade200,
              //                                 borderRadius: BorderRadius.circular(10),
              //                               ),
              //                               alignment: Alignment.center,
              //                               child: Text(''
              //                                 // activity.startTimes[0],
              //                               ),
              //                             ),
              //                             SizedBox(width: 10,),
              //                             Container(
              //                               padding: EdgeInsets.all(5),
              //                               width: 70,
              //                               decoration: BoxDecoration(
              //                                 color: Colors.blueGrey.shade200,
              //                                 borderRadius: BorderRadius.circular(10),
              //                               ),
              //                               alignment: Alignment.center,
              //                               child: Text(''
              //                                 // activity.startTimes[1],
              //                               ),
              //                             ),
              //                           ],
              //                         )
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //                 Positioned(
              //                   left: 15, top: 15, bottom: 15,
              //                   child: ClipRRect(
              //                     borderRadius: BorderRadius.circular(20),
              //                     child: Image(
              //                       width: 110,
              //                       image: AssetImage(document['imageUrl']),
              //                       fit: BoxFit.cover,
              //                     ),
              //                   ),
              //                 )
              //               ],
              //             );
              //           }
              //       );
              //     }
              //   ),
              // ),
              // Expanded(
              //   child: StreamBuilder(
              //       stream: _activities.collection('DaNang').snapshots(),
              //       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
              //         if(!snapshot.hasData) return Text('error');
              //         return ListView.builder(
              //             padding: EdgeInsets.only(top: 10, bottom: 10),
              //             itemCount: snapshot.data!.docs.length,
              //             itemBuilder: (BuildContext context, int index) {
              //               DocumentSnapshot document = snapshot.data!.docs[index];
              //               return Stack(
              //                 children: [
              //                   Container(
              //                     margin: EdgeInsets.fromLTRB(10, 5, 15, 5),
              //                     height: 170,
              //                     width: double.infinity,
              //                     decoration: BoxDecoration(
              //                       borderRadius: BorderRadius.circular(10),
              //                       color: Colors.white,
              //                     ),
              //                     child: Padding(
              //                       padding: const EdgeInsets.fromLTRB(130, 20, 20, 20),
              //                       child: Column(
              //                         mainAxisAlignment: MainAxisAlignment.center,
              //                         crossAxisAlignment: CrossAxisAlignment.start,
              //                         children: [
              //                           Row(
              //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                             crossAxisAlignment: CrossAxisAlignment.start,
              //                             children: [
              //                               Container(
              //                                 width: 120,
              //                                 child: Text(document['name'], style: TextStyle(
              //                                   fontWeight: FontWeight.w600,
              //                                   fontSize: 18,
              //                                 ),),
              //                               ),
              //                               Column(
              //                                 children: [
              //                                   Text(
              //                                     document['price'], style: TextStyle(
              //                                     fontSize: 22.0,
              //                                     fontWeight: FontWeight.w600,
              //                                   ),),
              //                                   Text('1 khách', style: TextStyle(
              //                                       color: Colors.grey
              //                                   ),),
              //                                 ],
              //                               ),
              //                             ],
              //                           ),
              //                           Text(document['type'], style: TextStyle(
              //                             color: Colors.grey,
              //                             fontSize: 16,
              //                           ),),
              //                           SizedBox(height: 10,),
              //                           Row(
              //                             children: [
              //                               Container(
              //                                 padding: EdgeInsets.all(5),
              //                                 width: 70,
              //                                 decoration: BoxDecoration(
              //                                   color: Colors.blueGrey.shade200,
              //                                   borderRadius: BorderRadius.circular(10),
              //                                 ),
              //                                 alignment: Alignment.center,
              //                                 child: Text(''
              //                                   // activity.startTimes[0],
              //                                 ),
              //                               ),
              //                               SizedBox(width: 10,),
              //                               Container(
              //                                 padding: EdgeInsets.all(5),
              //                                 width: 70,
              //                                 decoration: BoxDecoration(
              //                                   color: Colors.blueGrey.shade200,
              //                                   borderRadius: BorderRadius.circular(10),
              //                                 ),
              //                                 alignment: Alignment.center,
              //                                 child: Text(''
              //                                   // activity.startTimes[1],
              //                                 ),
              //                               ),
              //                             ],
              //                           )
              //                         ],
              //                       ),
              //                     ),
              //                   ),
              //                   Positioned(
              //                     left: 15, top: 15, bottom: 15,
              //                     child: ClipRRect(
              //                       borderRadius: BorderRadius.circular(20),
              //                       child: Image(
              //                         width: 110,
              //                         image: AssetImage(document['imageUrl']),
              //                         fit: BoxFit.cover,
              //                       ),
              //                     ),
              //                   )
              //                 ],
              //               );
              //             }
              //         );
              //       }
              //   ),
              // ),
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
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.documentSnapshot['price'] + 'đ/đêm',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
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
                  builder: (context) => booknow_Screen(
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
