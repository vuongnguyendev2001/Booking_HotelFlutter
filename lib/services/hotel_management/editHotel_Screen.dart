import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditHotelScreen extends StatefulWidget {
  EditHotelScreen(this.documentSnapshot, {Key? key}) : super(key: key);
  DocumentSnapshot? documentSnapshot;
  @override
  State<EditHotelScreen> createState() => _EditHotelScreenState();
}

class _EditHotelScreenState extends State<EditHotelScreen> {
  final TextEditingController _imageUrlEdittingController =
      TextEditingController();
  final TextEditingController _nameHotelEdittingController =
      TextEditingController();
  final _priceHotelEdittingController = TextEditingController();
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
  String? imageHotelUrl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _cityNameEdittingController.text = widget.documentSnapshot!['nameCity'];
  }

  bool? _isLoading = false;
  Future showDeleteHotel() async {
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
    _imageUrlEdittingController.text = widget.documentSnapshot!['imageUrl'];
    _nameHotelEdittingController.text = widget.documentSnapshot!['nameHotel'];
    _priceHotelEdittingController.text =
        widget.documentSnapshot!['price'].toString();
    // _cityNameEdittingController.text = widget.documentSnapshot!['nameCity'];
    _checkInEdittingController.text = widget.documentSnapshot!['checkIn'];
    _checkOutEdittingController.text = widget.documentSnapshot!['checkOut'];
    _addressEdittingController.text = widget.documentSnapshot!['address'];
    _descriptionEdittingController.text =
        widget.documentSnapshot!['description'];
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
              imageHotelUrl == null
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
                            image: NetworkImage(imageHotelUrl!),
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
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _priceHotelEdittingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Giá khách sạn',
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: 15,
              ),
              // TextField(
              //   // keyboardType:
              //   // const TextInputType.numberWithOptions(decimal: true),
              //   controller: _cityNameEdittingController,
              //   decoration: const InputDecoration(
              //     labelText: 'Tên thành phố',
              //     contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              //     border: OutlineInputBorder(),
              //   ),
              //   textInputAction: TextInputAction.next,
              // ),
              // SizedBox(
              //   height: 15,
              // ),
              TextField(
                // keyboardType:
                // const TextInputType.numberWithOptions(decimal: true),
                controller: _checkInEdittingController,
                decoration: const InputDecoration(
                  labelText: 'Thời gian nhận phòng',
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
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
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
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
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
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
                  contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
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
                        final String _imageUrl =
                            _imageUrlEdittingController.text;
                        final String _nameHotel =
                            _nameHotelEdittingController.text;
                        final int _priceHotel =
                            int.parse(_priceHotelEdittingController.text);
                        // final String _cityName =
                        //     _cityNameEdittingController.text;
                        final String _checkIn = _checkInEdittingController.text;
                        final String _checkOut =
                            _checkOutEdittingController.text;
                        final String _address = _addressEdittingController.text;
                        final String _description =
                            _descriptionEdittingController.text;
                        if (imageHotelUrl != null) {
                          await widget.documentSnapshot!.reference.update({
                            "imageUrl": imageHotelUrl,
                            "nameHotel": _nameHotel,
                            "price": _priceHotel,
                            // "nameCity": _cityName,
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
                            "imageUrl": widget.documentSnapshot!['imageUrl'],
                            "nameHotel": _nameHotel,
                            "price": _priceHotel,
                            // "nameCity": _cityName,
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
                        }
                        print(widget.documentSnapshot!.id);
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDeleteHotel();
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
        imageHotelUrl = downloadUrl;
      });
    } else {
      print('No image path received');
    }
    // } else {
    //   print('Permission not granted. Try again with permission access');
    // }
  }
}
