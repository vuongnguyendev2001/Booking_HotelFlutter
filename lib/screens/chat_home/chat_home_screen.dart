import 'package:app_booking/model/user_model.dart';
import 'package:app_booking/screens/chat_home/chat_screen.dart';
import 'package:app_booking/screens/chat_home/widget/chat_home_shimmer.dart';
import 'package:app_booking/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'chat.dart';

class chatHomePage extends StatefulWidget {
  static const String id = 'id';
  const chatHomePage({Key? key}) : super(key: key);
  @override
  State<chatHomePage> createState() => _chatHomePageState();
}

class _chatHomePageState extends State<chatHomePage>
    with WidgetsBindingObserver {
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
    WidgetsBinding.instance.addObserver(this);
    setStatus("Đang hoạt động");
    getCurrentUser();
  }

  void setStatus(String status) async {
    await _allUser.doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //online
      setStatus("Đang hoạt động");
    } else {
      //offline
      setStatus("Vừa mới truy cập");
    }
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

  String chatRoomId(String user1, String user2) {
    var result = user1.compareTo(user2);
    if (result > 0) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  Widget build(BuildContext context) {
    String? avatar, userName, email;
    avatar = loggedInUser.avatar ?? '';
    print(loggedInUser.uid);
    userName = loggedInUser.userName ?? '';
    email = loggedInUser.email ?? '';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        elevation: 0,
        leadingWidth: 60,
        automaticallyImplyLeading: false,
        // leading: Padding(
        //     padding: const EdgeInsets.only(left: 20.0),
        //     child: InkWell(
        //       splashColor: Colors.grey,
        //       onTap: () => showModalBottomSheet(
        //           context: context,
        //           shape: const RoundedRectangleBorder(
        //               borderRadius:
        //                   BorderRadius.vertical(top: Radius.circular(15))),
        //           isScrollControlled: true,
        //           builder: (context) {
        //             return Container(
        //               // width: MediaQuery.of(context).size.width,
        //               // height: MediaQuery.of(context).size.height,
        //               decoration: const BoxDecoration(
        //                   color: Colors.white,
        //                   borderRadius: BorderRadius.only(
        //                     topRight: Radius.circular(15),
        //                     topLeft: Radius.circular(15),
        //                   )),
        //               child: Column(
        //                 mainAxisSize: MainAxisSize.min,
        //                 children: [
        //                   const SizedBox(
        //                     height: 20,
        //                   ),
        //                   Container(
        //                     height: 150,
        //                     width: 150,
        //                     decoration: BoxDecoration(
        //                         shape: BoxShape.circle,
        //                         image: DecorationImage(
        //                           image: NetworkImage(avatar ?? 'null'),
        //                         )),
        //                   ),
        //                   const SizedBox(
        //                     height: 15,
        //                   ),
        //                   Text(
        //                     userName ?? '',
        //                     style: const TextStyle(
        //                       fontSize: 25,
        //                     ),
        //                   ),
        //                   const SizedBox(
        //                     height: 30,
        //                   ),
        //                   Padding(
        //                     padding: const EdgeInsets.symmetric(horizontal: 15),
        //                     child: GestureDetector(
        //                       onTap: () {
        //                         //   Navigator.push(
        //                         //       context,
        //                         //       MaterialPageRoute(
        //                         //           builder: (context) =>
        //                         //               editProfile_Screen(
        //                         //                   currentUserId:
        //                         //                       loggedInUser.uid!)));
        //                       },
        //                       child: Container(
        //                         padding: const EdgeInsets.only(left: 10),
        //                         width: double.infinity,
        //                         alignment: Alignment.centerLeft,
        //                         height:
        //                             MediaQuery.of(context).size.height * 0.07,
        //                         decoration: BoxDecoration(
        //                             color: Colors.grey,
        //                             borderRadius: BorderRadius.circular(10)),
        //                         child: Row(
        //                           children: [
        //                             const Icon(Icons.account_circle,
        //                                 color: Colors.black, size: 30),
        //                             const SizedBox(
        //                               width: 10,
        //                             ),
        //                             const Text(
        //                               'Chỉnh sửa tài khoản',
        //                               style: TextStyle(fontSize: 20),
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                   const SizedBox(
        //                     height: 10,
        //                   ),
        //                   Padding(
        //                     padding: const EdgeInsets.symmetric(horizontal: 15),
        //                     child: GestureDetector(
        //                       onTap: () async {
        //                         final SharedPreferences preferences =
        //                             await SharedPreferences.getInstance();
        //                         preferences.remove('email');
        //                         // Navigator.pushNamed(context, Login.id);
        //                         setStatus("Vừa mới truy cập");
        //                         EasyLoading.showSuccess(
        //                           'Đăng xuất thành công!',
        //                           duration: const Duration(milliseconds: 1300),
        //                           maskType: EasyLoadingMaskType.black,
        //                         );
        //                       },
        //                       child: Container(
        //                         padding: const EdgeInsets.only(left: 10),
        //                         alignment: Alignment.centerLeft,
        //                         width: double.infinity,
        //                         height:
        //                             MediaQuery.of(context).size.height * 0.07,
        //                         decoration: BoxDecoration(
        //                             color: Colors.grey,
        //                             borderRadius: BorderRadius.circular(10)),
        //                         child: Row(
        //                           children: [
        //                             Icon(
        //                               Icons.logout,
        //                               color: Colors.black,
        //                               size: 25,
        //                             ),
        //                             SizedBox(
        //                               width: 10,
        //                             ),
        //                             Text(
        //                               'Đăng xuất',
        //                               style: TextStyle(fontSize: 20),
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                   const SizedBox(
        //                     height: 30,
        //                   ),
        //                 ],
        //               ),
        //             );
        //           }),
        //       child: Container(
        //         width: 30,
        //         height: 30,
        //         decoration: BoxDecoration(
        //             shape: BoxShape.circle,
        //             color: Colors.grey,
        //             image: DecorationImage(image: NetworkImage(avatar ?? ''))),
        //       ),
        //     )),
        title: const Text(
          'Đoạn chat',
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                FontAwesomeIcons.penToSquare,
                color: Colors.blue.shade800,
                size: 27,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
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
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.8,
                child: StreamBuilder(
                    stream: _allUser
                        .where("userName", isGreaterThanOrEqualTo: searchText)
                        .orderBy("userName")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Something went wrong"),
                        );
                      }
                      if (snapshot.connectionState != ConnectionState.waiting) {
                        return const Center(
                          child: ChatHomeShimmer(),
                        );
                      }
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
                                      String roomId = chatRoomId(
                                          loggedInUser.email!,
                                          documentSnapshot['email']);
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Chat(
                                                    chatRoomId: roomId,
                                                    documentSnapshot:
                                                        documentSnapshot,
                                                  )));
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
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
                                                          ''),
                                                ),
                                              ),
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
                                              documentSnapshot['userName'] ??
                                                  '',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              documentSnapshot['email'] ?? '',
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        )
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
