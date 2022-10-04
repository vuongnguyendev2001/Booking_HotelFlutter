import 'package:app_booking/screens/addCityAll.dart';
import 'package:app_booking/screens/editCity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'allHotel_Screen.dart';

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

  Future<void> delete(String cityID) async {
    await _allCity.doc(cityID).delete();
    EasyLoading.showSuccess(
      'Xóa thành công!',
      duration: Duration(milliseconds: 1300),
      maskType: EasyLoadingMaskType.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
                  ? GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => addCity_Screen())),
                      child: Icon(
                        FontAwesomeIcons.circlePlus,
                        color: Colors.grey,
                        size: 35,
                      ))
                  : SizedBox(),
            ],
          ),
        ),
        body: StreamBuilder(
          stream: _allCity.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return SpinKitFadingCircle(
                duration: Duration(milliseconds: 2000),
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: index.isEven ? Colors.red : Colors.green,
                    ),
                  );
                },
              );
            return GridView.builder(
              padding: EdgeInsets.all(15),
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => allHotel_Screen(
                                      documentSnapshot: documentSnapshot,
                                    )));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: NetworkImage(documentSnapshot['imageUrl']),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black45, BlendMode.darken),
                          ),
                        ),
                      ),
                    ),
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
                                child: Icon(FontAwesomeIcons.edit),
                              ),
                            ),
                          )
                        : SizedBox(),
                    loggedInUser.email == admin
                        ? Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        // backgroundColor: Colors.grey.shade100,
                                        // title: Text('Thông báo'),
                                        content: Text(
                                          'Bạn chắc chắn xóa chứ ?',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        actions: [
                                          MaterialButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Hủy'),
                                          ),
                                          MaterialButton(
                                            onPressed: () {
                                              delete(documentSnapshot.id);
                                              Navigator.pop(context);
                                            },
                                            child: Text('Đồng ý'),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Container(
                                width: width * 0.1,
                                height: width * 0.1,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(FontAwesomeIcons.trashCan),
                              ),
                            ),
                          )
                        : SizedBox(),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Icon(
                              FontAwesomeIcons.locationDot,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            documentSnapshot['nameCity'],
                            style: TextStyle(
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
