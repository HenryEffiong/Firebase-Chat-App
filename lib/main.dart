import 'package:flash_chat/screens/LoadingScreen.dart';
import 'package:flash_chat/screens/login__screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
//import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';

void main() => runApp(
      FlashChat(),
    );

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LoadingScreen.id,
//      WelcomeScreen.id,
      routes: {
        LoadingScreen.id: (context) => LoadingScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        LoginScreenII.id: (context) => LoginScreenII(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
      },
    );
  }
}
