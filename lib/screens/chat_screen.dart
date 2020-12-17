import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/Services/AuthHelper.dart';
import 'package:flash_chat/Services/DatabaseMethods.dart';
import 'package:flash_chat/Services/HelperFunctions.dart';
import 'package:flash_chat/screens/ConversationScreen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/services.dart';

class ChatScreen extends StatefulWidget {
  static User currentUserChat;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseMethods databaseMethods = DatabaseMethods();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String name, email;
  final ScrollController _scrollController = ScrollController();
  bool isLoading = true;
  @override
  void initState() {
    getUserDetail();
    super.initState();
  }

  getUserDetail() async {
    await HelperFunctions.getUserEmailSharedPreference().then((value) {
      email = value;
    });
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      name = value;
    });
    if (UserTempData.myName == null) {
      UserTempData.myName = name;
      UserTempData.myEmail = email;
    }
    if (ChatScreen.currentUserChat == null) {
      FirebaseAuthHelper().getCurrentUser();
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget _dumpspace(height) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: height,
      color: Colors.transparent,
    );
  }

  Widget chatMessageList() {
    return StreamBuilder(
      stream: databaseMethods.getChatRooms(UserTempData.myName),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            padding: EdgeInsets.all(100),
            color: Colors.transparent,
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          );
        }

        return Column(
          children: _chatmulticolorbubbles(snapshot.data),
        );
      },
    );
  }

  List<Widget> _chatmulticolorbubbles(data) {
    List<Widget> list = [];

    list.add(_dumpspace(10.0));
    if (data.documents.length > 0) {
      for (var index = 0; index < data.documents.length; index++) {
        list.add(ChatRoomsTile(
          userName: data.documents[index]
              .data()["chatroomid"]
              .toString()
              .replaceAll("_", "")
              .replaceAll(UserTempData.myName, ""),
          chatRoomId: data.documents[index].data()["chatroomid"],
        ));
      }
    }

    list.add(_dumpspace(10.0));

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Color(0xff755ff9),
            title: Text(
              'Exit App',
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text('Yes'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('No'),
              )
            ],
          ),
        );

        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search_rounded),
              onPressed: () => Navigator.pushNamed(context, kSearchScreen),
            ),
            TextButton(
                child: Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  confirmationDialogueBox(context);
                }),
          ],
          title: Text('⚡️Flash'),
          backgroundColor: Colors.black,
        ),
        body: Stack(
          children: [
            Center(
              child: Container(
                color: Colors.black,
                alignment: Alignment.topCenter,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  reverse: true,
                  physics: ClampingScrollPhysics(),
                  child: chatMessageList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _signOut() async {
    ChatScreen.currentUserChat = null;
    HelperFunctions.resetPrefs();
    await _auth.signOut();
  }

  confirmationDialogueBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color(0xff755ff9),
            title: Text(
              'Confirm Sign out',
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  _signOut().whenComplete(() {
                    Navigator.of(context).popAndPushNamed(kWelcomeScreen);
                  });
                },
                child: Text('Sign Out'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              )
            ],
          );
        });
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName, @required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    print('Username is$userName and Chatroom id is $chatRoomId');
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(
                      chatUserName: userName,
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Card(
        elevation: 1,
        child: Container(
          color: Colors.black26,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            children: [
              Container(
                alignment: Alignment.center,
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(30)),
                child: Text(userName.substring(0, 1),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400)),
              ),
              SizedBox(
                width: 12,
              ),
              Text(userName,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400))
            ],
          ),
        ),
      ),
    );
  }
}
