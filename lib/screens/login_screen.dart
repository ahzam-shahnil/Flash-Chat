import 'package:audioplayers/audio_cache.dart';
import 'package:flash_chat/Services/AuthExceptionHandler.dart';
import 'package:flash_chat/Services/AuthHelper.dart';
import 'package:flash_chat/Services/HelperFunctions.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flash_chat/Services/PaddedColumn.dart';
import 'package:flash_chat/Services/RoundButton.dart';
import '../Services/TeddyScreen.dart';
import 'package:regexpattern/regexpattern.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  String _teddyAnimType = 'idle';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final player = AudioCache();
  @override
  void initState() {
    super.initState();
    _passFocusNode.addListener(() {
      if (_passFocusNode.hasFocus) {
        setState(() {
          _teddyAnimType = 'test';
        });
      } else {
        setState(() {
          _teddyAnimType = 'idle';
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    emailController.dispose();
    _passFocusNode.dispose();
    _emailFocusNode.dispose();
  }

  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: kScaffoldColor,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SafeArea(
            maintainBottomViewPadding: true,
            child: SingleChildScrollView(
              child: PaddedCoulmn(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        player.play("slap.mp3");
                        _teddyAnimType = 'fail';
                      });
                    },
                    onVerticalDragDown: (details) {
                      setState(() {
                        _teddyAnimType = 'success';
                      });
                    },
                    onTap: () {
                      setState(() {
                        player.play("slap.mp3");
                        _teddyAnimType = 'idle';
                      });
                    },
                    child: TeddyContainer(
                      teddyAnimType: _teddyAnimType,
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Hero(
                    tag: 'form',
                    child: Form(
                        key: _formKey,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextFormField(
                                  controller: emailController,
                                  focusNode: _emailFocusNode,
                                  onEditingComplete: () =>
                                      _emailFocusNode.nextFocus(),
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: kTextInputDecoration.copyWith(
                                    labelText: 'Email',
                                    errorStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  validator: (String value) {
                                    bool isEmail =
                                        value.trim().toLowerCase().isEmail();
                                    if (value.isEmpty) {
                                      return 'Email is Required.';
                                    } else if (!isEmail) {
                                      return 'Invalid Email';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                TextFormField(
                                  obscureText: true,
                                  controller: passwordController,
                                  focusNode: _passFocusNode,
                                  onEditingComplete: () =>
                                      _passFocusNode.unfocus(),
                                  decoration: kTextInputDecoration.copyWith(
                                      labelText: 'Password',
                                      errorStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      )),
                                  validator: (String value) {
                                    value = value.trim();
                                    bool isPass = value.isPasswordEasy();
                                    if (value.isEmpty) {
                                      return 'Please enter Password';
                                    } else if (!isPass) {
                                      return 'Minimum length : 8';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
                  RoundButton(
                    color: Color(0xff755ff9),
                    title: 'Login',
                    onPressed: () {
                      bool teddyState = _formKey.currentState.validate();
                      setState(() {
                        if (teddyState) {
                          _teddyAnimType = 'idle';
                        } else {
                          _teddyAnimType = 'fail';
                        }
                      });
                      if (teddyState) {
                        setState(() {
                          showSpinner = true;
                        });
                        _login();
                      }
                    },
                  ),
                  TextButton(
                    clipBehavior: Clip.hardEdge,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, kRegisterScreen);
                    },
                    child: Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  _login() async {
    final status = await FirebaseAuthHelper().login(
      email: emailController.text.trim().toLowerCase(),
      pass: passwordController.text.trim(),
    );
    if (status == AuthResultStatus.successful) {
      HelperFunctions.saveUserLoggedInSharedPreference(true);
      // HelperFunctions.saveStartScreenSharedPreference(kChatScreen);
      UserTempData.myName = await HelperFunctions.getUserNameSharedPreference();
      UserTempData.myEmail = await HelperFunctions.getUserEmailSharedPreference();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ChatScreen(),
        ),
      );
    } else {
      final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
      _showAlertDialog(errorMsg);
    }
    setState(() {
      showSpinner = false;
    });
  }

  _showAlertDialog(dynamic errormsg) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (context) => AlertDialog(
        title: Text('Signin Falied'),
        content: Container(
          height: 10,
        ),
        backgroundColor: Color(0xff755ff9),
        actions: <Widget>[
          Text(
            errormsg.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          )
        ],
      ),
    );
  }
}
