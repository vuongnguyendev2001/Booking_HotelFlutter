

class UserModel{
  String? avatar;
  String? uid;
  String? userName;
  String? email;
  String? phoneNumber;
  UserModel({
       this.uid,
       this.email,
       this.userName,
      this.avatar,
      this.phoneNumber,
  });
  factory UserModel.fromMap(map){
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      userName: map['userName'],
      avatar: map['avatar'],
      phoneNumber: map['phoneNumber'],

    );
  }
  Map<String, dynamic> toMap(){
    return{
      'uid': uid,
      'email': email,
      'userName': userName,
      'avatar': avatar,
      'phoneNumber': phoneNumber,
    };
  }
}
