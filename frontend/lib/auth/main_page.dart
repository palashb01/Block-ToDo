import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:over_engineered/hidden_drawer.dart';
import 'package:over_engineered/screens/home_screen.dart';
import 'package:over_engineered/screens/login_options.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<User?>(
          stream: _auth.authStateChanges(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return HiddenDrawer();
            } else{
              return LoginOptions();
            }
          },
        ),
      ),
    );
  }
}
