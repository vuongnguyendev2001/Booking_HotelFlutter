import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class edifamousHotel_Screen extends StatefulWidget {
  edifamousHotel_Screen(this.documentSnapshot, {Key? key}) : super(key: key);
  DocumentSnapshot? documentSnapshot;
  @override
  State<edifamousHotel_Screen> createState() => _edifamousHotel_ScreenState();
}

class _edifamousHotel_ScreenState extends State<edifamousHotel_Screen> {
  final TextEditingController _imageUrlEdittingController =
      TextEditingController();
  final TextEditingController _nameHotelEdittingController =
      TextEditingController();
  final TextEditingController _priceEdittingController =
      TextEditingController();
  final TextEditingController _cityNameEdittingController =
      TextEditingController();
  final TextEditingController _checkInEdittingController =
      TextEditingController();
  final TextEditingController _checkOutEdittingController =
      TextEditingController();
  final TextEditingController _addressEdittingController =
      TextEditingController();
  final TextEditingController _descriptionEdittingController =
      TextEditingController();
  final CollectionReference _famousHotel =
      FirebaseFirestore.instance.collection('famousHotelAll');
  String? imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _famousHotel.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> documentSnapshot) {
          // DocumentSnapshot document = snapshot.data!.docs[index];
          if (documentSnapshot.hasData) {
            _imageUrlEdittingController.text =
                widget.documentSnapshot!['imageUrl'];
            _nameHotelEdittingController.text =
                widget.documentSnapshot!['nameHotel'];
            _priceEdittingController.text = widget.documentSnapshot!['price'];
            _cityNameEdittingController.text =
                widget.documentSnapshot!['nameCity'];
            _checkInEdittingController.text =
                widget.documentSnapshot!['checkIn'];
            _checkOutEdittingController.text =
                widget.documentSnapshot!['checkOut'];
            _addressEdittingController.text =
                widget.documentSnapshot!['address'];
            _descriptionEdittingController.text =
                widget.documentSnapshot!['description'];
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    imageUrl == null
                        ? GestureDetector(
                            onTap: uploadImage,
                            child: Container(
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
                                    image: NetworkImage(
                                        widget.documentSnapshot!['imageUrl']),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(30),
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl!),
                                  fit: BoxFit.cover,
                                )),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _nameHotelEdittingController,
                      decoration: const InputDecoration(
                        labelText: 'Tên khách sạn',
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      // keyboardType:
                      // const TextInputType.numberWithOptions(decimal: true),
                      controller: _priceEdittingController,
                      decoration: const InputDecoration(
                        labelText: 'Giá khách sạn',
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      // keyboardType:
                      // const TextInputType.numberWithOptions(decimal: true),
                      controller: _cityNameEdittingController,
                      decoration: const InputDecoration(
                        labelText: 'Tên thành phố',
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      // keyboardType:
                      // const TextInputType.numberWithOptions(decimal: true),
                      controller: _checkInEdittingController,
                      decoration: const InputDecoration(
                        labelText: 'Thời gian nhận phòng',
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      // keyboardType:
                      // const TextInputType.numberWithOptions(decimal: true),
                      controller: _checkOutEdittingController,
                      decoration: const InputDecoration(
                        labelText: 'Thời gian trả phòng',
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      // keyboardType:
                      // const TextInputType.numberWithOptions(decimal: true),
                      controller: _addressEdittingController,
                      decoration: const InputDecoration(
                        labelText: 'Địa chỉ khách sạn',
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      maxLines: 3,
                      // keyboardType:
                      // const TextInputType.numberWithOptions(decimal: true),
                      controller: _descriptionEdittingController,
                      decoration: const InputDecoration(
                        labelText: 'Mô tả',
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 20, 20, 15),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: MaterialButton(
                          height: 50,
                          minWidth: 300,
                          hoverColor: Colors.blueGrey,
                          color: Colors.grey,
                          child: const Text(
                            'CẬP NHẬT KHÁCH SẠN',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                          ),
                          onPressed: () async {
                            final String _imageUrl =
                                _imageUrlEdittingController.text;
                            final String _nameHotel =
                                _nameHotelEdittingController.text;
                            final String _price = _priceEdittingController.text;
                            final String _cityName =
                                _cityNameEdittingController.text;
                            final String _checkIn =
                                _checkInEdittingController.text;
                            final String _checkOut =
                                _checkOutEdittingController.text;
                            final String _address =
                                _addressEdittingController.text;
                            final String _description =
                                _descriptionEdittingController.text;
                            if (imageUrl != null) {
                              await _famousHotel
                                  .doc(widget.documentSnapshot!.id)
                                  .update({
                                "imageUrl": imageUrl,
                                "nameHotel": _nameHotel,
                                "price": _price,
                                "nameCity": _cityName,
                                "checkIn": _checkIn,
                                "checkOut": _checkOut,
                                "address": _address,
                                "description": _description,
                              });
                              Navigator.of(context).pop();
                              EasyLoading.showSuccess(
                                'Cập nhật thành công!',
                                duration: Duration(milliseconds: 1300),
                                maskType: EasyLoadingMaskType.black,
                              );
                            } else {
                              await widget.documentSnapshot!.reference.update({
                                "imageUrl":
                                    widget.documentSnapshot!['imageUrl'],
                                "nameHotel": _nameHotel,
                                "price": _price,
                                "nameCity": _cityName,
                                "checkIn": _checkIn,
                                "checkOut": _checkOut,
                                "address": _address,
                                "description": _description,
                              });
                              Navigator.of(context).pop();
                              EasyLoading.showSuccess(
                                'Cập nhật thành công',
                                duration: Duration(milliseconds: 1300),
                                maskType: EasyLoadingMaskType.black,
                              );
                            }
                            print(widget.documentSnapshot!.id);
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return Center(child: Text('Erorr'));
        },
      ),
    );
  }

  uploadImage() async {
    final imagePicker = ImagePicker();
    PickedFile? image;
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    // if (permissionStatus.isGranted) {
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
