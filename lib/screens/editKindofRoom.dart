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
  TextEditingController _imageRoomEdittingController = TextEditingController();
  TextEditingController _nameRoomEdittingController = TextEditingController();
  TextEditingController _bedRoomRoomEdittingController =
      TextEditingController();
  TextEditingController _areaRoomEdittingController = TextEditingController();
  TextEditingController _sizeRoomEdittingController = TextEditingController();
  TextEditingController _descriptionRoomEdittingController =
      TextEditingController();
  TextEditingController _priceRoomEdittingController = TextEditingController();
  String? imageRoom;
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

  @override
  Widget build(BuildContext context) {
    _imageRoomEdittingController.text = widget.documentSnapshot['imageRoom'];
    _nameRoomEdittingController.text = widget.documentSnapshot['nameRoom'];
    _bedRoomRoomEdittingController.text = widget.documentSnapshot['bedroom'];
    _sizeRoomEdittingController.text = widget.documentSnapshot['size'];
    _areaRoomEdittingController.text = widget.documentSnapshot['area'];
    _descriptionRoomEdittingController.text =
        widget.documentSnapshot['description'];
    _priceRoomEdittingController.text = widget.documentSnapshot['price'];
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
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _nameRoomEdittingController,
                decoration: const InputDecoration(
                  labelText: 'Tên loại phòng',
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                // keyboardType:
                // const TextInputType.numberWithOptions(decimal: true),
                controller: _bedRoomRoomEdittingController,
                decoration: const InputDecoration(
                  labelText: 'Số lượng giường',
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                // keyboardType:
                // const TextInputType.numberWithOptions(decimal: true),
                controller: _areaRoomEdittingController,
                decoration: const InputDecoration(
                  labelText: 'Diện tích phòng',
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                // keyboardType:
                // const TextInputType.numberWithOptions(decimal: true),
                controller: _sizeRoomEdittingController,
                decoration: const InputDecoration(
                  labelText: 'Số lượng người ',
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                // keyboardType:
                // const TextInputType.numberWithOptions(decimal: true),
                controller: _descriptionRoomEdittingController,
                decoration: const InputDecoration(
                  labelText: 'Mô tả',
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                // keyboardType:
                // const TextInputType.numberWithOptions(decimal: true),
                controller: _priceRoomEdittingController,
                decoration: const InputDecoration(
                  labelText: 'Giá phòng',
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 20,
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
                        final String _imageRoom =
                            _imageRoomEdittingController.text;
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
                        final String _priceRoom =
                            _priceRoomEdittingController.text;
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
                            duration: Duration(milliseconds: 1300),
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
                            duration: Duration(milliseconds: 1300),
                            maskType: EasyLoadingMaskType.black,
                          );
                        }
                        print(widget.documentSnapshot.id);
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.documentSnapshot.reference.delete();
                      Navigator.of(context).pop();
                      EasyLoading.showSuccess(
                        'Xóa thành công!',
                        duration: const Duration(milliseconds: 1300),
                        maskType: EasyLoadingMaskType.black,
                      );
                      // showDialog(
                      //     context: context,
                      //     builder: (context){
                      //       return CupertinoAlertDialog(
                      //         // backgroundColor: Colors.grey.shade100,
                      //         // title: Text('Thông báo'),
                      //         content: Text('Bạn chắc chắn xóa chứ ?', style: TextStyle(
                      //           fontSize: 18,
                      //         ),),
                      //         actions: [
                      //           MaterialButton(
                      //             onPressed:() {
                      //               Navigator.of(context).pop();
                      //             },
                      //             child: Text('Hủy'),
                      //           ),
                      //           MaterialButton(
                      //             onPressed:() {
                      //               widget.documentSnapshot!.reference.delete();
                      //               Navigator.of(context).pop();
                      //               EasyLoading.showSuccess('Xóa thành công!',
                      //                 duration: const Duration(milliseconds: 1300),
                      //                 maskType: EasyLoadingMaskType.black,
                      //               );
                      //             },
                      //             child: Text('Đồng ý'),
                      //           ),
                      //         ],
                      //       );
                      //     }
                      // );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.12,
                      height: MediaQuery.of(context).size.width * 0.12,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(FontAwesomeIcons.trash),
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
