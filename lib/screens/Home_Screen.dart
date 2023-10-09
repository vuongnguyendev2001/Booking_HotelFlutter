import 'package:app_booking/component/contrast.dart';
import 'package:app_booking/component/currency_formatter.dart';
import 'package:app_booking/screens/chat_home/chat_home_screen.dart';
import 'package:app_booking/screens/destination_ticket/destination_ticket_screen.dart';
import 'package:app_booking/screens/search_location_screen.dart';
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
        // print('User: $user');
      }
    } catch (e) {
      // print(e);
    }
  }

  String admin = "admin@email.com";
  // final CollectionReference _famousHotel = FirebaseFirestore.instance
  //     .collection('famousHotelAll')
  //     .doc('')
  //     .collection('');
  // Future<void> deleteHotel(String hotelID) async {
  //   await _famousHotel.doc(hotelID).delete();
  //   EasyLoading.showSuccess(
  //     'Xóa thành công!',
  //     duration: const Duration(milliseconds: 1300),
  //     maskType: EasyLoadingMaskType.black,
  //   );
  // }

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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    Color textBlueColor = Colors.lightBlue.shade800;
    return Scaffold(
      appBar: AppBarHomeScreen(textBlueColor),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SeachLocation(width, context),
            // Menu(width, textBlueColor, context),
            SliderHome(width, textBlueColor),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  child: Text(
                    'Top Trãi Nghiệm Hot tại Đà Nẵng',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TicketWidget(context, width, textBlueColor),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Khách sạn nổi bật tại Đà Lạt',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Xem tất cả',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                FamusHotel(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container FamusHotel() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      height: 350,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('allCity')
            .doc('9rC9CyhnynUDMcNkOhgn')
            .collection('allHotel')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
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
          }
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
                      idCity: '9rC9CyhnynUDMcNkOhgn',
                      documentSnapshot: documentSnapshot,
                      idHotel: documentSnapshot.id,
                      nameLocation: 'Đà Lạt',
                    ),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 15),
                  width: 230,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        child: Container(
                          height: 120,
                          width: 230,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blueGrey.shade200,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      CurrencyFormatter.convertPrice(
                                          price: documentSnapshot['price']),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        bottom: 60.0,
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
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      documentSnapshot['imageUrl'],
                                    ),
                                    fit: BoxFit.cover,
                                    colorFilter: const ColorFilter.mode(
                                        Colors.black26, BlendMode.darken),
                                  )),
                            ),
                            Positioned(
                              left: 11.0,
                              bottom: 14,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.locationArrow,
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
                                        fontWeight: FontWeight.w600,
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
    );
  }

  SizedBox TicketWidget(
      BuildContext context, double width, Color textBlueColor) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 0.42,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('allCity')
              .doc('DaNang')
              .collection('allTicket')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
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
            }
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.docs.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(
                width: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot document = snapshot.data!.docs[index];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DestinationTicketScreen(
                          idHotel: document.id,
                          idCity: 'DaNang',
                          documentSnapshot: document,
                          nameLocation: 'Đà Nẵng',
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Container(
                      width: width * 0.6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(right: 8),
                            alignment: Alignment.topRight,
                            height: width * 0.3,
                            width: width * 0.6,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  topLeft: Radius.circular(15)),
                              image: DecorationImage(
                                image: NetworkImage(document['imageUrl'] ?? ''),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Icon(
                              Icons.favorite_outline,
                              color: textBlueColor,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            document['nameTicket'] ?? '',
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // const SizedBox(height: 5),
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Icon(
                          //       FontAwesomeIcons.starHalfStroke,
                          //       size: 14,
                          //       color: textBlueColor,
                          //     ),
                          //     const SizedBox(width: 5),
                          //     const Text(
                          //       '4.8 (95)',
                          //       style: TextStyle(
                          //         fontSize: 14,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          const SizedBox(height: 5),
                          Text(
                            'Giá từ ' +
                                CurrencyFormatter.convertPrice(
                                    price: document['price']),
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }

  Padding SliderHome(double width, Color textBlueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Stack(
        children: [
          CarouselSlider.builder(
              itemCount: images.length,
              itemBuilder: (_, index, realIndex) {
                return Container(
                  width: width,
                  height: width * 0.2,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(
                          "lib/asset/images_welcome/" + images[index],
                        ),
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                            Colors.black45, BlendMode.darken),
                      )),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppLargeText(
                            text: textName[index],
                            color: Colors.white,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(
                                FontAwesomeIcons.locationArrow,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              AppText(
                                text: textAddress[index],
                                color: Colors.white70,
                                size: 18,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              options: CarouselOptions(
                  enlargeCenterPage: true,
                  initialPage: 0,
                  height: 180,
                  viewportFraction: 1,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 10),
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeIndex = index;
                    });
                  })),
          Positioned(
            bottom: 5,
            right: 10,
            child: AnimatedSmoothIndicator(
              activeIndex: activeIndex,
              count: images.length,
              effect: WormEffect(
                activeDotColor: textBlueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding Menu(double width, Color textBlueColor, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        padding: const EdgeInsets.all(15),
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
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
            const SizedBox(
              width: 20,
            ),
            Column(
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
            const SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const chatHomePage(),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.message_sharp,
                    color: textBlueColor,
                    size: 27,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Trò chuyện',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              children: [
                Icon(
                  FontAwesomeIcons.blog,
                  color: textBlueColor,
                  size: 25,
                ),
                const SizedBox(height: 5),
                const Text(
                  'Blog',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }

  Padding SeachLocation(double width, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 1.5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.grey,
          width: width,
          height: 35,
          child: TextField(
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchBarCityScreen())),
            decoration: kTextFieldDecoration.copyWith(
              fillColor: Colors.white70,
              contentPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              prefixIcon: const Icon(
                FontAwesomeIcons.search,
                size: 17,
                color: Colors.blueAccent,
              ),
              hintText: 'Tìm địa diểm, hoạt động vui chơi hoặc dịch vụ',
              hintStyle: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar AppBarHomeScreen(Color textBlueColor) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Row(
        children: [
          Icon(
            FontAwesomeIcons.plane,
            color: textBlueColor,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            'Hi !',
            style: TextStyle(
              color: textBlueColor,
            ),
          )
        ],
      ),
      actions: [
        const Icon(
          FontAwesomeIcons.locationDot,
          color: Colors.grey,
        ),
        const SizedBox(
          width: 15,
        ),
        const Icon(
          FontAwesomeIcons.cartPlus,
          color: Colors.grey,
        ),
        const SizedBox(
          width: 15,
        ),
        const Icon(
          FontAwesomeIcons.bell,
          color: Colors.grey,
        ),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }
}
