import 'package:flash_chat/Services/AuthExceptionHandler.dart';
import 'package:flash_chat/Services/AuthHelper.dart';
import 'package:flash_chat/Services/HelperFunctions.dart';
import 'package:flash_chat/Services/PaddedColumn.dart';
import 'package:flash_chat/Services/RoundButton.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Services/TeddyScreen.dart';
import 'package:regexpattern/regexpattern.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();
  String _teddyAnimType = 'idle';

  @override
  void initState() {
    _passFocusNode.addListener(() {
      if (_passFocusNode.hasFocus) {
        setState(() {
          _teddyAnimType = 'idle';
        });
      } else {
        setState(() {
          _teddyAnimType = 'test';
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    _passFocusNode.dispose();
    _emailFocusNode.dispose();
    _nameFocusNode.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  onVerticalDragDown: (details) {
                    setState(() {
                      _teddyAnimType = 'success';
                    });
                  },
                  onTap: () {
                    setState(() {
                      _teddyAnimType = 'idle';
                    });
                  },
                  onDoubleTap: () {
                    setState(() {
                      _teddyAnimType = 'fail';
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
                                controller: nameController,
                                focusNode: _nameFocusNode,
                                onEditingComplete: () =>
                                    _nameFocusNode.nextFocus(),
                                keyboardType: TextInputType.text,
                                decoration: kTextInputDecoration.copyWith(
                                  labelText: 'Name',
                                  errorStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                validator: (String value) {
                                  value = value.trim().toLowerCase();
                                  // bool isUsername = value.trim().isAlphabet();
                                  if (value.isEmpty) {
                                    return 'Enter your name.';
                                  }
                                  // else if (!isUsername) {
                                  //   return 'Invalid Username';
                                  // }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
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
                              //Password Text Field
                              TextFormField(
                                obscureText: true,
                                controller: passwordController,
                                focusNode: _passFocusNode,
                                decoration: kTextInputDecoration.copyWith(
                                  labelText: 'Password',
                                  errorStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                onEditingComplete: () =>
                                    _passFocusNode.unfocus(),
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
                            ],
                          ),
                        ),
                      )),
                ),
                RoundButton(
                  color: Color(0xff755ff9),
                  title: 'Register',
                  onPressed: () async {
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
                      _createAccount();
                    }
                  },
                ),
                TextButton(
                  clipBehavior: Clip.hardEdge,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, kLoginScreen);
                  },
                  child: Text(
                    "Already have an account?",
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
      ),
    );
  }

  _createAccount() async {
    final status = await FirebaseAuthHelper().createAccount(
        email: emailController.text.trim().toLowerCase(),
        pass: passwordController.text.trim(),
        name: nameController.text.trim().toLowerCase());
    print('create $status');
    print('current user is ${ChatScreen.currentUserChat}');
    if ((status == AuthResultStatus.verifyEmail) &&
        ChatScreen.currentUserChat != null) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Color(0xff755ff9),
          title: Text(
            'Verificaion link is sent to  ${emailController.text.toLowerCase().trim()}.Go verify!',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            )
          ],
        ),
      );
    
    //  HelperFunctions.saveStartScreenSharedPreference(kChatScreen);
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => ChatScreen(),
      //   ),
      // );
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
      useSafeArea: true,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text('SignUp Falied'),
        content: Container(
          height: 10,
        ),
        backgroundColor: Color(0xff755ff9),
        actions: <Widget>[
          Text(
            errormsg,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Center(
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
