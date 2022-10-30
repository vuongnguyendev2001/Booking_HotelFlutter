import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class addKindofRoom extends StatefulWidget {
  const addKindofRoom(
      {Key? key,
      required this.documentSnapshot,
      required this.idHotel,
      required this.idCity})
      : super(key: key);
  final DocumentSnapshot documentSnapshot;
  final String idHotel;
  final String idCity;
  @override
  State<addKindofRoom> createState() => _addKindofRoomState();
}

late User loggedInUser;

class _addKindofRoomState extends State<addKindofRoom> {
  final _auth = FirebaseAuth.instance;
  String? imageRoom, nameRoom, bedroom, area, size, price, description;
  final _formKey = GlobalKey<FormState>();
  final nameRoomEditingController = new TextEditingController();
  final bedroomEditingController = new TextEditingController();
  final areaHotelEditingController = new TextEditingController();
  final sizeEditingController = new TextEditingController();
  final priceEditingController = new TextEditingController();
  final descriptionEditingController = new TextEditingController();

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
            .child('hotelImage/${image.path.split('/').last}')
            .putFile(file)
            .whenComplete(() => print('success'));
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageRoom = downloadUrl;
        });
      } else {
        print('No image path received');
      }
    } else {
      print('Permission not granted. Try again with permission access');
    }
  }

  void add_Room() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      FirebaseFirestore.instance
          .collection('allCity')
          .doc(widget.idCity)
          .collection("allHotel")
          .doc(widget.idHotel)
          .collection("Kindofroom")
          .add({
        'imageRoom': imageRoom,
        'nameRoom': nameRoom,
        'price': price,
        'bedroom': bedroom,
        'area': area,
        'size': size,
        'description': description,
      });
      EasyLoading.showSuccess(
        'Đăng thành công',
        duration: Duration(milliseconds: 1300),
        maskType: EasyLoadingMaskType.black,
      );
      Navigator.of(context).pop();
    } else {
      EasyLoading.showError('Đăng không thành công !');
    }
  }

  @override
  Widget build(BuildContext context) {
    final name_Room = TextFormField(
        controller: nameRoomEditingController,
        validator: (value) =>
            ((value?.length ?? 0) < 5 ? 'At least 5 characters.' : null),
        keyboardType: TextInputType.text,
        onChanged: (value) {
          nameRoom = value.toString();
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(FontAwesomeIcons.hotel),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
          hintText: "Tên phòng",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final bed_room = TextFormField(
        controller: bedroomEditingController,
        validator: (value) =>
            ((value?.length ?? 0) < 5 ? 'At least 5 characters.' : null),
        keyboardType: TextInputType.text,
        onChanged: (value) {
          bedroom = value.toString();
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(FontAwesomeIcons.bed),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
          hintText: "Số lượng giường",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final are_room = TextFormField(
        controller: areaHotelEditingController,
        validator: (value) =>
            ((value?.length ?? 0) < 5 ? 'At least 5 characters.' : null),
        keyboardType: TextInputType.text,
        onChanged: (value) {
          area = value.toString();
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(FontAwesomeIcons.maximize),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
          hintText: "Diện tích",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final size_Room = TextFormField(
        controller: sizeEditingController,
        validator: (value) =>
            ((value?.length ?? 0) < 3 ? 'At least 5 characters.' : null),
        keyboardType: TextInputType.text,
        onChanged: (value) {
          size = value.toString();
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(FontAwesomeIcons.person),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
          hintText: "Số lượng người tối đa",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final description_Room = TextFormField(
        controller: descriptionEditingController,
        validator: (value) =>
            ((value?.length ?? 0) < 5 ? 'At least 5 characters.' : null),
        keyboardType: TextInputType.text,
        onChanged: (value) {
          description = value.toString();
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(FontAwesomeIcons.textSlash),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
          hintText: "Mô tả...",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final priceRoom = TextFormField(
        controller: priceEditingController,
        validator: (value) =>
            ((value?.length ?? 0) < 1 ? 'At least 5 characters.' : null),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          price = value;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(FontAwesomeIcons.moneyBill),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
          hintText: "Giá khách sạn",
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
          add_Room();
        },
        child: const Text(
          "THÊM LOẠI PHÒNG",
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
            padding: const EdgeInsets.only(left: 20, right: 20, top: 55),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  (imageRoom != null)
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
                                image: NetworkImage(imageRoom!),
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
                  name_Room,
                  const SizedBox(height: 15),
                  bed_room,
                  const SizedBox(height: 15),
                  are_room,
                  const SizedBox(height: 15),
                  size_Room,
                  const SizedBox(height: 15),
                  description_Room,
                  const SizedBox(height: 15),
                  priceRoom,
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
}
