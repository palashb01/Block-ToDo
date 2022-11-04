import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:over_engineered/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({Key? key}) : super(key: key);

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  @override
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
  final Uri _urlYoutube = Uri.parse('https://youtube.com');
  final Uri _urlPornhub = Uri.parse('https://pornhub.com');
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: w / 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: kPrimary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: kIsWeb ? w/2 : w / 1.3,
                    height: kIsWeb ? h/2 : h / 4,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/youtube.png',
                                width: w / 5,
                                height: w / 5,
                              ),
                              SizedBox(
                                width: w / 50,
                              ),
                              const Text(
                                'Youtube Premium',
                                style: TextStyle(
                                  color: kWhite,
                                  fontFamily: 'SSPBold',
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(
                          //   height: w/00,
                          // ),
                          const Text(
                            '500 Coins',
                            style: TextStyle(
                              fontSize: 40,
                              fontFamily: 'SSPBold',
                              color: kCoins,
                            ),
                          ),
                          SizedBox(
                            height: h/100,
                          ),
                          TextButton(
                            onPressed: (){
                              _launchInBrowser(_urlYoutube);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: kCoins,
                              minimumSize: Size(h/10, h/25),
                            ),
                            child: const Text(
                              'Redeem',
                              style: TextStyle(
                                color: kPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: w / 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: kPrimary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: kIsWeb ? w/2 : w / 1.3,
                    height: kIsWeb ? h/2 : h / 4,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width:w/30,
                              ),
                              Image.asset(
                                'assets/pornhub.png',
                                width: w / 5,
                                height: w / 5,
                              ),
                              SizedBox(
                                width: w / 50,
                              ),
                              const Text(
                                'Pornhub Premium',
                                style: TextStyle(
                                  color: kWhite,
                                  fontFamily: 'SSPBold',
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(
                          //   height: w/00,
                          // ),
                          const Text(
                            '669 Coins',
                            style: TextStyle(
                              fontSize: 40,
                              fontFamily: 'SSPBold',
                              color: kCoins,
                            ),
                          ),
                          SizedBox(
                            height: h/100,
                          ),
                          TextButton(
                            onPressed: () {
                              _launchInBrowser(_urlPornhub);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: kCoins,
                              minimumSize: Size(h/10, h/25),
                            ),
                            child: const Text(
                              'Redeem',
                              style: TextStyle(
                                color: kPrimary,
                              ),
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
      ),
    );
  }
}
