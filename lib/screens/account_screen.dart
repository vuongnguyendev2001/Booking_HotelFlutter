import 'dart:io';

import 'package:app_booking/screens/order_screen.dart';
import 'package:app_booking/screens/sign_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      setState(() {
        avatarUser = loggedInUser.avatar;
        name = loggedInUser.userName;
        email = loggedInUser.email;
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
                style: TextStyle(fontSize: 18),
              ),
              onTap: onPress,
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    UserModel user = Provider.of<UserModel>(context).userDetails;
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          "My profile",
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
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
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
                            width: 240,
                            height: 80,
                            padding: EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$name',
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      width: screenSize.width * 0.55,
                                      child: Text(
                                        "$email",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
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
                      currentUser == admin
                          ? listTitle(
                              onPress: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderScreen()));
                              },
                              icon: FontAwesomeIcons.landmark,
                              title: "Lịch sử đặt phòng của user",
                            )
                          : listTitle(
                              onPress: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderScreen()));
                              },
                              icon: FontAwesomeIcons.landmark,
                              title: "Lịch sử đặt phòng",
                            ),
                      listTitle(
                        onPress: () async {
                          final SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          sharedPreferences.remove('email');
                          Navigator.pushNamed(context, SignInScreen.id);
                          EasyLoading.showSuccess(
                            'Đăng xuất thành công!',
                            duration: Duration(milliseconds: 1300),
                            maskType: EasyLoadingMaskType.black,
                          );
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
              child: CircleAvatar(
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
