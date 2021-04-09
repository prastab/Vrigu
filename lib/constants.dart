import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kTextFieldDecoration = InputDecoration(
  labelStyle: TextStyle(
    fontSize: 18,
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  errorStyle: TextStyle(fontSize: 14),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFf9813a), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff1a1c20), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

BoxDecoration kBoxDecorationDropDown = BoxDecoration(
    border: Border.all(color: Color(0xFFf9813a), width: 1.0),
    borderRadius: BorderRadius.circular(32));


const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);
