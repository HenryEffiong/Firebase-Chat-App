import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/components/component.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'registration_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'welcome_screen.dart';

class LoginScreenII extends StatefulWidget {
  static const String id = 'LoginScreenII';
  @override
  _LoginScreenIIState createState() => _LoginScreenIIState();
}

class _LoginScreenIIState extends State<LoginScreenII> {
  final _auth = FirebaseAuth.instance;
  bool _rememberMe = false;
  String userEmail;
  String userPassword;
  bool spinner = false;

  GoogleSignIn _googleSignIn = GoogleSignIn();
  FacebookLogin facebookLogin = FacebookLogin();

  Future<FacebookLoginResult> signInWithFacebook() async {
    FacebookLoginResult facebookLoginResult =
        await facebookLogin.logIn(['email']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelled");
        break;
      case FacebookLoginStatus.error:
        print("error");
        break;
      case FacebookLoginStatus.loggedIn:
        break;
    }
    return facebookLoginResult;
  }

  Future<FirebaseUser> facebookUser() async {
    FacebookLoginResult facebookLoginResult = await signInWithFacebook();

    final accessToken = facebookLoginResult.accessToken.token;

    final facebookAuthCred = FacebookAuthProvider.getCredential(
      accessToken: accessToken,
    );

    final AuthResult authResult =
        await _auth.signInWithCredential(facebookAuthCred);

    final FirebaseUser user = authResult.user;

    /* 
    print("signed in " + user.displayName);
    print(user);
    */

    return user;
  }

  Future<FirebaseUser> signInWithGoogle() async {
    setState(() {
      spinner = true;
    });

    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    print("signed in " + user.displayName);

    setState(() {
      spinner = false;
    });

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF73AEF5),
                        Color(0xFF61A4F1),
                        Color(0xFF478ED0),
                        Color(0xFF398AE5),
                      ],
                      stops: [0.1, 0.4, 0.7, 0.9],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 100.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '⚡️Sign In',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.2,
                            fontFamily: 'Karla',
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        BuildColumn(
                          text: 'Email',
                          type: TextInputType.emailAddress,
                          icon: Icons.email,
                          hint: 'Enter your email...',
                          changed: (value) {
                            userEmail = value;
                          },
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        BuildColumn(
                          text: 'Password',
                          type: TextInputType.text,
                          boolean: true,
                          icon: Icons.lock,
                          hint: 'Enter your password...',
                          changed: (value) {
                            userPassword = value;
                          },
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            onPressed: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Forgot Password?',
                                style: kLabelStyle.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            padding: EdgeInsets.only(),
                          ),
                        ),
                        Container(
                          height: 20.0,
                          child: Row(
                            children: <Widget>[
                              Theme(
                                data: ThemeData(
                                    unselectedWidgetColor: Colors.white),
                                child: Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value;
                                    });
                                  },
                                  checkColor: Colors.green,
                                  activeColor: Colors.white,
                                ),
                              ),
                              Text(
                                'Remember me',
                                style: kLabelStyle,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          width: double.infinity,
                          child: RoundedButton(
                            onPressed: () async {
                              setState(() {
                                spinner = true;
                              });
                              try {
                                final signInUser =
                                    await _auth.signInWithEmailAndPassword(
                                  email: userEmail,
                                  password: userPassword,
                                );
                                if (signInUser != null) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    ChatScreen.id,
                                    ModalRoute.withName(ChatScreen.id),
                                  );
                                }
                                setState(() {
                                  spinner = false;
                                });
                              } catch (e) {
                                print(e);
                                //TODO: Handle possible errors! using a popup, set spinner to false
                              }
                            },
                            color: Colors.white,
                            title: 'LOGIN',
                            textColor: Color(0xFF527DAA),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              '- OR -',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              'Sign in with',
                              style: kLabelStyle,
                            )
                          ],
                        ),
                        SocialLogin(
                          googleSign: () async {
                            try {
                              final user = await signInWithGoogle();

                              if (user != null) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  ChatScreen.id,
                                  ModalRoute.withName(ChatScreen.id),
                                );
                              }
                            } catch (e) {
                              print(e);
                              setState(() {
                                spinner = false;
                              });
                              //TODO: Handle possible errors! using a popup, set spinner to false
                            }
                          },
                          facebookSign: () async {
                            try {
                              final user = await facebookUser();

                              if (user != null) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  ChatScreen.id,
                                  ModalRoute.withName(ChatScreen.id),
                                );
                              }
                            } catch (e) {
                              print(e);
                              //TODO: Handle possible errors! using a popup, set spinner to false
                            }
                          },
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Don\'t have an Account? ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w100,
                                        fontSize: 18.0,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  RegistrationScreen.id,
                                  ModalRoute.withName(WelcomeScreen.id),
                                );
                              },
                              child: InkWell(
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18.0,
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                    letterSpacing: 1.0,
                                    fontFamily: 'Karla',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SocialLogin extends StatelessWidget {
  SocialLogin({this.googleSign, this.facebookSign});
  final Function googleSign;
  final Function facebookSign;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: facebookSign,
            child: Container(
              height: 60.0,
              width: 60.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6.0,
                  )
                ],
                image: DecorationImage(
                  image: AssetImage('images/facebook.jpg'),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: googleSign,
            child: Container(
              height: 60.0,
              width: 60.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6.0,
                  )
                ],
                image: DecorationImage(
                  image: AssetImage('images/google.jpg'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
