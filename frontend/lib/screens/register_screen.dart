import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:lottie/lottie.dart';
import 'package:over_engineered/hidden_drawer.dart';
import 'package:over_engineered/utils/show_snackbar.dart';
import 'package:uno/uno.dart';

import '../constants.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterScreen({Key? key, required this.showLoginPage})
      : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _isHidden = true;
  bool _isHidden2 = true;
  final uno = Uno();

  bool passwordConfirmed() {
    if (_passwordController.text == _confirmPasswordController.text) {
      return true;
    } else {
      return false;
    }
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _toggleConfirmPasswordView() {
    setState(() {
      _isHidden2 = !_isHidden2;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // final String baseUrl = kIsWeb ? "http://localhost:4000" : "http://10.0.2.2:4000";
  final String baseUrl = "https://block-to-do.vercel.app";

  void signUp() async {
    final Dio dio = Dio();
    try{

      if(_emailController.text.isEmpty){
        showSnackBar(context, 'Please enter email');
      }
      if(_passwordController.text.isEmpty){
        showSnackBar(context, 'Please enter password');
      }
      if(_confirmPasswordController.text.isEmpty){
        showSnackBar(context, 'Please enter confirm password');
      }
      final data = {
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim(),
      };
      final String jsonString = jsonEncode(data);
      var response = await dio.post("$baseUrl/addUser", data: jsonString);
      if (response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HiddenDrawer(email: _emailController.text.trim(),),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: h / 1000,
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
                  'Hello there!',
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
                  padding: EdgeInsets.symmetric(
                      horizontal: kIsWeb ? w / 2.8 : w / 9),
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
                  padding: EdgeInsets.symmetric(
                      horizontal: kIsWeb ? w / 2.8 : w / 9),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _isHidden,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                        onTap: _togglePasswordView,
                        child: Icon(
                          _isHidden ? Icons.visibility : Icons.visibility_off,
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
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: kIsWeb ? w / 2.8 : w / 9),
                  child: TextField(
                    controller: _confirmPasswordController,
                    obscureText: _isHidden2,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                        onTap: _toggleConfirmPasswordView,
                        child: Icon(
                          _isHidden2 ? Icons.visibility : Icons.visibility_off,
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
                      hintText: 'Confirm Password',
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: passwordConfirmed() ? signUp : () {},
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: h / 50,
                        horizontal: kIsWeb ? w / 9.2 : w / 4.05),
                    child: const Text(
                      'Sign Up',
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
                      "I'm a member! ",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SSPRegular',
                        color: kPrimary,
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: widget.showLoginPage,
                        child: const Text(
                          'Login Now',
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
