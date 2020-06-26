import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class LoadingScreen extends StatefulWidget {
  static const String id = 'loading screen';

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  final _auth = FirebaseAuth.instance;

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          ChatScreen.id,
          ModalRoute.withName(ChatScreen.id),
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          WelcomeScreen.id,
          ModalRoute.withName(WelcomeScreen.id),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    super.initState();

    controller = AnimationController(
      duration: Duration(milliseconds: 1100),
      vsync: this,
    );

    controller.forward();

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    );

    controller.addListener(() {
      setState(() {});
    });

    Timer(
      Duration(milliseconds: 1500),
      () => getCurrentUser(),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 20,
              child: Opacity(
                opacity: controller.value,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: Shimmer.fromColors(
                baseColor: Colors.blue[200],
                highlightColor: Colors.yellowAccent,
                period: Duration(milliseconds: 500),
                child: Text(
                  'By',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontFamily: 'RockSalt',
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Shimmer.fromColors(
                baseColor: Colors.blue[400],
                highlightColor: Colors.yellowAccent,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
                  child: Text(
                    'Henry Hogan',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'RockSalt',
                        shadows: <Shadow>[
                          Shadow(
                              blurRadius: 12.0,
                              color: Colors.black87,
                              offset: Offset.fromDirection(120, 12)),
                        ]),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
