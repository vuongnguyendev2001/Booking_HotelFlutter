// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_booking/model/user_model.dart';
import 'package:app_booking/services/profile_management/editprofile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListUserScreen extends StatefulWidget {
  static const String id = 'list-user-screen';
  const ListUserScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ListUserScreen> createState() => _ListUserScreenState();
}

class _ListUserScreenState extends State<ListUserScreen> {
  var searchText = '';
  Map<String, dynamic>? userMap;
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel loggedInUser = UserModel();
  final messsageTextController = TextEditingController();
  String? messageText;
  String? imageUrl;

  final CollectionReference _allUser =
      FirebaseFirestore.instance.collection('users');
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void setStatus(String status) async {
    await _allUser.doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  void getCurrentUser() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue.shade800,
        title: const Text('Danh sách người dùng'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                top: 10,
              ),
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm người dùng',
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (val) => setState(() {
                    searchText = val;
                  }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.8,
                child: StreamBuilder(
                    stream: _allUser
                        .where("email", isGreaterThanOrEqualTo: searchText)
                        .where("email", isLessThan: searchText + 'z')
                        .orderBy("email")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Something went wrong"),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Text("Loading"),
                        );
                      }
                      ;
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                                snapshot.data!.docs[index];
                            return loggedInUser.email !=
                                    documentSnapshot['email']
                                ? GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      Future.delayed(
                                        const Duration(seconds: 2),
                                      );

                                      setState(() {
                                        isLoading = false;
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editProfile_Screen(
                                                      currentUserId:
                                                          documentSnapshot
                                                              .id)));
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 78,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                documentSnapshot[
                                                                        'avatar'] ??
                                                                    ''))),
                                                  ),
                                                  const SizedBox(
                                                    height: 18,
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    documentSnapshot[
                                                            'userName'] ??
                                                        '',
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    documentSnapshot['email'] ??
                                                        '',
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container();
                          });
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
