import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class addCity_Screen extends StatefulWidget {
  const addCity_Screen({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
    );
  }

  static const String id = 'addimg';

  @override
  State<addCity_Screen> createState() => _addCity_ScreenState();
}

class _addCity_ScreenState extends State<addCity_Screen> {
  final _auth = FirebaseAuth.instance;
  String? imageCityUrl;
  String? nameCity;

  final _formKey = GlobalKey<FormState>();
  final nameHotelEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print('User: $user');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final name_Hotel = TextFormField(
        controller: nameHotelEditingController,
        validator: (value) =>
            ((value?.length ?? 0) < 5 ? 'At least 5 characters.' : null),
        keyboardType: TextInputType.text,
        onChanged: (value) {
          nameCity = value.toString();
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(FontAwesomeIcons.hotel),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
          hintText: "Tên thành phố",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final addButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.black54,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          add_Hotel();
        },
        child: const Text(
          "ĐĂNG THÀNH PHỐ",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 70),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  (imageCityUrl != null)
                      ? Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 1,
                                  blurRadius: 0.5,
                                  color: Colors.black.withOpacity(0.1),
                                )
                              ],
                              borderRadius: BorderRadius.circular(30),
                              image: DecorationImage(
                                image: NetworkImage(imageCityUrl!),
                                fit: BoxFit.cover,
                              )),
                        )
                      : GestureDetector(
                          onTap: uploadImage,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(30),
                                image: DecorationImage(
                                  image: AssetImage(
                                      'lib/asset/add_image/img_1.png'),
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                  const SizedBox(height: 15),
                  name_Hotel,
                  const SizedBox(height: 15),
                  addButton,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void add_Hotel() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      _firestore.collection('allCity').add({
        'imageUrl': imageCityUrl,
        'nameCity': nameCity,
      });
      Navigator.pop(context);
      EasyLoading.showSuccess(
        'Đăng thành công',
        duration: Duration(milliseconds: 1300),
        maskType: EasyLoadingMaskType.black,
      );
    } else {
      EasyLoading.showError('Đăng thành phố không thành công !');
    }
  }

  uploadImage() async {
    final imagePicker = ImagePicker();
    PickedFile? image;
    UploadTask uploadTask;
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    // if (permissionStatus.isGranted) {
    image = await imagePicker.getImage(source: ImageSource.gallery);
    var file = File(image!.path);
    if (image != null) {
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child('imageCity/${image.path.split('/').last}')
          .putFile(file)
          .whenComplete(() => print('success'));
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageCityUrl = downloadUrl;
      });
    } else {
      print('No image path received');
    }
    // } else {
    //   print('Permission not granted. Try again with permission access');
    // }
  }
}
