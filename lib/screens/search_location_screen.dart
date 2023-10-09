import 'package:app_booking/component/contrast.dart';
import 'package:app_booking/screens/all_hotel_screen.dart';
import 'package:app_booking/screens/ticket_screen/ticket_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SearchBarCityScreen extends StatefulWidget {
  @override
  _SearchBarCityScreenState createState() => _SearchBarCityScreenState();
}

class _SearchBarCityScreenState extends State<SearchBarCityScreen> {
  var inputText = "";

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    Color textBlueColor = Colors.lightBlue.shade800;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    inputText = val;
                    print(inputText);
                  });
                },
                decoration: kTextFieldDecoration.copyWith(
                  fillColor: Colors.grey.shade300,
                  contentPadding:
                      const EdgeInsetsDirectional.fromSTEB(16, 18, 0, 18),
                  prefixIcon: const Icon(
                    FontAwesomeIcons.search,
                    color: Colors.blue,
                  ),
                  hintText: 'Tìm tên địa điểm',
                  hintStyle: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              Expanded(
                child: Container(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("allCity")
                          .where("nameCity", isGreaterThanOrEqualTo: inputText)
                          .where("nameCity", isLessThan: inputText + 'z')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text("Something went wrong"),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SpinKitFadingCircle(
                            duration: const Duration(milliseconds: 2000),
                            itemBuilder: (BuildContext context, int index) {
                              return DecoratedBox(
                                decoration: BoxDecoration(
                                  color:
                                      index.isEven ? Colors.blue : Colors.grey,
                                ),
                              );
                            },
                          );
                        }
                        return ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10, top: 20),
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(15),
                                        ),
                                      ),
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          height: height * 0.1,
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                TicketScreen(
                                                                  documentSnapshot:
                                                                      document,
                                                                  idCity:
                                                                      document
                                                                          .id,
                                                                )));
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        FontAwesomeIcons.ticket,
                                                        color: textBlueColor,
                                                        size: 25,
                                                      ),
                                                      const SizedBox(height: 5),
                                                      const Text(
                                                        'Vé Du Lịch',
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 25),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                All_Hotel_Screen(
                                                                  idCity:
                                                                      document
                                                                          .id,
                                                                  documentSnapshot:
                                                                      document,
                                                                )));
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        FontAwesomeIcons.hotel,
                                                        color: textBlueColor,
                                                        size: 25,
                                                      ),
                                                      const SizedBox(height: 5),
                                                      const Text(
                                                        'Khách sạn',
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 75,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: const Offset(0,
                                              1), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: ListTile(
                                    title: Text(data['nameCity']),
                                    leading: Container(
                                      height: 100,
                                      width: 130,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image:
                                                NetworkImage(data['imageUrl']),
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
