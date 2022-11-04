import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:over_engineered/auth/auth_page.dart';
import 'package:over_engineered/constants.dart';
import 'package:page_transition/page_transition.dart';

import '../hidden_drawer.dart';
import '../utils/show_snackbar.dart';

class LoginOptions extends StatefulWidget {
  const LoginOptions({Key? key}) : super(key: key);

  @override
  State<LoginOptions> createState() => _LoginOptionsState();
}

class _LoginOptionsState extends State<LoginOptions> {
  final String baseUrl = "https://block-to-do.vercel.app";
  void signUp() async {
    final Dio dio = Dio();
    final _auth = FirebaseAuth.instance;
    try{
      final data = {
        "email": _auth.currentUser!.email,
        "password": "123456",
      };
      final String jsonString = jsonEncode(data);
      var response = await dio.post("$baseUrl/addUser", data: jsonString);
      if (response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HiddenDrawer(email: _auth.currentUser!.email,),
          ),
        );
      } else if (response.statusCode == 404) {
        showSnackBar(context, 'Sign Up failed');
      }
    }
    on DioError catch(e){
      showSnackBar(context, 'Error in Sign Up');
    }
  }
  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>['email']).signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    return kIsWeb
        ? Scaffold(
            backgroundColor: kWhite,
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: h / 7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/splash_screen.png',
                      width: h / 2.5,
                      height: h / 2.5,
                    ),
                    SizedBox(
                      height: h / 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w / 2.8,
                      ),
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          PageTransition(
                            child: AuthPage(),
                            type: PageTransitionType.fade,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimary,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: w / 80),
                          child: Row(
                            children: [
                              Icon(
                                Icons.email_outlined,
                                color: kWhite,
                                size: w / 40,
                              ),
                              SizedBox(
                                width: w / 18,
                              ),
                              Text(
                                'Login with Email',
                                style: TextStyle(
                                  color: kWhite,
                                  fontSize: w / 60,
                                  fontFamily: 'SSPBold',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: h / 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w / 2.8,
                      ),
                      child: OutlinedButton(
                        onPressed: signInWithGoogle,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            width: 3,
                            color: kPrimary,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: w / 80,
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/google.png',
                                width: w / 40,
                                height: w / 40,
                              ),
                              SizedBox(
                                width: w / 18,
                              ),
                              Text(
                                'Login with Google',
                                style: TextStyle(
                                  color: kPrimary,
                                  fontFamily: 'SSPBold',
                                  fontSize: w / 60,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : SafeArea(
            child: Scaffold(
              backgroundColor: kWhite,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: h / 4,
                    ),
                    Center(
                      child: Image.asset(
                        'assets/splash_screen.png',
                        width: h / 3.2,
                        height: h / 3.2,
                      ),
                    ),
                    SizedBox(
                      height: h / 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w / 10,
                      ),
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          PageTransition(
                            child: AuthPage(),
                            type: PageTransitionType.fade,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimary,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Icon(
                                Icons.email_outlined,
                                color: kWhite,
                                size: 24,
                              ),
                              Text(
                                'Login with Email',
                                style: TextStyle(
                                  color: kWhite,
                                  fontSize: 24,
                                  fontFamily: 'SSPBold',
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: h / 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w / 10,
                      ),
                      child: OutlinedButton(
                        onPressed: signInWithGoogle,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            width: 3,
                            color: kPrimary,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                'assets/google.png',
                                width: 24,
                                height: 24,
                              ),
                              const Text(
                                'Login with Google',
                                style: TextStyle(
                                  color: kPrimary,
                                  fontFamily: 'SSPBold',
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
