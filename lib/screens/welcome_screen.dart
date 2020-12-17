import 'package:flare_flutter/flare_actor.dart';
import 'package:flash_chat/Services/RoundButton.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
          backgroundColor: kScaffoldColor,
          body: SafeArea(
            maintainBottomViewPadding: true,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: new FlareActor(
                          "images/flash2.flr",
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.contain,
                          animation: "flash_blast",
                          color: Colors.yellowAccent,
                          artboard: "Artboard",
                        ),
                      ),
                      Text(
                        'Flash Chat',
                        style: TextStyle(
                          fontSize: 38.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                  RoundButton(
                    color: Color(0xff755ff9),
                    title: 'Log in',
                    onPressed: () {
                      Navigator.pushNamed(context, kLoginScreen);
                    },
                  ),
                  RoundButton(
                    color: Color(0xff755ff9),
                    title: 'Register',
                    onPressed: () {
                      Navigator.pushNamed(context, kRegisterScreen);
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
