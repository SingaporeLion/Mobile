import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solana_flutter/ui/commonWidgets/bottomRectangularbtn.dart';
import 'package:solana_flutter/ui/screens/splashScreen.dart';
import 'package:solana_flutter/ui/screens/transactions.dart';

import '../../constants/colors.dart';

class ResetApp extends StatefulWidget {
  ResetApp({super.key});

  @override
  State<ResetApp> createState() => _ResetAppState();
}

class _ResetAppState extends State<ResetApp> {
  bool userFaceId = true;
  bool isPasscode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor.value,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: Get.width,
                // height: 44,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 32,
                        width: 32,
                        padding: EdgeInsets.all(6),
                        decoration: ShapeDecoration(
                          color: cardcolor.value,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                    Text(
                      'Reset App',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 0.09,
                      ),
                    ),
                    SizedBox(
                      width: 24,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 32,
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    padding: EdgeInsets.all(30),
                    decoration: ShapeDecoration(
                      color: Color(0x33FF5C5C),
                      shape: OvalBorder(),
                    ),
                    child: SvgPicture.asset("assets/svg/fluent_key-reset-24-regular.svg"),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Text(
                    'Reset & Wipe Data',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: lightTextColor.value,
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Text(
                    'This will remove all existing accounts & data. Make sure you have your secret phrase & private keys backed up.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: subtextColor.value,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      // Get.to(Transactions());
                      final storage = FlutterSecureStorage();
                      await storage.deleteAll();
                      SharedPreferences sharedPref = await SharedPreferences.getInstance();
                      await sharedPref.clear();
                      Get.offAll(SplashScreen());
                    },
                    child: Container(
                      height: 50,
                      width: Get.width,
                      decoration: BoxDecoration(color: Color(0xFFFF5C5C), borderRadius: BorderRadius.circular(100)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue',
                            style: TextStyle(
                              color: lightTextColor.value,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 50,
                      width: Get.width,
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.white), borderRadius: BorderRadius.circular(100)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Cancel',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
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
