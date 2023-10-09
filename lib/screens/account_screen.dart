import 'dart:io';

import 'package:app_booking/layout/tabbar_screen.dart';
import 'package:app_booking/screens/sign_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

import '../model/user_model.dart';
import '../services/profile_management/editprofile_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);
  static const String id = 'account_screen';
  @override
  _AccountScreenStateState createState() => _AccountScreenStateState();
}

class _AccountScreenStateState extends State<AccountScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  String? imageUrl, email, avatarUser, name;
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          avatarUser = loggedInUser.avatar ?? '';
          name = loggedInUser.userName ?? '';
          email = loggedInUser.email ?? '';
        });
      });
    });
  }

  String? admin = 'admin@email.com';

  @override
  Widget listTitle(
      {required IconData icon, required String title, required onPress}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white54,
            ),
            child: ListTile(
              leading: Icon(
                icon,
                color: Colors.black,
              ),
              title: Text(
                title,
                style: const TextStyle(fontSize: 18),
              ),
              onTap: onPress,
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var currentUser = loggedInUser;
    // UserModel user = Provider.of<UserModel>(context).userDetails;
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Thông tin",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  color: Colors.blueGrey,
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            // width: double.infinity,
                            // height: 20,
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    name == null
                                        ? Container(
                                            padding: const EdgeInsets.all(1.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8.0)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  spreadRadius: 2,
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                )
                                              ],
                                            ),
                                            child: Row(children: [
                                              /// Image
                                              Shimmer.fromColors(
                                                period:
                                                    const Duration(seconds: 1),
                                                baseColor: Colors.grey[300]!,
                                                highlightColor:
                                                    Colors.grey[100]!,
                                                child: Container(
                                                  width: screenSize.width * 0.3,
                                                  height:
                                                      screenSize.height * 0.01,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ]),
                                          )
                                        : Text(
                                            '$name',
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    email == null
                                        ? Container(
                                            padding: const EdgeInsets.all(1.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8.0)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  spreadRadius: 2,
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                )
                                              ],
                                            ),
                                            child: Row(children: [
                                              /// Image
                                              Shimmer.fromColors(
                                                period:
                                                    const Duration(seconds: 1),
                                                baseColor: Colors.grey[300]!,
                                                highlightColor:
                                                    Colors.grey[100]!,
                                                child: Container(
                                                  width:
                                                      screenSize.width * 0.55,
                                                  height:
                                                      screenSize.height * 0.02,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ]),
                                          )
                                        : SizedBox(
                                            width: screenSize.width * 0.55,
                                            child: Text(
                                              "$email",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      listTitle(
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => editProfile_Screen(
                                      currentUserId: loggedInUser.uid!)));
                        },
                        icon: FontAwesomeIcons.penToSquare,
                        title: "Chỉnh sửa thông tin",
                      ),
                      listTitle(
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TabBarScreen()));
                        },
                        icon: FontAwesomeIcons.landmark,
                        title: "Lịch sử đặt phòng",
                      ),
                      listTitle(
                        onPress: () async {
                          FirebaseAuth.instance.signOut();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignInScreen(),
                              ));
                          EasyLoading.showSuccess("Đăng xuất thành công !");
                        },
                        icon: FontAwesomeIcons.rightFromBracket,
                        title: "Đăng xuất",
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 40),
              child: avatarUser == null
                  ? Container(
                      padding: const EdgeInsets.all(1.0),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(children: [
                        /// Image
                        Shimmer.fromColors(
                          period: const Duration(seconds: 1),
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: const CircleAvatar(
                            backgroundColor: Colors.blueGrey,
                            radius: 50,
                          ),
                        ),
                      ]),
                    )
                  : CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.blueGrey,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage("$avatarUser"),
                        radius: 50,
                        // backgroundColor: ,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  uploadImage() async {
    final imagePicker = ImagePicker();
    XFile? image;
    UploadTask uploadTask;
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    // if (permissionStatus.isGranted) {
    image = await imagePicker.pickImage(source: ImageSource.gallery);
    var file = File(image!.path);
    if (image != null) {
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child('avatarimage/${image.path.split('/').last}')
          .putFile(file)
          .whenComplete(() => print('success'));
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
      });
    } else {
      print('No image path received');
    }
    // } else {
    //   print('Permission not granted. Try again with permission access');
    // }
  }
}
