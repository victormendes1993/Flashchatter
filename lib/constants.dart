import 'package:flutter/material.dart';

const kScreenTextBlackBold = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20.0,
  color: Colors.black54,
);

const kScreenTextGrey = TextStyle(
  color: Colors.grey,
  fontSize: 15.0,
);

const kScreenTextBlueAccent = TextStyle(
  color: Colors.blueAccent,
  fontSize: 15.0,
);

const kChatScreenTypingTextField = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  hintStyle: kScreenTextGrey,
  border: InputBorder.none,
);

const kChatScreenSendButton = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 15.0,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.grey, fontSize: 15.0),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black12, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
