import 'package:app_booking/model/user_model.dart';
import 'package:flutter/material.dart';

class UserModelProvider with ChangeNotifier {
  UserModel userModel;
  UserModelProvider()
      : userModel = UserModel(
          userName: "Loading",
          email: "Loading",
          avatar: "Loading",
        );
}
