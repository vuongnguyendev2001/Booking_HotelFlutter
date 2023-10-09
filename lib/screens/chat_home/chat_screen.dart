import 'dart:io';
import 'package:app_booking/component/contrast.dart';
import 'package:app_booking/model/user_model.dart';
import 'package:line_icons/line_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:permission_handler/permission_handler.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class Chat extends StatefulWidget {
  static const String id = 'chat';
  Chat({Key? key, required this.documentSnapshot, required this.chatRoomId})
      : super(key: key);
  DocumentSnapshot documentSnapshot;
  final String chatRoomId;
  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final messsageTextController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  String? messageText;
  String? imageUrl;
  DateTime? time;
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  CollectionReference room = FirebaseFirestore.instance.collection('messages');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leadingWidth: 45,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios),
          ),
        ),
        title: Row(
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(widget.documentSnapshot['avatar']),
                      fit: BoxFit.cover)),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.documentSnapshot['userName'],
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 3,
                ),
                // Text(
                //   widget.documentSnapshot['status'],
                //   style: TextStyle(
                //       fontSize: 14, color: Colors.black.withOpacity(0.4)),
                // ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          const Icon(
            LineIcons.phone,
            size: 35,
          ),
          const SizedBox(
            width: 10,
          ),
          const Icon(
            LineIcons.video,
            size: 35,
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            height: 12,
            width: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
        // backgroundColor: Colors.grey.withOpacity(0.05),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('messages')
                    .doc(widget.chatRoomId)
                    .collection('room')
                    .orderBy('timestamp')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final messages = snapshot.data!.docs.reversed;
                    List<MessageBubble> messageBubbles = [];
                    for (var message in messages) {
                      final messageText = message.get('text');
                      final messageSender = message.get('sender');
                      final currentUser = loggedInUser.userName;
                      final messageImage = message.get('url');
                      final Timestamp time = message.get('timestamp');
                      final messageBubble = MessageBubble(
                        sender: messageSender,
                        text: messageText,
                        isMe: currentUser == messageSender,
                        url: messageImage,
                        timestamp: time,
                      );
                      messageBubbles.add(messageBubble);
                    }
                    return Expanded(
                      child: ListView(
                        reverse: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20.0),
                        children: messageBubbles,
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }),
            // MessageStream(),
            Container(
              height: MediaQuery.of(context).size.width * 0.15,
              width: MediaQuery.of(context).size.width,
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messsageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        messsageTextController.clear();
                        imageUrl = null;
                        _firestore
                            .collection('messages')
                            .doc(widget.chatRoomId)
                            .collection('room')
                            .add({
                          'text': messageText,
                          'sender': loggedInUser.userName,
                          'timestamp': DateTime.now(),
                          'url': imageUrl,
                        });
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.blue,
                        size: 30,
                      )),
                  const SizedBox(
                    width: 5,
                  ),
                  IconButton(
                      onPressed: uploadImage,
                      icon: const Icon(
                        LineIcons.image,
                        size: 30,
                        color: Colors.blue,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  uploadImage() async {
    final imagePicker = ImagePicker();
    XFile? image;
    XFile? uploadTask;
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    print(permissionStatus);
    // if (permissionStatus.isGranted) {
    image = await imagePicker.pickImage(source: ImageSource.gallery);
    var file = File(image!.path);
    if (image != null) {
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child('images/${image.path.split('/').last}')
          .putFile(file)
          .whenComplete(() => print('success'));
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
      });
      _firestore
          .collection('messages')
          .doc(widget.chatRoomId)
          .collection('room')
          .add({
        'text': '',
        'sender': loggedInUser.userName,
        'timestamp': DateTime.now(),
        'url': imageUrl
      });
    } else {
      print('No image path received');
    }
    // } else {
    //   print('Permission not granted. Try again with permission access');
    // }
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    this.sender,
    this.text,
    this.isMe,
    this.url,
    this.timestamp,
  }) : super(key: key);
  final String? sender;
  final String? text;
  final Timestamp? timestamp;
  final bool? isMe;
  final String? url;
  String formattedDatebook(timeStamp) {
    var dateFormTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('hh:mm a').format(dateFormTimeStamp);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 3.0,
      ),
      child: Column(
        crossAxisAlignment:
            isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender!,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          url == null
              ? Row(
                  mainAxisAlignment:
                      isMe! ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: isMe!
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Material(
                          borderRadius: isMe!
                              ? const BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0))
                              : const BorderRadius.only(
                                  bottomRight: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                ),
                          elevation: 5.0,
                          color: isMe! ? Colors.blueGrey : Colors.white,
                          child: Container(
                            constraints: const BoxConstraints(
                              maxWidth: 300,
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              text!,
                              style: TextStyle(
                                  color: isMe! ? Colors.white : Colors.black54,
                                  fontSize: 15.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, top: 2),
                          child: Text(
                            formattedDatebook(timestamp),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment:
                      isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.9,
                      height: 180,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 1,
                              blurRadius: 0.5,
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(30),
                          image: DecorationImage(
                            image: NetworkImage(url!),
                            fit: BoxFit.cover,
                          )),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, right: 8, top: 2),
                      child: Text(
                        formattedDatebook(timestamp),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
