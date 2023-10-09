//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../screens/addLocation_Screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// final _firestore = FirebaseFirestore.instance;
// late User loggedInUser;
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//   static const String id = 'trangchu';
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
// class _HomeScreenState extends State<HomeScreen> {
//   final messsageTextController = TextEditingController();
//   final _auth = FirebaseAuth.instance;
//   String? messageText;
//   String? imageUrl;
//   @override
//   void initState() {
//     super.initState();
//     getCurrentUser();
//   }
//
//   void getCurrentUser() async {
//     try {
//       final user = _auth.currentUser;
//       if (user != null) {
//         loggedInUser = user;
//         print('Imformation of user: $user');
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey,
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.black),
//         title: Text("Chợ Giày 2hand", style: TextStyle(
//           color: Colors.black,
//           fontSize: 20,
//         ),),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.symmetric(),
//             child: CircleAvatar(
//               radius: 15,
//               backgroundColor: Colors.blueGrey,
//               child: IconButton(
//                 onPressed: (){
//                   Scaffold.of(context).openDrawer();
//                 },
//                 tooltip: MaterialLocalizations
//                     .of(context)
//                     .openAppDrawerTooltip,
//                 icon: Icon(
//                   Icons.search,
//                   size: 18, color: Colors.black,),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12,),
//             child: CircleAvatar(
//               radius: 15,
//               backgroundColor: Colors.blueGrey,
//               child: IconButton(
//                 onPressed: (){
//                   Navigator.pushNamed(context, addLocation_Screen.id);
//                   Scaffold.of(context).openDrawer();
//                 },
//                 tooltip: MaterialLocalizations
//                     .of(context)
//                     .openAppDrawerTooltip,
//                 icon: Icon(
//                   Icons.add,
//                   size: 18, color: Colors.black,),
//               ),
//             ),
//           ),
//
//         ],
//         backgroundColor: Colors.black12,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children:  [
//               getProduct(),
//             ],
//           ),
//         ),
//       ),
//       // _buildCoffeeProduct(),
//       // _buildMlikeTeaProduct(),
//       // _buildCakeProduct(),
//     );
//   }
// }
// class getProduct extends StatelessWidget {
//   const getProduct({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//         stream:
//         _firestore.collection('location').snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(
//               child: CircularProgressIndicator(
//                 backgroundColor: Colors.blueAccent,
//               ),
//             );
//           }
//           final indexs = snapshot.data!.docs.reversed;
//           List<productModel> messageBubbles = [];
//           for (var index in indexs) {
//             final indexCity = index.get('city');
//             final indexImage = index.get('image');
//             final indexDes = index.get('destination');
//             final currentUser = loggedInUser.email!;
//             final indexEmail = index.get('email');
//             final messageBubble = productModel(
//               email: indexEmail,
//               city: indexCity,
//               isMe: currentUser == indexEmail,
//               image: indexImage,
//             );
//             messageBubbles.add(messageBubble);
//           }
//           return Expanded(
//             child: ListView(
//               padding:
//               const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
//               children: messageBubbles,
//             ),
//           );
//         });
//   }
// }
//
// class productModel extends StatelessWidget {
//   productModel({
//     this.email,
//     this.isMe,
//     this.city,
//     this.description,
//     this.image,
//   });
//   final String? city;
//   final String? email;
//   final String? image;
//   final String? description;
//   final bool? isMe;
//
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(padding: EdgeInsets.only(bottom: 15),
//           child: Container(
//             child: Stack(
//               children: <Widget> [
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular((30)),
//                     boxShadow: [BoxShadow(
//                       spreadRadius: 1,
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 2,
//                     )],
//                   ),
//                   child: Column(
//                     children: <Widget> [
//                       Center(
//                         child: Container(
//                           padding: EdgeInsets.only(top: 15, bottom: 10),
//                           width: 280,
//                           height: 180,
//                           child: GestureDetector(
//                             child: Expanded(
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(25),
//                                 child: Image.network(image!, fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Text(city!, style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w600,
//                       ),),
//                       SizedBox(height: 5,),
//
//                       SizedBox(height: 5,),
//                       Text('Người đăng: '+ email!, style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w600,
//                       ),),
//                       SizedBox(height: 5,),
//                       MaterialButton(
//                         onPressed: (){
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.black,
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           height: 40,
//                           width: 180,
//                           child: Center(
//                             child: MaterialButton(
//                               onPressed: (){
//                                 // Navigator.pushNamed(context, BuyProduct.id);
//                               },
//                               child: Text('MUA SẢN PHẨM', style: TextStyle(
//                                 fontFamily: 'Anek_Malayalam',
//                                 color: Colors.white,
//                                 fontSize: 17,
//                                 fontWeight: FontWeight.w700,
//                               ),),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 15,),
//                     ],
//                   ),
//                 ),
//                 isMe! ? Positioned(
//                   right: 10,
//                   child: IconButton(
//                     onPressed: (){
//                       // Navigator.pushNamed(context, editProduct.id);
//                     },
//                     icon: Icon(Icons.favorite_outline,),
//                   ),
//                 ) : SizedBox(),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../famousHotel_management/addFamousHotel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
void main(){
  runApp(const Location_Screen());
}
class Location_Screen extends StatelessWidget {
  const Location_Screen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: EasyLoading.init(),
    );
  }
}
final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class location_Screen extends StatefulWidget {
  const location_Screen({Key? key}) : super(key: key);
  static const String id = 'location_screen';

  @override
  State<location_Screen> createState() => _location_ScreenState();
}

class _location_ScreenState extends State<location_Screen> {
  final messsageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? messageText;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print('Imformation of user: $user');
      }
    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Chợ Giày 2hand", style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(),
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.blueGrey,
              child: IconButton(
                onPressed: (){
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations
                    .of(context)
                    .openAppDrawerTooltip,
                icon: Icon(
                  Icons.search,
                  size: 18, color: Colors.black,),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12,),
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.blueGrey,
              child: IconButton(
                onPressed: (){
                  Navigator.pushNamed(context, addfamousHotel_Screen.id);
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations
                    .of(context)
                    .openAppDrawerTooltip,
                icon: Icon(
                  Icons.add,
                  size: 18, color: Colors.black,),
              ),
            ),
          ),

        ],
        backgroundColor: Colors.black12,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:  [
              getProduct(),
            ],
          ),
        ),
      ),
    );
  }
}
class getProduct extends StatelessWidget {
  const getProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
        _firestore.collection('product').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ),
            );
          }
          final indexs = snapshot.data!.docs.reversed;
          List<productModel> messageBubbles = [];
          for (var index in indexs) {
            final indexDiachi = index.get('address');
            final indexImg = index.get('image');
            final indexMoney = index.get('price');
            final indexName = index.get('name');
            final indexNameSP = index.get('nameProduct');
            final indexPhone = index.get('phone');
            final currentUser = loggedInUser.email!;
            final indexEmail = index.get('email');
            final messageBubble = productModel(
              email: indexEmail,
              address: indexDiachi,
              name: indexName,
              productName: indexNameSP,
              phoneNumber: indexPhone,
              price: indexMoney,
              isMe: currentUser == indexEmail,
              productImage: indexImg,
            );
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              padding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: messageBubbles,
            ),
          );
        });
  }
}

class productModel extends StatelessWidget {
  productModel({
    this.name,
    this.phoneNumber,
    this.address,
    this.price,
    this.productName,
    this.email,
    this.productImage,
    this.isMe});

  final String? address;
  final String? email;
  final String? productImage;
  final String? price;
  final String? name;
  final String? productName;
  final String? phoneNumber;
  final bool? isMe;

  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(bottom: 15),
          child: Container(
            child: Stack(
              children: <Widget> [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular((30)),
                    boxShadow: [BoxShadow(
                      spreadRadius: 1,
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                    )],
                  ),
                  child: Column(
                    children: <Widget> [
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 15, bottom: 10),
                          width: 280,
                          height: 180,
                          child: GestureDetector(
                            child: Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.network(productImage!, fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(productName!, style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),),
                      SizedBox(height: 5,),
                      Text(price! + 'đ',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),),
                      SizedBox(height: 5,),
                      Text('Người đăng: '+ email!, style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),),
                      SizedBox(height: 5,),
                      MaterialButton(
                        onPressed: (){
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          height: 40,
                          width: 180,
                          child: Center(
                            child: MaterialButton(
                              onPressed: (){
                                // Navigator.pushNamed(context, BuyProduct.id);
                              },
                              child: Text('MUA SẢN PHẨM', style: TextStyle(
                                fontFamily: 'Anek_Malayalam',
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),
                    ],
                  ),
                ),
                isMe! ? Positioned(
                  right: 10,
                  child: IconButton(
                    onPressed: (){
                      // Navigator.pushNamed(context, editProduct.id);
                    },
                    icon: Icon(Icons.favorite_outline,),
                  ),
                ) : SizedBox(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
