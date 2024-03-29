import 'dart:io';

import 'package:app_booking/layout/layout_screen.dart';
import 'package:app_booking/model/user_model.dart';
import 'package:app_booking/screens/account_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../component/button.dart';

class editProfile_Screen extends StatefulWidget {
  const editProfile_Screen({required this.currentUserId});
  final String currentUserId;
  @override
  State<editProfile_Screen> createState() => _editProfile_ScreenState();
}

class _editProfile_ScreenState extends State<editProfile_Screen> {
  User? user = FirebaseAuth.instance.currentUser;
  String? avatarImage;
  UserModel loggedInUser = UserModel();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _avatarController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.currentUserId)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {
        _avatarController.text = loggedInUser.avatar!;
        _userNameController.text = loggedInUser.userName!;
        _phoneNumberController.text = loggedInUser.phoneNumber!;
      });
    });
  }

  updateProfile() {
    User? user = FirebaseAuth.instance.currentUser;
    if (avatarImage != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(widget.currentUserId)
          .update({
        "avatar": avatarImage,
        "userName": _userNameController.text,
        "phoneNumber": _phoneNumberController.text,
      });
      setState(() {});
      user?.email == 'admin@email.com'
          ? Navigator.pop(context)
          : Navigator.push(
              context, MaterialPageRoute(builder: (context) => NavbarScreen()));
      EasyLoading.showSuccess(
        'Chỉnh sửa thành công',
        duration: const Duration(milliseconds: 1300),
        maskType: EasyLoadingMaskType.black,
      );
    } else {
      FirebaseFirestore.instance
          .collection("users")
          .doc(widget.currentUserId)
          .update({
        "avatar": _avatarController.text,
        "userName": _userNameController.text,
        "phoneNumber": _phoneNumberController.text,
      });
      setState(() {});
      user?.email == 'admin@email.com'
          ? Navigator.pop(context)
          : Navigator.push(
              context, MaterialPageRoute(builder: (context) => NavbarScreen()));
      EasyLoading.showSuccess(
        'Chỉnh sửa thành công',
        duration: const Duration(milliseconds: 1300),
        maskType: EasyLoadingMaskType.black,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey.shade400,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  color: Colors.black45,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(FontAwesomeIcons.arrowLeft),
                  ),
                ),
              ),
              const SizedBox(
                width: 40,
              ),
              const Text(
                'Chỉnh Sửa Thông Tin',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Vollkorn',
                ),
              ),
            ],
          ),
        ),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    avatarImage == null
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 92,
                                  backgroundColor: Colors.blueGrey,
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage("${loggedInUser.avatar}"),
                                    radius: 90,
                                    // backgroundColor: ,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: uploadImage,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey.shade700,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      'Thay Đổi Ảnh',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Vollkorn',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 92,
                                  backgroundColor: Colors.blueGrey,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(avatarImage!),
                                    radius: 90,
                                    // backgroundColor: ,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    width: 150,
                                    color: Colors.blueGrey.shade700,
                                    child: const Text(
                                      'Thay Đổi Ảnh',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Vollkorn',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _userNameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.userTie),
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 25, 20, 15),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _phoneNumberController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.phone),
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 25, 20, 15),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundeButton(
                      onPressed: updateProfile,
                      color: Colors.blueGrey,
                      title: 'CẬP NHẬT THÔNG TIN',
                    ),
                  ],
                ),
              ),
            ))
// Add new product
        );
  }

  uploadImage() async {
    final imagePicker = ImagePicker();
    XFile? image;
    await Permission.photos.status;
    var permissionStatus = await Permission.photos.status;
    print(permissionStatus);
    // if (permissionStatus.isGranted) {
    image = await imagePicker.pickImage(source: ImageSource.gallery);
    var file = File(image!.path);
    if (image != null) {
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child('avatar/${image.path.split('/').last}')
          .putFile(file)
          .whenComplete(() => print('success'));
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        avatarImage = downloadUrl;
      });
    } else {
      print('No image path received');
    }
    // } else {
    //   print('Permission not granted. Try again with permission access');
    // }
  }
}
