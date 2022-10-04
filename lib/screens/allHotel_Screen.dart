
import 'package:app_booking/screens/addHotel_Screen.dart';
import 'package:app_booking/screens/destination_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'editHotel_Screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

late User loggedInUser;
class allHotel_Screen extends StatefulWidget {
  allHotel_Screen({ required this.documentSnapshot});
  DocumentSnapshot? documentSnapshot;
  @override
  State<allHotel_Screen> createState() => _allHotel_ScreenState();
}

class _allHotel_ScreenState extends State<allHotel_Screen> {
  final String admin = "admin@email.com";
  final _auth = FirebaseAuth.instance;
  void initState() {
    super.initState();
    getCurrentUser();
    controller.addListener(() {
      setState(() {
       closeTopContainer = controller.offset > 40 ;
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
  final CollectionReference _allHotel = FirebaseFirestore.instance.collection('allHotel');
  Future<void> deleteHotel(String hotelID) async {
    await _allHotel.doc(hotelID).delete();
    EasyLoading.showSuccess('Xóa thành công',
      duration: Duration(milliseconds: 1300),
      maskType: EasyLoadingMaskType.black,
    );
  }
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  @override
  Widget build(BuildContext context) {
    var currentuser = loggedInUser.email;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade400,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(child: Text('Khách sạn tại ' + widget.documentSnapshot!['nameCity'], style: TextStyle(
                color: Colors.blueGrey.shade800,
                fontFamily: 'Vollkorn',
              fontSize: 20,
            ),)),
            currentuser == admin ?
            GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          addHotel_Screen(documentSnapshot: widget.documentSnapshot,)));
                },
                child: Icon(FontAwesomeIcons.circlePlus,
                  color: Colors.blueGrey.shade800,
                  size: 30,)): SizedBox(),
          ],
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              AnimatedContainer(
                padding: EdgeInsets.only(left: 15, bottom: 10),
                  duration: Duration(milliseconds: 300),
                width: width,
                alignment: Alignment.bottomLeft,
                 height: closeTopContainer?0:height*0.25,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.documentSnapshot!['imageUrl']),
                    fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken)
                  )
                ),
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.locationArrow, color: Colors.white,),
                    SizedBox(width: 10,),
                    Text(widget.documentSnapshot!['nameCity'], style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontFamily: 'Vollkorn',
                    ),),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('allCity').
              doc(widget.documentSnapshot!.id).collection('allHotel').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(!snapshot.hasData) return SpinKitFadingCircle(
                  duration: Duration(milliseconds: 2000),
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: index.isEven ? Colors.red : Colors.green,
                      ),
                    );
                  },
                );
                return ListView.builder(
                  controller: controller,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index){
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GestureDetector(
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>
                                  DestinationScreen(documentSnapshot: document))),
                          child: Column(
                            children: [
                              StreamBuilder<Object>(
                                stream: null,
                                builder: (context, snapshot) {
                                  return Container(
                                    alignment: Alignment.topRight,
                                    width: width,
                                    height: width*0.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                                      image: DecorationImage(
                                        image: NetworkImage(document['imageUrl']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: width,
                                        height: height * 0.05,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            currentuser == admin ?
                                            GestureDetector(
                                              onTap: () => Navigator.push(context,
                                                MaterialPageRoute(builder:(context) =>
                                                    editHotel_Screen(document),),),
                                              child: Container(
                                                  height: width *0.12,
                                                  width: width *0.12,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade600,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Icon(FontAwesomeIcons.edit, color: Colors.white,)),
                                            ): SizedBox(),
                                            SizedBox(width: 5,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              ),
                              Container(
                                width: width,
                                height: width*0.2,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.shade200,
                                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(document['nameHotel'], style: TextStyle(
                                        fontSize: 27,
                                        fontFamily: 'Vollkorn',
                                      ),),
                                      Text('VND ' + document['price'],
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
