import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:over_engineered/auth/main_page.dart';
import 'package:over_engineered/firebase_options.dart';
import 'package:over_engineered/hidden_drawer.dart';
import 'package:over_engineered/screens/login_options.dart';
import 'package:page_transition/page_transition.dart';

import 'constants.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Block-TODO',
      home: SafeArea(
        child: AnimatedSplashScreen(
          backgroundColor: kWhite,
          splash: 'assets/splash_screen.png',
          splashIconSize: 250,
          centered: true,
          duration: 500,
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.fade,
          nextScreen: MainPage(),
        ),
      ),
    );
  }
}
