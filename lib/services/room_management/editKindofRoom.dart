import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class editKindofRoom extends StatefulWidget {
  const editKindofRoom({Key? key, required this.documentSnapshot})
      : super(key: key);
  final DocumentSnapshot documentSnapshot;
  @override
  State<editKindofRoom> createState() => _editKindofRoomState();
}

class _editKindofRoomState extends State<editKindofRoom> {
  final TextEditingController _imageRoomEdittingController =
      TextEditingController();
  final TextEditingController _nameRoomEdittingController =
      TextEditingController();
  final TextEditingController _bedRoomRoomEdittingController =
      TextEditingController();
  final TextEditingController _areaRoomEdittingController =
      TextEditingController();
  final TextEditingController _sizeRoomEdittingController =
      TextEditingController();
  final TextEditingController _descriptionRoomEdittingController =
      TextEditingController();
  final TextEditingController _priceRoomEdittingController =
      TextEditingController();
  String? imageRoom;
  int? price;
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
        imageRoom = downloadUrl;
      });
    } else {
      print('No image path received');
    }
    // } else {
    //   print('Permission not granted. Try again with permission access');
    // }
  }

  bool? _isLoading = false;
  Future showDeleteRoom() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Xóa'),
        content: const Text('Bạn có chắc chắn xóa ?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Quay lại'),
          ),
          TextButton(
            onPressed: () async {
              try {
                setState(() {
                  _isLoading = true;
                  EasyLoading.show(status: 'Đang xử lý');
                });
                // await sendEmailCancelOrderTicket();
                await widget.documentSnapshot!.reference.delete();

                setState(() {
                  _isLoading = false;
                  EasyLoading.dismiss();
                });
                Navigator.pop(context);
                Navigator.pop(context);
                EasyLoading.showSuccess(
                  'Xóa thành công!',
                  duration: const Duration(milliseconds: 1300),
                  maskType: EasyLoadingMaskType.black,
                );
              } catch (error) {
                print(error);
              }
            },
            child: const Text('Đồng ý'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _imageRoomEdittingController.text = widget.documentSnapshot['imageRoom'];
    _nameRoomEdittingController.text = widget.documentSnapshot['nameRoom'];
    _bedRoomRoomEdittingController.text = widget.documentSnapshot['bedroom'];
    _sizeRoomEdittingController.text = widget.documentSnapshot['size'];
    _areaRoomEdittingController.text = widget.documentSnapshot['area'];
    _descriptionRoomEdittingController.text =
        widget.documentSnapshot['description'];
    _priceRoomEdittingController.text =
        widget.documentSnapshot['price'].toString();
    return Scaffold(
      body: SingleChildScrollView(
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
              imageRoom == null
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
                                  widget.documentSnapshot['imageRoom']),
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
                            image: NetworkImage(imageRoom!),
                            fit: BoxFit.cover,
                          )),
                    ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _nameRoomEdittingController,
                decoration: const InputDecoration(
                  labelText: 'Tên loại phòng',
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                // keyboardType:
                // const TextInputType.numberWithOptions(decimal: true),
                controller: _bedRoomRoomEdittingController,
                decoration: const InputDecoration(
                  labelText: 'Số lượng giường',
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                // keyboardType:
                // const TextInputType.numberWithOptions(decimal: true),
                controller: _areaRoomEdittingController,
                decoration: const InputDecoration(
                  labelText: 'Diện tích phòng',
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                keyboardType: TextInputType.number,
                // const TextInputType.numberWithOptions(decimal: true),
                controller: _sizeRoomEdittingController,
                decoration: const InputDecoration(
                  labelText: 'Số lượng người ',
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                // keyboardType:
                // const TextInputType.numberWithOptions(decimal: true),
                controller: _descriptionRoomEdittingController,
                decoration: const InputDecoration(
                  labelText: 'Mô tả',
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _priceRoomEdittingController,
                keyboardType: TextInputType.number,
                // const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Giá phòng',
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
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
                        final String _nameRoom =
                            _nameRoomEdittingController.text;
                        final String _bedRoom =
                            _bedRoomRoomEdittingController.text;
                        final String _areRoom =
                            _areaRoomEdittingController.text;
                        final String _sizeRoom =
                            _sizeRoomEdittingController.text;
                        final String _description =
                            _descriptionRoomEdittingController.text;
                        final int _priceRoom =
                            int.parse(_priceRoomEdittingController.text);
                        if (imageRoom != null) {
                          await widget.documentSnapshot.reference.update({
                            "imageRoom": imageRoom,
                            "nameRoom": _nameRoom,
                            "bedroom": _bedRoom,
                            "area": _areRoom,
                            "size": _sizeRoom,
                            "description": _description,
                            "price": _priceRoom,
                          });
                          Navigator.of(context).pop();
                          EasyLoading.showSuccess(
                            'Cập nhật thành công!',
                            duration: const Duration(milliseconds: 1300),
                            maskType: EasyLoadingMaskType.black,
                          );
                        } else {
                          await widget.documentSnapshot.reference.update({
                            "imageRoom": widget.documentSnapshot['imageRoom'],
                            "nameRoom": _nameRoom,
                            "bedroom": _bedRoom,
                            "area": _areRoom,
                            "size": _sizeRoom,
                            "description": _description,
                            "price": _priceRoom,
                          });
                          Navigator.of(context).pop();
                          EasyLoading.showSuccess(
                            'Cập nhật thành công!',
                            duration: const Duration(milliseconds: 1300),
                            maskType: EasyLoadingMaskType.black,
                          );
                        }
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDeleteRoom();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.12,
                      height: MediaQuery.of(context).size.width * 0.12,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(FontAwesomeIcons.trash),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
