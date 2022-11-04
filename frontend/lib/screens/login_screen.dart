import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:lottie/lottie.dart';

import '../constants.dart';
import '../hidden_drawer.dart';
import '../utils/show_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.showRegisterPage})
      : super(key: key);

  final VoidCallback showRegisterPage;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _isHidden = true;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // final String baseUrl = kIsWeb ? "http://localhost:4000" : "http://10.0.2.2:4000";
  final String baseUrl = "https://block-to-do.vercel.app";
  
  void signIn() async{
    final Dio dio = Dio();
    try{
      if(_emailController.text.isEmpty){
        showSnackBar(context, 'Please enter email');
      }
      if(_passwordController.text.isEmpty){
        showSnackBar(context, 'Please enter password');
      }
      final data = {
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim(),
      };
      final String jsonString = jsonEncode(data);
      var response = await dio.post('$baseUrl/loginuser', data: jsonString);
      print(response.statusCode);
      if (response.statusCode == 202) {
        print('success');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HiddenDrawer(email: _emailController.text.trim(),),
          ),
        );
      } else if (response.statusCode == 404) {
        showSnackBar(context, 'Sign Up failed');
      }
    } on DioError catch(e){
      showSnackBar(context, 'Sign in Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    return SafeArea(
            child: KeyboardDismisser(
              child: Scaffold(
                backgroundColor: kWhite,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: h / 30,
                      ),
                      Lottie.asset(
                        'assets/hi_animation.json',
                        fit: BoxFit.fill,
                        width: h / 3,
                        height: h / 3,
                      ),
                      SizedBox(
                        height: h / 1000,
                      ),
                      const Text(
                        'Welcome back!',
                        style: TextStyle(
                          color: kPrimary,
                          fontFamily: 'SSPBold',
                          fontSize: 43,
                        ),
                      ),
                      SizedBox(
                        height: h / 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: kIsWeb ? w / 2.8 : w / 9),
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: kPrimary,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: kBlack,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            hintText: 'Email',
                            hintStyle: const TextStyle(
                              color: kSecondary,
                              fontFamily: 'SSPRegular',
                              fontSize: 22,
                            ),
                          ),
                          style: const TextStyle(
                            color: kPrimary,
                            fontFamily: 'SSPRegular',
                            fontSize: 22,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: h / 50,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: kIsWeb ? w / 2.8 : w / 9),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: _isHidden,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: _togglePasswordView,
                              child: Icon(
                                _isHidden
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: kPrimary,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: kPrimary,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: kBlack,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            hintText: 'Password',
                            hintStyle: const TextStyle(
                              color: kSecondary,
                              fontFamily: 'SSPRegular',
                              fontSize: 22,
                            ),
                          ),
                          style: const TextStyle(
                            color: kPrimary,
                            fontFamily: 'SSPRegular',
                            fontSize: 22,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: h / 50,
                      ),
                      SizedBox(
                        height: h / 50,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: signIn,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: h / 50, horizontal: kIsWeb ? w/9.2 : w / 3.85),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: kWhite,
                              fontSize: 22,
                              fontFamily: 'SSPBold',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: h / 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Not a member? ',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'SSPRegular',
                              color: kPrimary,
                            ),
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: widget.showRegisterPage,
                              child: const Text(
                                'Register Now',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'SSPBold',
                                  color: kPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
