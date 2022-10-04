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
