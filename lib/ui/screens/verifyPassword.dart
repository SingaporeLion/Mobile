import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solana_flutter/controllers/appController.dart';

import '../../constants/colors.dart';
import '../commonWidgets/bottomNav/bottomNavBar.dart';
import '../commonWidgets/bottomRectangularbtn.dart';
import '../commonWidgets/commonWidgets.dart';
import '../commonWidgets/inputFields.dart';
import '../commonWidgets/navCustom.dart';

class VerifyPassword extends StatefulWidget {
  const VerifyPassword({super.key, required this.fromPage});
  final String fromPage;

  @override
  State<VerifyPassword> createState() => _VerifyPasswordState();
}

class _VerifyPasswordState extends State<VerifyPassword> {
  TextEditingController passController = new TextEditingController();
  var passError = ''.obs;
  bool canAuthenticateWithBiometrics = false;
  final LocalAuthentication auth = LocalAuthentication();
  final appController = Get.find<AppController>();
  bool isDeviceSupported = false;
  @override
  void initState() {
    // TODO: implement initState

    secureScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryBackgroundColor.value,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Text(
                      'Verify Password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: 311,
                      child: Text(
                        widget.fromPage == 'splash' ? 'Please enter your password to unlock your SOLANA wallet.' : 'Please enter your password to continue.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: labelColorPrimaryShade.value,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    InputFieldPassword(
                      headerText: "",
                      hintText: "Password",
                      textController: passController,
                      onChange: (value) {
                        if (value != null && value != '') {
                          passError.value = '';
                        }
                      },
                    ),
                    CommonWidgets.showErrorMessage(passError.value),
                  ],
                ),
                Column(
                  children: [
                    BottomRectangularBtn(
                        onTapFunc: () async {
                          final storage = FlutterSecureStorage();
                          if (await storage.read(key: 'password') != passController.text) {
                            passError.value = 'Incorrect Password';
                          } else if (await storage.read(key: 'password') == passController.text) {
                            if (widget.fromPage == 'splash') {
                              Get.offAll(BottomNavigationBar1());
                            } else {
                              Get.back(result: 'verified');
                            }
                          }
                        },
                        btnTitle: "Verify"),
                    SizedBox(
                      height: 32,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> secureScreen() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    if (sharedPref.containsKey('FingerPrintEnable') && await sharedPref.getBool('FingerPrintEnable') == true) {
      var verificationStats = sharedPref.getBool('FingerPrintEnable');
      appController.enabledBiometric.value = verificationStats!;
      if (verificationStats == true) {
        canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
        isDeviceSupported = await auth.isDeviceSupported();
        final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
        authenticate();
      }
    }
  }

  authenticate() async {
    print('authenticate');
    try {
      final bool didAuthenticate = await auth
          .authenticate(
        localizedReason: 'Please authenticate to show account balance',
        options: const AuthenticationOptions(useErrorDialogs: false, stickyAuth: true),
      )
          .then((value) {
        print('value==========$value');
        if (value == true) {
          if (widget.fromPage == 'splash') {
            Get.offAll(BottomNavigationBar1(), duration: Duration(milliseconds: 300), transition: Transition.rightToLeft);
          } else {
            Get.back(result: 'verified');
          }
        }
        return value;
      });
      print('didAuth============$didAuthenticate');
      await auth.stopAuthentication();
    } on PlatformException catch (e) {
      print('ex============$e');
    }
  }
}
