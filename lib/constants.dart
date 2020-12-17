import 'package:flutter/material.dart';

const kWelcomeScreen = 'welcome_screen';
const kLoginScreen = 'login_screen';
const kRegisterScreen = 'register_screen';
const kChatScreen = 'chat_screen';
const kSearchScreen = 'search_screen';
const kConversationScreen = 'conver_screen';
const kScaffoldColor = Color(0xff2A3036);
const kMessage = 'message';
const kSendby = 'sendBy';
const kSendTime = 'time';
const dynamic kChatroomId = 'chatroomid';

class UserTempData {
  static String myName;
  static String myEmail;
}

enum AuthResultStatus {
  verifyEmail,
  successful,
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  undefined,
}
const kTextInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.white),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

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
