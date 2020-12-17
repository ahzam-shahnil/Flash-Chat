import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/Services/DatabaseMethods.dart';
import 'package:flash_chat/screens/chat_screen.dart';

import '../constants.dart';
import 'AuthExceptionHandler.dart';
import 'HelperFunctions.dart';

class FirebaseAuthHelper {
  final _auth = FirebaseAuth.instance;
  AuthResultStatus _status;
  DatabaseMethods _databaseMethods = new DatabaseMethods();
  getCurrentUser() {
    ChatScreen.currentUserChat = _auth.currentUser;
  }

  Future<AuthResultStatus> createAccount({email, pass, name}) async {
    print("in Auth Helper register");
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      print('in try user');

      if (authResult.user != null) {
        print('user not null');
        if (!authResult.user.emailVerified) {
          print('Sending  verify Email');
          print('name is $name');
          ChatScreen.currentUserChat = authResult.user;
          await ChatScreen.currentUserChat.updateProfile(displayName: name);
          ChatScreen.currentUserChat.reload();
          ChatScreen.currentUserChat = _auth.currentUser;
          await authResult.user.sendEmailVerification();
          Map<String, String> userInfoMap = {'name': name, 'email': email};
          _databaseMethods.uploadUserName(userInfoMap);
          print('Username is ${authResult.user.displayName}');

          _status = AuthResultStatus.verifyEmail;
        }
      }
    } on FirebaseAuthException catch (e) {
      print('In Exception Catch');
      print('Exception @createAccount: ${e.code}');
      print(e.message);
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future<AuthResultStatus> login({email, pass}) async {
    print("in Auth Helper login");
    try {
      final authResult =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      if (authResult.user != null) {
        if (!authResult.user.emailVerified) {
          _status = AuthResultStatus.verifyEmail;
        } else {
          ChatScreen.currentUserChat = authResult.user;
          _status = AuthResultStatus.successful;
          HelperFunctions.saveUserEmailSharedPreference(
              email.toString().toLowerCase());
          print('Username is ${authResult.user.displayName}');
          HelperFunctions.saveUserNameSharedPreference(
              authResult.user.displayName.toLowerCase());
        }
      }
    } on FirebaseAuthException catch (e) {
      print('In Exception Catch');
      print('Exception @createAccount: ${e.code}');
      _status = AuthExceptionHandler.handleException(e);
      print(e.message);
    }
    return _status;
  }

  logout() {
    ChatScreen.currentUserChat = null;
    _auth.signOut();
  }
}
