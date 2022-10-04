import 'dart:io';

import 'package:app_booking/screens/login.dart';
import 'package:app_booking/screens/myorder_Screen.dart';
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
import 'editprofile_screen.dart';

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
                  height: 100,
                  color: Colors.blueGrey,
                ),
                Container(
                  height: 580,
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
                            width: 250,
                            height: 80,
                            padding: EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$name',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "$email",
                                      style: TextStyle(
                                        fontSize: 16,
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
                                      currentUserId: '${loggedInUser.uid}')));
                        },
                        icon: FontAwesomeIcons.penToSquare,
                        title: "Chỉnh sửa thông tin",
                      ),
                      listTitle(
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => myorder_Screen()));
                        },
                        icon: FontAwesomeIcons.landmark,
                        title: "Lịch sử đặt phòng",
                      ),
                      // listTitle(
                      //   onPress: (){},
                      //   icon: FontAwesomeIcons.creditCard,
                      //   title: "Thông tin thanh toán",
                      // ),
                      listTitle(
                        onPress: () async {
                          final SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          sharedPreferences.remove('email');
                          Navigator.pushNamed(context, Login.id);
                          EasyLoading.showSuccess(
                            'Đăng xuất thành công!',
                            duration: Duration(milliseconds: 1300),
                            maskType: EasyLoadingMaskType.black,
                          );
                        },
                        icon: FontAwesomeIcons.rightFromBracket,
                        title: "Log Out",
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
    PickedFile? image;
    UploadTask uploadTask;
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      image = await imagePicker.getImage(source: ImageSource.gallery);
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
    } else {
      print('Permission not granted. Try again with permission access');
    }
  }
}
