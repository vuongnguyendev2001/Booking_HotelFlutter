import 'package:app_booking/screens/search_location_screen.dart';
import 'package:app_booking/screens/ticket_screen/ticket_screen.dart';
import 'package:app_booking/services/city_management/addCityAll.dart';
import 'package:app_booking/services/city_management/editCity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'all_hotel_screen.dart';

class all_City extends StatefulWidget {
  const all_City({Key? key}) : super(key: key);

  @override
  State<all_City> createState() => _all_CityState();
}

class _all_CityState extends State<all_City> {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
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
      print('e');
    }
  }

  final CollectionReference _allCity =
      FirebaseFirestore.instance.collection('allCity');
  String admin = "admin@email.com";

  bool? _isLoading = false;
  Future showDeleteCity(String cityID) async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Xóa'),
        content: const Text('Bạn có chắc chắn xóa ?'),
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
                await _allCity.doc(cityID).delete();

                setState(() {
                  _isLoading = false;
                  EasyLoading.dismiss();
                });
                Navigator.pop(context);

                EasyLoading.showSuccess(
                  'Xóa thành công!',
                  duration: const Duration(milliseconds: 1300),
                  maskType: EasyLoadingMaskType.black,
                );
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    Color textBlueColor = Colors.lightBlue.shade800;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade300,
          automaticallyImplyLeading: false,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                  child: Text(
                'TẤT CẢ ĐỊA ĐIỂM',
                style: TextStyle(
                    color: Colors.blueGrey.shade800, fontFamily: 'Vollkorn'),
              )),
              loggedInUser.email == admin
                  ? Row(
                      children: [
                        GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const addCity_Screen())),
                            child: const Icon(
                              FontAwesomeIcons.circlePlus,
                              color: Colors.grey,
                              size: 35,
                            )),
                        const SizedBox(width: 5),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SearchBarCityScreen()));
                            },
                            child: Icon(
                              FontAwesomeIcons.search,
                              color: Colors.blueGrey.shade800,
                              size: 25,
                            )),
                      ],
                    )
                  : GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchBarCityScreen()));
                      },
                      child: Icon(
                        FontAwesomeIcons.search,
                        color: Colors.blueGrey.shade800,
                        size: 25,
                      )),
            ],
          ),
        ),
        body: StreamBuilder(
          stream: _allCity.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return SpinKitFadingCircle(
                duration: const Duration(milliseconds: 2000),
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: index.isEven ? Colors.red : Colors.green,
                    ),
                  );
                },
              );
            return GridView.builder(
              padding: const EdgeInsets.all(15),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: width * 0.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, int index) {
                DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                return Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: NetworkImage(documentSnapshot['imageUrl']),
                              fit: BoxFit.cover,
                              colorFilter: const ColorFilter.mode(
                                  Colors.black45, BlendMode.darken),
                            ),
                          ),
                        ),
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
                                                              documentSnapshot,
                                                          idCity:
                                                              documentSnapshot
                                                                  .id,
                                                        )));
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.ticket,
                                                color: textBlueColor,
                                                size: 25,
                                              ),
                                              const SizedBox(height: 5),
                                              const Text(
                                                'Vé Du Lịch',
                                                style: TextStyle(fontSize: 15),
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
                                                              documentSnapshot
                                                                  .id,
                                                          documentSnapshot:
                                                              documentSnapshot,
                                                        )));
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.hotel,
                                                color: textBlueColor,
                                                size: 25,
                                              ),
                                              const SizedBox(height: 5),
                                              const Text(
                                                'Khách sạn',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }),
                    loggedInUser.email == admin
                        ? Positioned(
                            top: 5,
                            right: 50,
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          editCity_Screen(documentSnapshot))),
                              child: Container(
                                width: width * 0.1,
                                height: width * 0.1,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(FontAwesomeIcons.edit),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    loggedInUser.email == admin
                        ? Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () {
                                showDeleteCity(documentSnapshot.id);
                              },
                              child: Container(
                                width: width * 0.1,
                                height: width * 0.1,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(FontAwesomeIcons.trashCan),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 6.0),
                            child: Icon(
                              FontAwesomeIcons.locationDot,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            documentSnapshot['nameCity'],
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontFamily: 'Vollkorn',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
            );
          },
        ));
  }
}
