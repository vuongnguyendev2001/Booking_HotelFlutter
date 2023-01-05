import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);
const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here',
  border: InputBorder.none,
);
const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.blue, width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enver a value',
  hintStyle: TextStyle(
    color: Colors.white,
  ),
  fillColor: Colors.white38,
  focusColor: Colors.blueGrey,
  contentPadding: EdgeInsetsDirectional.fromSTEB(16, 24, 0, 20),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(16)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white60, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(18)),
  ),
  filled: true,
);
List images = [
    "img.png",
    "img_2.png",
    "img_1.png",
  ];
  List textName = [
    "Bà Nà Hills",
    "Bãi Sao",
    "Thành phố mộng mơ",
  ];
  List textAddress = [
    "Đà Nẵng",
    "Phú Quốc",
    "Đà Lạt",
  ];
  List textDiscription = [
    "Với kiến trúc thời Pháp thuộc địa, đặc biệt là Cầu Vàng huyền"
        " thoại xuất hiện trên khắp mặt báo quốc tế.",
    "Bãi biển với bờ cát trắng mịn dài, nước trong màu xanh ngọc ở Phú Quốc",
    "Với khí hậu trong lành, mát mẻ quanh năm, Đà Lạt là 1 điểm du lịch lý tưởng không thể bỏ qua trong bất kể các mùa trong năm.",
  ];