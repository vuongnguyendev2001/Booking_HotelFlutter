import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../component/button.dart';
import '../component/contrast.dart';
import '../model/user_model.dart';
import '../screens/login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
  static const String id = 'register';
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? imageUrl;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final avatarImageEdittingConller = new TextEditingController();
  final fullNameEdittingController = new TextEditingController();
  final emailEdittingController = new TextEditingController();
  final passwordEdittingController = new TextEditingController();
  final confirmpasswordEdittingController = new TextEditingController();
  final phoneNumberEdittingController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final fullNameField = TextFormField(
      autofocus: false,
      controller: fullNameEdittingController,
      keyboardType: TextInputType.name,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("First Name cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid name(Min. 3 Character)");
        }
        return null;
      },
      onSaved: (value) {
        fullNameEdittingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: kTextFieldDecoration.copyWith(
        prefixIcon: Icon(
          Icons.person,
          color: Colors.white,
          size: 27,
        ),
        hintText: "Tên đầy đủ...",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final phoneNumberField = TextFormField(
      autofocus: false,
      controller: phoneNumberEdittingController,
      keyboardType: TextInputType.number,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("First Name cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid name(Min. 3 Character)");
        }
        return null;
      },
      onSaved: (value) {
        phoneNumberEdittingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: kTextFieldDecoration.copyWith(
        prefixIcon: Icon(
          Icons.phone,
          color: Colors.white,
          size: 27,
        ),
        hintText: "Số điện thoại",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEdittingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailEdittingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      decoration: kTextFieldDecoration.copyWith(
        prefixIcon: Icon(
          Icons.email,
          color: Colors.white,
        ),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEdittingController,
      obscureText: true,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
      },
      onSaved: (value) {
        passwordEdittingController.text = value!;
      },
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      textInputAction: TextInputAction.next,
      decoration: kTextFieldDecoration.copyWith(
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.white,
        ),
        hintText: "Mật khẩu",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final confirmpasswordField = TextFormField(
      autofocus: false,
      controller: confirmpasswordEdittingController,
      obscureText: true,
      validator: (value) {
        if (passwordEdittingController.text !=
            confirmpasswordEdittingController.text) {
          return "Password don't match";
        }
        return null;
      },
      onSaved: (value) {
        confirmpasswordEdittingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      decoration: kTextFieldDecoration.copyWith(
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.white,
        ),
        hintText: "Nhập lại mật khẩu",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final signButton = RoundeButton(
        title: 'ĐĂNG KÝ',
        color: Colors.white54,
        onPressed: () {
          signUp(emailEdittingController.text, passwordEdittingController.text);
          EasyLoading.showSuccess(
            'Đăng ký thành công!',
            duration: Duration(milliseconds: 1300),
            maskType: EasyLoadingMaskType.black,
          );
        });
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage(
              'lib/asset/images_welcome/img_6.png',
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
          )),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.width * 0.1,
                ),
                imageUrl != null
                    ? Center(
                        child: CircleAvatar(
                          radius: size.width * 0.14,
                          backgroundColor: Colors.white38,
                          backgroundImage: NetworkImage(imageUrl!),
                        ),
                      )
                    : Center(
                        child: CircleAvatar(
                          radius: size.width * 0.14,
                          backgroundColor: Colors.white38,
                          backgroundImage:
                              AssetImage('lib/asset/avatar/img_1.png'),
                          child: Container(
                            height: 115,
                            width: 115,
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: upLoadImage,
                              child: CircleAvatar(
                                backgroundColor: Colors.blueGrey,
                                child: Icon(
                                  Icons.edit,
                                  size: 30,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  height: size.width * 0.1,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(36.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            fullNameField,
                            SizedBox(
                              height: 15,
                            ),
                            phoneNumberField,
                            SizedBox(
                              height: 15,
                            ),
                            emailField,
                            SizedBox(
                              height: 15,
                            ),
                            passwordField,
                            SizedBox(
                              height: 15,
                            ),
                            confirmpasswordField,
                            SizedBox(
                              height: 15,
                            ),
                            signButton,
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                postDetailsToFirestore(),
              })
          .catchError((e) {});
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();
    userModel.email = user!.email!;
    userModel.uid = user.uid;
    userModel.userName = fullNameEdittingController.text;
    userModel.phoneNumber = phoneNumberEdittingController.text;
    userModel.avatar = imageUrl;
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
      'Đăng ký thành công !',
      style: TextStyle(fontSize: 19),
    )));
    Navigator.pushNamed(context, Login.id);
  }

  upLoadImage() async {
    final imagePicker = ImagePicker(); // lay hinh anh
    PickedFile? image;
    await Permission.photos.request(); // xin cap quyen
    var permissionStatus = await Permission.photos.status;
    // if(permissionStatus.isGranted){ // duoc cap quyen
    image = await imagePicker.getImage(source: ImageSource.gallery); // lay anh
    var file = File(image!.path);
    if (image != null) {
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child('avatarImage/${image.path.split('/').last}')
          .putFile(file)
          .whenComplete(() => print('succeed'));
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
      });
    } else {
      print('No image path received');
    }
    // } else {
    //   print('Permission not granted. Try again with permission access');
    //   }
  }
}
