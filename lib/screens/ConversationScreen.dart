import 'package:flash_chat/Services/DatabaseMethods.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ConversationScreen extends StatefulWidget {
  final String chatUserName;
  final String chatRoomId;

  ConversationScreen({this.chatUserName, this.chatRoomId});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  DatabaseMethods databaseMethods = DatabaseMethods();
  sendMessage() {
    if (msgController.text.trim().isNotEmpty) {
      Map<String, dynamic> messageMap = {
        kMessage: msgController.text,
        kSendby: UserTempData.myName,
        kSendTime: DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      msgController.clear();
    }
  }

  Widget _dumpspace(height) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: height,
      color: Colors.transparent,
    );
  }

  Widget _chatbubble(String message, bool _ismine) {
    print('send by me $_ismine');
    final RegExp regExp = RegExp(
        r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: _ismine ? 0 : 3, right: _ismine ? 3 : 0),
      alignment: _ismine ? Alignment.centerRight : Alignment.centerLeft,
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        margin: EdgeInsets.only(top: _ismine ? 5 : 15, right: 10, left: 10),
        decoration: BoxDecoration(
          borderRadius: _ismine
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23))
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)),
          gradient: LinearGradient(
            colors: _ismine
                ? [Colors.blue, Colors.lightBlue]
                : [const Color(0xff262626), const Color(0xff262626)],
          ),
        ),
        child: Text(
          message,
          style: regExp.hasMatch(message)
              ? message.length == 2
                  ? TextStyle(fontSize: 25)
                  : TextStyle(fontSize: 17)
              : TextStyle(fontSize: 17),
        ),
      ),
    );
  }

  List<Widget> _chatmulticolorbubbles(data) {
    List<Widget> list = [];

    list.add(_dumpspace(10.0));
    if (data.documents.length > 0) {
      for (var i = 0; i < data.documents.length; i++) {
        list.add(_chatbubble(data.documents[i][kMessage],
            data.documents[i][kSendby] == UserTempData.myName));
      }
    }

    list.add(_dumpspace(80.0));

    return list;
  }

  Widget chatMessageList() {
    return StreamBuilder(
      stream: databaseMethods.getConversationMessages(widget.chatRoomId),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
      elevation: 4,
        brightness: Brightness.light,
        backgroundColor: Colors.black,
        title: Text(
          widget.chatUserName,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              color: Colors.black,
              alignment: Alignment.topCenter,
              height: double.infinity,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                controller: _scrollController,
                reverse: true,
                physics: ClampingScrollPhysics(),
                child: chatMessageList(),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                color: Color(0XFF262626),
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        maxLines: null,
                        controller: msgController,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Message...',
                          hintStyle: TextStyle(
                            color: Colors.white54,
                            fontSize: 18,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    ClipOval(
                      child: Container(
                        height: 40,
                        width: 40,
                        color: Colors.blue,
                        child: IconButton(
                          icon: Icon(
                            FontAwesomeIcons.paperPlane,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            sendMessage();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
