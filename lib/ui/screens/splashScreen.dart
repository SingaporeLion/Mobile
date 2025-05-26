import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solana_flutter/ui/screens/createWallet/createNewWallet.dart';
import 'package:solana_flutter/ui/screens/homeScreen.dart';
import 'package:solana_flutter/ui/screens/importFromSeed.dart';
import 'package:solana_flutter/ui/screens/prefereces.dart';
import 'package:solana_flutter/ui/screens/verifyPassword.dart';

import '../../constants/colors.dart';
import '../commonWidgets/bottomNav/bottomNavBar.dart';
import '../commonWidgets/navCustom.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor.value,
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 100,
              ),
              SvgPicture.asset("assets/svg/splash.svg"),
              Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context, PageTransition(duration: Duration(milliseconds: 100), type: PageTransitionType.topToBottom, child: ImportFromSeed()));
                      },
                      child: Container(
                        width: Get.width,
                        height: 48,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: ShapeDecoration(
                          color: cardcolor.value,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Import Using Seed Phrase',
                              style: TextStyle(
                                color: primaryColor.value,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 0.09,
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context, PageTransition(duration: Duration(milliseconds: 100), type: PageTransitionType.topToBottom, child: CreaateNewWallet()));
                      },
                      child: Container(
                        width: Get.width,
                        height: 48,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: ShapeDecoration(
                          color: primaryColor.value,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Create a New Wallet',
                              style: TextStyle(
                                color: textDarkColor.value,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 0.09,
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(height: 36),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StartingPage extends StatefulWidget {
  const StartingPage({super.key});

  @override
  State<StartingPage> createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    redirect();
  }

  redirect() {
    Future.delayed(Duration(milliseconds: 500), () async {
      SharedPreferences sharedPref = await SharedPreferences.getInstance();
      final storage = FlutterSecureStorage();
      if (sharedPref.containsKey('FingerPrintEnable') && await sharedPref.getBool('FingerPrintEnable') == true) {
        if (await storage.containsKey(key: 'mnemonic')) {
          Get.offAll(VerifyPassword(fromPage: 'splash',));
        } else {
          Get.offAll(SplashScreen());
        }
      } else if (await storage.containsKey(key: 'password')) {
        Get.offAll(BottomNavigationBar1());
      } else {
        Get.offAll(SplashScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor.value,
    );
  }
}
