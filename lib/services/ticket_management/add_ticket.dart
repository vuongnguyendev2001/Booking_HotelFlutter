// ignore_for_file: public_member_api_docs, sort_constructors_first
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

class AddTicketScreen extends StatefulWidget {
  DocumentSnapshot? documentSnapshot;
  AddTicketScreen({
    Key? key,
    this.documentSnapshot,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
    );
  }

  static const String id = 'addimg';

  @override
  State<AddTicketScreen> createState() => _AddTicketScreenState();
}

class _AddTicketScreenState extends State<AddTicketScreen> {
  final _auth = FirebaseAuth.instance;
  String? imageHotelUrl;
  String? nameTicket, nameCity, address, description;
  int? price;
  final _formKey = GlobalKey<FormState>();
  final nameTicketEditingController = TextEditingController();
  final nameCityEditingController = TextEditingController();
  final addressEditingController = TextEditingController();
  final DescriptionEditingController = TextEditingController();
  final priceEditingController = TextEditingController();

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
    final name_Ticket = TextFormField(
        controller: nameTicketEditingController,
        validator: (value) =>
            ((value?.length ?? 0) < 5 ? 'At least 5 characters.' : null),
        keyboardType: TextInputType.text,
        onChanged: (value) {
          nameTicket = value.toString();
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(FontAwesomeIcons.hotel),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
          hintText: "Tên vé tham quan",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final price_Ticket = TextFormField(
        controller: priceEditingController,
        validator: (value) =>
            ((value?.length ?? 0) < 1 ? 'At least 5 characters.' : null),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          price = int.parse(value);
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(FontAwesomeIcons.moneyBill),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
          hintText: "Giá vé tham quan",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final address_Ticket = TextFormField(
      controller: addressEditingController,
      validator: (value) =>
          ((value?.length ?? 0) < 5 ? 'At least 5 characters.' : null),
      keyboardType: TextInputType.text,
      onChanged: (value) {
        address = value.toString();
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(FontAwesomeIcons.city),
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
        hintText: "Địa chỉ",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final description_Ticket = TextFormField(
        maxLines: 10,
        controller: DescriptionEditingController,
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
    //add button
    final addButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.black54,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          addTicket();
        },
        child: const Text(
          "ĐĂNG VÉ THAM QUAN",
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
                  (imageHotelUrl != null)
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
                                image: NetworkImage(imageHotelUrl!),
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
                  name_Ticket,
                  const SizedBox(height: 15),
                  price_Ticket,
                  const SizedBox(height: 15),
                  address_Ticket,
                  const SizedBox(height: 15),
                  description_Ticket,
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

  void addTicket() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      _firestore
          .collection('allCity')
          .doc(widget.documentSnapshot!.id)
          .collection("allTicket")
          .add({
        'imageUrl': imageHotelUrl,
        'nameTicket': nameTicket,
        'price': price,
        'nameCity': address,
        'description': description,
      });
      EasyLoading.showSuccess(
        'Thêm thành công',
        duration: Duration(milliseconds: 1300),
        maskType: EasyLoadingMaskType.black,
      );
      Navigator.of(context).pop();
    } else {
      EasyLoading.showError('Đăng sản phẩm không thành công !');
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
          .child('ticketImage/${image.path.split('/').last}')
          .putFile(file)
          .whenComplete(() => print('success'));
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageHotelUrl = downloadUrl;
      });
    } else {
      print('No image path received');
    }
  }
}
