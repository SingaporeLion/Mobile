import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
      // Optional: Dark/Light background als Fallback
      backgroundColor: primaryBackgroundColor.value,
      body: Stack(
        children: [
          // Das Splash-Bild fullscreen im Hintergrund
          Positioned.fill(
            child: Image.asset(
              "assets/images/launch_screen.png",
              fit: BoxFit.cover,
            ),
          ),
          // Foreground: Die Buttons am unteren Rand
          Positioned(
            left: 0,
            right: 0,
            bottom: 32, // Abstand von unten
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          duration: Duration(milliseconds: 100),
                          type: PageTransitionType.topToBottom,
                          child: ImportFromSeed(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      padding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: ShapeDecoration(
                        color: cardcolor.value.withOpacity(0.85),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Import Using Seed Phrase',
                          style: TextStyle(
                            color: primaryColor.value,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          duration: Duration(milliseconds: 100),
                          type: PageTransitionType.topToBottom,
                          child: CreaateNewWallet(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      padding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: ShapeDecoration(
                        color: primaryColor.value.withOpacity(0.9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Create a New Wallet',
                          style: TextStyle(
                            color: textDarkColor.value,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ],
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
    super.initState();
    redirect();
  }

  redirect() {
    Future.delayed(Duration(milliseconds: 500), () async {
      SharedPreferences sharedPref = await SharedPreferences.getInstance();
      final storage = FlutterSecureStorage();
      if (sharedPref.containsKey('FingerPrintEnable') &&
          await sharedPref.getBool('FingerPrintEnable') == true) {
        if (await storage.containsKey(key: 'mnemonic')) {
          Get.offAll(
            VerifyPassword(fromPage: 'splash'),
          );
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
