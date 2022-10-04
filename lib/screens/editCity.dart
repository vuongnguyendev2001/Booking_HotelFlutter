import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_auth/firebase_auth.dart';
class editCity_Screen extends StatefulWidget {
  editCity_Screen(this.documentSnapshot, {Key? key}) : super(key: key);
  DocumentSnapshot? documentSnapshot;
  @override
  State<editCity_Screen> createState() => _editCity_ScreenState();
}
class _editCity_ScreenState extends State<editCity_Screen> {
  final TextEditingController _imageUrlEdittingController = TextEditingController();
  final TextEditingController _nameCityEdittingController = TextEditingController();
  final CollectionReference _allCity = FirebaseFirestore.instance.collection('allCity');
  String? imageCityUrl;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  void initState() {
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
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
    return Scaffold(
      body: StreamBuilder(
        stream: _allCity.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> documentSnapshot){
          // DocumentSnapshot document = snapshot.data!.docs[index];
          if(documentSnapshot.hasData){
            _imageUrlEdittingController.text = widget.documentSnapshot!['imageUrl'];
            _nameCityEdittingController.text = widget.documentSnapshot!['nameCity'];
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
                    imageCityUrl == null ?
                    GestureDetector(
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
                              image: NetworkImage(widget.documentSnapshot!['imageUrl']),
                              fit: BoxFit.cover,
                            )
                        ),
                      ),
                    ) :
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(30),
                          image: DecorationImage(
                            image: NetworkImage(imageCityUrl!),
                            fit: BoxFit.cover,
                          )
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextField(
                      controller: _nameCityEdittingController,
                      decoration: const InputDecoration(
                        labelText: 'Tên khách sạn',
                        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        border: OutlineInputBorder(
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: MaterialButton(
                          height: 50,
                          minWidth: 300,
                          hoverColor: Colors.blueGrey,
                          color: Colors.grey,
                          child: const Text( 'CẬP NHẬT THÀNH PHỐ', style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20
                          ),),
                          onPressed: () async {
                            final String _imageUrl = _imageUrlEdittingController.text;
                            final String _nameCity = _nameCityEdittingController.text;
                            if (imageCityUrl != null) {
                              await widget.documentSnapshot!.reference
                                  .update({
                                "imageUrl": imageCityUrl,
                                "nameCity": _nameCity,
                              });
                              Navigator.of(context).pop();
                              EasyLoading.showSuccess('Cập nhật thành công!',
                                duration: Duration(milliseconds: 1300),
                                maskType: EasyLoadingMaskType.black,
                              );
                            }
                            else{
                              await
                              widget.documentSnapshot!.reference
                                  .update({
                                "imageUrl": widget.documentSnapshot!['imageUrl'],
                                "nameCity": _nameCity,
                              });
                              Navigator.of(context).pop();
                              EasyLoading.showSuccess('Cập nhật thành công',
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
          imageCityUrl = downloadUrl;
        });
      } else {
        print('No image path received');
      }
    } else {
      print('Permission not granted. Try again with permission access');
    }
  }
}
