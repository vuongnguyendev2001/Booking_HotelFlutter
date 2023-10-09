import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditTicketScreen extends StatefulWidget {
  EditTicketScreen(this.documentSnapshot, {Key? key}) : super(key: key);
  DocumentSnapshot? documentSnapshot;
  @override
  State<EditTicketScreen> createState() => _EditTicketScreenState();
}

class _EditTicketScreenState extends State<EditTicketScreen> {
  // final _auth = FirebaseAuth.instance;
  String? imageHotelUrl;
  String? nameTicket, nameCity, description;
  int? price;
  final _formKey = GlobalKey<FormState>();
  final _imageUrlEdittingController = TextEditingController();
  final nameTicketEditingController = TextEditingController();
  final nameCityEditingController = TextEditingController();
  final descriptionEditingController = TextEditingController();
  final priceEditingController = TextEditingController();
  bool? _isLoading = false;
  Future showDeleteTicket() async {
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
    nameTicketEditingController.text = widget.documentSnapshot!['nameTicket'];
    priceEditingController.text = widget.documentSnapshot!['price'].toString();
    nameCityEditingController.text = widget.documentSnapshot!['nameCity'];
    descriptionEditingController.text = widget.documentSnapshot!['description'];
    return Scaffold(
      key: _formKey,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: 30,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
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
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: nameTicketEditingController,
                decoration: const InputDecoration(
                  labelText: 'Tên vé tham quan',
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: priceEditingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Giá vé tham quan',
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                // keyboardType:
                // const TextInputType.numberWithOptions(decimal: true),
                controller: nameCityEditingController,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ',
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                maxLines: 13,
                // keyboardType:
                // const TextInputType.numberWithOptions(decimal: true),
                controller: descriptionEditingController,
                decoration: const InputDecoration(
                  labelText: 'Mô tả vé tham quan',
                  contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
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
                        'CẬP NHẬT VÉ THAM QUAN',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                      onPressed: () async {
                        final String _imageUrl =
                            _imageUrlEdittingController.text;
                        final String _nameTicket =
                            nameTicketEditingController.text;
                        final int _priceTicket =
                            int.parse(priceEditingController.text);
                        final String _cityName = nameCityEditingController.text;

                        final String _description =
                            descriptionEditingController.text;
                        if (imageHotelUrl != null) {
                          await widget.documentSnapshot!.reference.update({
                            "imageUrl": imageHotelUrl,
                            "nameTicket": _nameTicket,
                            "price": _priceTicket,
                            "nameCity": _cityName,
                            "description": _description,
                          });
                          Navigator.of(context).pop();
                          EasyLoading.showSuccess(
                            'Cập nhật thành công!',
                            duration: const Duration(milliseconds: 1300),
                            maskType: EasyLoadingMaskType.black,
                          );
                        } else {
                          await widget.documentSnapshot!.reference.update({
                            "imageUrl": widget.documentSnapshot!['imageUrl'],
                            "nameTicket": _nameTicket,
                            "price": _priceTicket,
                            "nameCity": _cityName,
                            "description": _description,
                          });
                          Navigator.of(context).pop();
                          EasyLoading.showSuccess(
                            'Cập nhật thành công!',
                            duration: const Duration(milliseconds: 1300),
                            maskType: EasyLoadingMaskType.black,
                          );
                        }
                        print(widget.documentSnapshot!.id);
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDeleteTicket();
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
    // } else {
    //   print('Permission not granted. Try again with permission access');
    // }
  }
}
