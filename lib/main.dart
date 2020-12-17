import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/Services/HelperFunctions.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/ConversationScreen.dart';
import 'package:flash_chat/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatefulWidget {
  @override
  _FlashChatState createState() => _FlashChatState();
}

class _FlashChatState extends State<FlashChat> {
  bool isLogged = false;
  bool isLoading = true;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      print('login is$value');
      setState(() {
        isLogged = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('login in build is $isLogged');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.black54),
        ),
      ),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          color: kScaffoldColor,
          opacity: 0.9,
          child: isLogged == true ? ChatScreen() : WelcomeScreen(),
        ),
      ),
      
      routes: {
        kWelcomeScreen: (context) => WelcomeScreen(),
        kLoginScreen: (context) => LoginScreen(),
        kRegisterScreen: (context) => RegistrationScreen(),
        kChatScreen: (context) => ChatScreen(),
        kSearchScreen: (context) => SearchScreen(),
        kConversationScreen: (context) => ConversationScreen(),
      },
    );
  }
}
