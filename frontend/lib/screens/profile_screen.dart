import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:over_engineered/constants.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Lottie.asset(
                    'assets/hi_animation.json',
                    fit: BoxFit.fill,
                    width: h / 3,
                    height: h / 3,
                  ),
                  SizedBox(
                    height: h / 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Email:-',
                        style: TextStyle(
                          color: kPrimary,
                          fontFamily: 'SSPBold',
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        width: w/20,
                      ),
                      Text(
                        widget.email,
                        style: const TextStyle(
                          color: kPrimary,
                          fontFamily: 'SSPBold',
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
