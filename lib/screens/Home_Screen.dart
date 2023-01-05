import 'package:app_booking/component/contrast.dart';
import 'package:app_booking/screens/search_bar_screen.dart';
import 'package:app_booking/services/famousHotel_management/addFamousHotel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../component/app_large_text.dart';
import '../component/text_app.dart';
import '../services/famousHotel_management/editfamousHotel.dart';
import 'destination_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);
  static const String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  int activeIndex = 0;

  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    controller.addListener(() {
      setState(() {
        closeTopContainer = controller.offset > 30;
      });
    });
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

  String admin = "admin@email.com";
  final CollectionReference _famousHotel =
      FirebaseFirestore.instance.collection('famousHotelAll');
  Future<void> deleteHotel(String hotelID) async {
    await _famousHotel.doc(hotelID).delete();
    EasyLoading.showSuccess(
      'Xóa thành công!',
      duration: const Duration(milliseconds: 1300),
      maskType: EasyLoadingMaskType.black,
    );
  }

  // void _showDialog(){
  //   showDialog(
  //       context: context,
  //       builder: (context){
  //         return AlertDialog(
  //           backgroundColor: Colors.grey,
  //           content: Text('Bạn chắc chắn xóa chứ ?'),
  //           actions: [
  //             MaterialButton(
  //                 onPressed: deleteHotel
  //             )
  //           ],
  //         );
  //       }
  //   );
  // }
  bool _isFavorite = false;
  int _countFavorite = 0;
  void _checkFavorite() {
    setState(() {
      if (_isFavorite) {
        _countFavorite -= 1;
        _isFavorite = false;
      } else {
        _countFavorite += 1;
        _isFavorite = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentuser = loggedInUser.email;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                CarouselSlider.builder(
                    itemCount: images.length,
                    itemBuilder: (_, index, realIndex) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25)),
                            image: DecorationImage(
                              image: AssetImage(
                                "lib/asset/images_welcome/" + images[index],
                              ),
                              fit: BoxFit.cover,
                              colorFilter: const ColorFilter.mode(
                                  Colors.black45, BlendMode.darken),
                            )),
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.only(
                              top: 270, left: 20, right: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppLargeText(
                                    text: textName[index],
                                    color: Colors.white,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        FontAwesomeIcons.locationArrow,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      AppText(
                                        text: textAddress[index],
                                        color: Colors.white70,
                                        size: 25,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                        enlargeCenterPage: true,
                        initialPage: 0,
                        height: 430,
                        viewportFraction: 1,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 4),
                        onPageChanged: (index, reason) {
                          setState(() {
                            activeIndex = index;
                          });
                        })),
                Padding(
                  padding: const EdgeInsets.only(top: 340, left: 330),
                  child: AnimatedSmoothIndicator(
                    activeIndex: activeIndex,
                    count: images.length,
                    effect: const WormEffect(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 90, left: 20, right: 20),
                  child: TextField(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchBarScreen())),
                    decoration: kTextFieldDecoration.copyWith(
                      fillColor: Colors.white70,
                      contentPadding:
                          const EdgeInsetsDirectional.fromSTEB(16, 18, 0, 18),
                      prefixIcon: const Icon(
                        FontAwesomeIcons.search,
                        color: Colors.green,
                      ),
                      hintText: 'Tìm thành phố...',
                      hintStyle:
                          const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Khách sạn nổi bật',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      currentuser == admin
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(right: 15, left: 15),
                              child: GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, addfamousHotel_Screen.id),
                                child: Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  height:
                                      MediaQuery.of(context).size.width * 0.07,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Text(
                                    'Thêm Hotel',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const Padding(
                              padding: EdgeInsets.only(right: 15, bottom: 10),
                              child: Text(
                                'Xem tất cả',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    height: 350,
                    child: StreamBuilder(
                      stream: _famousHotel.snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData)
                          return SpinKitFadingCircle(
                            duration: const Duration(milliseconds: 2000),
                            itemBuilder: (BuildContext context, int index) {
                              return DecoratedBox(
                                decoration: BoxDecoration(
                                  color:
                                      index.isEven ? Colors.red : Colors.green,
                                ),
                              );
                            },
                          );
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                                snapshot.data!.docs[index];
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DestinationScreen(
                                    idCity: documentSnapshot.id,
                                    documentSnapshot: documentSnapshot,
                                    idHotel: documentSnapshot.id,
                                  ),
                                ),
                              ),
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 10, right: 15),
                                width: 230,
                                child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    Positioned(
                                      child: Container(
                                        height: 120,
                                        width: 230,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.blueGrey.shade200,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, bottom: 8),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                documentSnapshot['nameHotel'],
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.8,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'Từ ' +
                                                    NumberFormat.simpleCurrency(
                                                            locale: 'vi-VN',
                                                            decimalDigits: 0)
                                                        .format(
                                                            documentSnapshot[
                                                                'price']),
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Nhận: ' +
                                                        documentSnapshot[
                                                            'checkIn'],
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    'Trả: ' +
                                                        documentSnapshot[
                                                            'checkOut'],
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      bottom: 35.0,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          const BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(0.0, 0.2),
                                            blurRadius: 6.0,
                                          )
                                        ],
                                      ),
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            height: 220,
                                            width: 215,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    documentSnapshot[
                                                        'imageUrl'],
                                                  ),
                                                  fit: BoxFit.cover,
                                                  colorFilter:
                                                      const ColorFilter.mode(
                                                          Colors.black26,
                                                          BlendMode.darken),
                                                )),
                                          ),
                                          currentuser == admin
                                              ? Positioned(
                                                  top: 3,
                                                  right: 50,
                                                  child: GestureDetector(
                                                    onTap: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            edifamousHotel_Screen(
                                                                documentSnapshot),
                                                      ),
                                                    ),
                                                    child: const CircleAvatar(
                                                      backgroundColor:
                                                          Colors.grey,
                                                      child: Icon(
                                                        FontAwesomeIcons.edit,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                          currentuser == admin
                                              ? Positioned(
                                                  top: 3,
                                                  right: 5,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return CupertinoAlertDialog(
                                                              // backgroundColor: Colors.grey.shade100,
                                                              // title: Text('Thông báo'),
                                                              content:
                                                                  const Text(
                                                                'Bạn chắc chắn xóa chứ ?',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                              actions: [
                                                                MaterialButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'Hủy'),
                                                                ),
                                                                MaterialButton(
                                                                  onPressed:
                                                                      () {
                                                                    deleteHotel(
                                                                        documentSnapshot
                                                                            .id);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: const Text(
                                                                      'Đồng ý'),
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    child: const CircleAvatar(
                                                      backgroundColor:
                                                          Colors.grey,
                                                      child: Icon(
                                                        FontAwesomeIcons.trash,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                          // ):  Positioned(
                                          //   right: 3,
                                          //   child: IconButton(
                                          //     onPressed: (){
                                          //       _checkFavorite();
                                          //     },
                                          //       icon: (_isFavorite ?
                                          //       Icon(Icons.favorite, color: Colors.red,):
                                          //       Icon(Icons.favorite_border, color: Colors.white,)),
                                          //     iconSize: 30,
                                          //   ),
                                          // ),
                                          Positioned(
                                            left: 11.0,
                                            bottom: 14,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  FontAwesomeIcons
                                                      .locationArrow,
                                                  size: 22,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  documentSnapshot['nameCity'],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 0.8),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  // Container(
                  //   width: MediaQuery.of(context).size.width,
                  //   height: MediaQuery.of(context).size.width*0.6,
                  //   decoration: BoxDecoration(
                  //       image: DecorationImage(
                  //         image: NetworkImage('https://images1.content-hci.com/commimg/myhotcourses/blog/post/myhc_94121.jpg'),
                  //         fit: BoxFit.cover,
                  //       )
                  //   ),
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
