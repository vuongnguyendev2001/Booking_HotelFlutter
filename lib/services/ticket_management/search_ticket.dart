// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_booking/component/currency_formatter.dart';
import 'package:app_booking/screens/destination_screen.dart';
import 'package:app_booking/screens/destination_ticket/destination_ticket_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:app_booking/component/contrast.dart';
import 'package:app_booking/screens/all_hotel_screen.dart';
import 'package:app_booking/screens/ticket_screen/ticket_screen.dart';

class SearchTicketScreen extends StatefulWidget {
  final String idCity;
  final String nameLocation;
  DocumentSnapshot? documentTicket;

  SearchTicketScreen({
    Key? key,
    required this.idCity,
    this.documentTicket,
    required this.nameLocation,
  }) : super(key: key);
  @override
  _SearchTicketScreenState createState() => _SearchTicketScreenState();
}

class _SearchTicketScreenState extends State<SearchTicketScreen> {
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
                    color: Colors.green,
                    size: 20,
                  ),
                  hintText: 'Tìm tên vé...',
                  hintStyle: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              Expanded(
                child: Container(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("allCity")
                          .doc(widget.idCity)
                          .collection('allTicket')
                          .where("nameTicket",
                              isGreaterThanOrEqualTo: inputText)
                          .where("nameTicket", isLessThan: inputText + 'z')
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DestinationTicketScreen(
                                        idHotel: document.id,
                                        idCity: widget.idCity,
                                        documentSnapshot: document,
                                        nameLocation: widget.nameLocation,
                                      ),
                                    ),
                                  );
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
                                    title: Text(
                                      data['nameTicket'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                    subtitle: Text(
                                      CurrencyFormatter.convertPrice(
                                          price: data['price']),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
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
