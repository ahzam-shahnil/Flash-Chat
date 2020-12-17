import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/Services/DatabaseMethods.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/ConversationScreen.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = new TextEditingController();
  final FocusNode myFocus = new FocusNode();
  @override
  void initState() {
    myFocus.addListener(() {
      print(myFocus);
      print(searchController.text);
      if (!myFocus.hasFocus && searchController.text.isEmpty) {
        setState(() {
          isSearch = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    myFocus.dispose();
    super.dispose();
  }

  bool isSearch = false;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  initiateSearch() async {
    setState(() {
      isSearch = true;
    });
  }

  // create chat room ,send user to conversation screen, push replacement
  createChatRoomAndEnter(String userName, String userEmail) {
    print(userName);
    print(UserTempData.myName);
    print(UserTempData.myEmail);
    if ((userName != UserTempData.myName) &&
        (userEmail != UserTempData.myEmail)) {
      String chatroomid = getChatRoomID(userName, UserTempData.myName);
      List<String> users = [userName, UserTempData.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomid": chatroomid
      };
      databaseMethods.createChatRoom(chatroomid, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationScreen(
              chatUserName: userName,
              chatRoomId: chatroomid,
            ),
          ));
    }
  }

//search Tile provides the widget for users of App.
  Widget searchTile({String userName, String email, Function onPressed}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Expanded(
                      child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      userName,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      email,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )
                  ],
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    clipBehavior: Clip.hardEdge,
                    elevation: 5.0,
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30.0),
                    child: MaterialButton(
                      onPressed: onPressed,
                      minWidth: 90.0,
                      height: 42.0,
                      child: Text(
                        email == UserTempData.myEmail ? 'My Profile' : 'Message',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//actual search list builder for users of app
  Widget searchList() {
    print("search is $isSearch");
    return StreamBuilder(
      stream: isSearch
          ? FirebaseFirestore.instance
              .collection("users")
              .where('name', isNotEqualTo: UserTempData.myName)
              .orderBy('name')
              .startAt([searchController.text]).endAt(
                  [searchController.text + '\uf8ff']).snapshots()
          : FirebaseFirestore.instance
              .collection("users")
              .where('email', isNotEqualTo: UserTempData.myEmail)
              .orderBy('email')
              .snapshots(),
      builder: (context, snapshot) {
        return !snapshot.hasData
            ? Center(child: Text('No data'))
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot users = snapshot.data.documents[index];
                  return searchTile(
                    email: users['email'],
                    userName: users['name'],
                    onPressed: () {
                      createChatRoomAndEnter(users['name'], users['email']);
                    },
                  );
                },
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: null,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextField(
                                focusNode: myFocus,
                                controller: searchController,
                                decoration: kTextInputDecoration.copyWith(
                                    hintText: 'Type here to Search',
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    border: InputBorder.none),
                              ),
                            ),
                            ClipOval(
                              child: Container(
                                color: Colors.green,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.search_rounded,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    initiateSearch();
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(child: searchList())
              ],
            ),
          ),
        ),
      ),
    );
  }
}

getChatRoomID(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
