import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:over_engineered/constants.dart';
import 'package:over_engineered/screens/completed_tasks.dart';
import 'package:over_engineered/screens/home_screen.dart';
import 'package:over_engineered/screens/profile_screen.dart';
import 'package:over_engineered/screens/rewards_screen.dart';

class HiddenDrawer extends StatefulWidget {
  HiddenDrawer({Key? key, this.email}) : super(key: key);
  final String? email;

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> _screens = [];
  late int coins = 0;
  // final String baseUrl = kIsWeb ? "http://localhost:4000" : "http://10.0.2.2:4000";
  final String baseUrl = "https://block-to-do.vercel.app";

  Future<Response?> getCoins() async {
    final Dio dio = Dio();
    Map<String, dynamic> mp = {
      'email': widget.email.toString(),
    };
    try {
      var response = await dio.get('$baseUrl/getcoins', queryParameters: mp);
      // print(response);
      return response;
    } on DioError catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    var response = getCoins();
    response.then((value) {
      Map<String, dynamic> data = jsonDecode(value.toString());
      setState(() {
        coins = data.values.first[0]['coins'];
      });
    });
    // coins = 0;
    // Map<String, dynamic> data = jsonDecode(response.first.toString());
    // print(data.toString());
    // List<dynamic> c = data.values.toList();
    // print(c.first);
    _screens = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'ToDo',
          baseStyle: const TextStyle(
            fontFamily: 'SSPRegular',
            fontSize: 20,
            color: kWhite,
          ),
          selectedStyle: const TextStyle(
            fontFamily: 'SSPBold',
            fontSize: 20,
            color: kWhite,
          ),
          colorLineSelected: kBlack,
        ),
        HomeScreen(
          coins: coins,
          email: widget.email!,
        ),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Profile',
          baseStyle: const TextStyle(
            fontFamily: 'SSPRegular',
            fontSize: 20,
            color: kWhite,
          ),
          selectedStyle: const TextStyle(
            fontFamily: 'SSPBold',
            fontSize: 20,
            color: kWhite,
          ),
          colorLineSelected: kBlack,
        ),
        ProfileScreen(email: widget.email!,),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Completed Tasks',
          baseStyle: const TextStyle(
            fontFamily: 'SSPRegular',
            fontSize: 20,
            color: kWhite,
          ),
          selectedStyle: const TextStyle(
            fontFamily: 'SSPBold',
            fontSize: 20,
            color: kWhite,
          ),
          colorLineSelected: kBlack,
        ),
        CompletedTasks(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Rewards',
          baseStyle: const TextStyle(
            fontFamily: 'SSPRegular',
            fontSize: 20,
            color: kWhite,
          ),
          selectedStyle: const TextStyle(
            fontFamily: 'SSPBold',
            fontSize: 20,
            color: kWhite,
          ),
          colorLineSelected: kBlack,
        ),
        RewardsScreen(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? HomeScreen(
            coins: coins,
            email: widget.email!,
          )
        : HiddenDrawerMenu(
            screens: _screens,
            backgroundColorMenu: kPrimary,
            initPositionSelected: 0,
            isTitleCentered: true,
            backgroundColorAppBar: kWhite,
            elevationAppBar: 0,
            slidePercent: 60,
            leadingAppBar: const Icon(
              Icons.menu_rounded,
              color: kPrimary,
              size: 35,
            ),
            styleAutoTittleName: const TextStyle(
              color: kPrimary,
              fontSize: 35,
              fontFamily: 'SSPBold',
            ),
            actionsAppBar: [
              Flex(
                  mainAxisSize: MainAxisSize.min,
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: kPrimary,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '$coins',
                                  style: const TextStyle(
                                    fontFamily: 'SSPBold',
                                    color: kCoins,
                                    fontSize: 16,
                                  ),
                                ),
                                Image.asset(
                                  'assets/coin.png',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ])
            ],
          );
  }
}
