import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solana/solana.dart';
import 'package:solana_flutter/ui/commonWidgets/bottomRectangularbtn.dart';
import 'package:solana_flutter/ui/commonWidgets/inputFields.dart';
import 'package:solana_flutter/ui/screens/resetApp.dart';
import 'package:bip39/bip39.dart' as bip39;

import '../../constants/colors.dart';
import '../../controllers/appController.dart';
import '../commonWidgets/bottomNav/bottomNavBar.dart';
import '../commonWidgets/commonWidgets.dart';
import '../commonWidgets/navCustom.dart';

class ImportFromSeed extends StatefulWidget {
  ImportFromSeed({super.key});

  @override
  State<ImportFromSeed> createState() => _ImportFromSeedState();
}

class _ImportFromSeedState extends State<ImportFromSeed> {
  final appController = Get.find<AppController>();
  bool userFaceId = true;
  bool isPasscode = true;
  TextEditingController mnemonicController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController confirmPassController = new TextEditingController();
  var passError = ''.obs;
  var mnemonicError = ''.obs;
  var confirmPassError = ''.obs;
  var importLoader = false.obs;

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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            'Import From Seed',
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
                    SizedBox(
                      height: 32,
                    ),
                    InputFields(
                        headerText: "",
                        hintText: "****  *****  *****  ***** *****",
                        hasHeader: false,
                        textController: mnemonicController,
                        onChange: (v) {
                          mnemonicError.value = '';
                        }),
                    CommonWidgets.showErrorMessage(mnemonicError.value),
                    InputFieldPassword(
                      headerText: "",
                      hintText: "New Password",
                      textController: passController,
                      onChange: (value) {
                        if (value != null && value != '') {
                          passError.value = '';
                        }
                      },
                    ),
                    CommonWidgets.showErrorMessage(passError.value),
                    InputFieldPassword(
                      headerText: "",
                      hintText: "Confirm Password",
                      textController: confirmPassController,
                      onChange: (value) {
                        if (value != null && value != '') {
                          confirmPassError.value = '';
                        }
                      },
                    ),
                    CommonWidgets.showErrorMessage(confirmPassError.value),
                    Row(
                      children: [
                        Text(
                          'Must be at least 8 characters',
                          style: TextStyle(
                            color: labelColorPrimaryShade.value,
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 0.11,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 150,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sign in with Face ID?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Archivo',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        FlutterSwitch(
                          width: 50.0,
                          height: 25.0,
                          valueFontSize: 20.0,
                          toggleSize: 20.0,
                          value: appController.enabledBiometric.value,
                          borderRadius: 30.0,
                          toggleColor: primaryColor.value,
                          activeColor: Color(0xFF242438),
                          inactiveColor: Color(0xFF242438),
                          padding: 2.0,
                          showOnOff: false,
                          onToggle: (val) {
                            appController.enabledBiometric.value = val;
                            enableBiometric(context, val);
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Byproceeding, you agree to these ',
                            style: TextStyle(
                              color: labelColorPrimaryShade.value,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: 'Term and Conditions.',
                            style: TextStyle(
                              color: primaryColor.value,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      height: 48,
                        child: BottomRectangularBtn(
                          color: shapeDecorationColor.value,
                            buttonTextColor: Colors.white,
                            onTapFunc: (){
                              verifyFields();
                            },
                            isLoading: importLoader.value,
                            loadingText: 'Processing...',
                            btnTitle: 'Import')),
                    /*GestureDetector(
                      onTap: () async {
                        verifyFields();
                      },
                      child: Container(
                        width: Get.width,
                        height: 48,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: ShapeDecoration(
                          color: shapeDecorationColor.value,
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
                              'Import',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 0.09,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),*/
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

  verifyFields() async {
    importLoader.value = true;
    setState(() {});
    if (mnemonicController.text.trim() == '') {
      mnemonicError.value = 'Please Enter 12 words Secret Phrase';
      importLoader.value = false;
      setState(() {});
    } else if (bip39.validateMnemonic(mnemonicController.text.trim()) == false) {
      mnemonicError.value = 'Invalid Secret Phrase';
      importLoader.value = false;
      setState(() {});
    } else if (passController.text.length < 8) {
      passError.value = 'Minimum length should be 8';
      importLoader.value = false;
      setState(() {});
    } else if (!lowerCase.hasMatch(passController.text)) {
      passError.value = 'Minimum 1 lowercase character required';
      importLoader.value = false;
      setState(() {});
    } else if (!upperCase.hasMatch(passController.text)) {
      passError.value = 'Minimum 1 uppercase character required';
      importLoader.value = false;
      setState(() {});
    } else if (!containsNumber.hasMatch(passController.text)) {
      passError.value = 'Minimum 1 digit required';
      importLoader.value = false;
      setState(() {});
    } else if (!hasSpecialCharacters.hasMatch(passController.text)) {
      passError.value = 'Minimum 1 special character required';
      importLoader.value = false;
      setState(() {});
    } else if (passController.text != confirmPassController.text) {
      confirmPassError.value = 'Password didn’t match with the first one.';
      importLoader.value = false;
      setState(() {});
    } else {
      print("bip39.validateMnemonic ${bip39.validateMnemonic(mnemonicController.text.trim())}");
      final seed = bip39.mnemonicToSeed(mnemonicController.text.trim());
      print("seed $seed");
      Ed25519HDKeyPair keypair = await Wallet.fromMnemonic(mnemonicController.text);
      print("keypair ${keypair.address}");
      print("keypair ${keypair.publicKey}");
      final storage = FlutterSecureStorage();
      await storage.write(key: 'password', value: passController.text);
      await storage.write(key: 'privKey', value: keypair.address);
      await storage.write(key: 'mnemonic', value: mnemonicController.text.trim());
      importLoader.value = false;
      setState(() {});
      Navigator.pushReplacement(
        context,
        PageTransition(
          duration: Duration(milliseconds: 100),
          type: PageTransitionType.topToBottom,
          child: BottomNavigationBar1(),
        ),
      );
    }
  }
  enableBiometric(context, val) async {
    final LocalAuthentication auth = LocalAuthentication();
    final canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final isDeviceSupported = await auth.isDeviceSupported();
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    if (isDeviceSupported && canAuthenticateWithBiometrics) {
      try {
        final bool didAuthenticate = await auth
            .authenticate(
          localizedReason: 'Please authenticate to show account balance',
          options: const AuthenticationOptions(useErrorDialogs: false, stickyAuth: true),
        )
            .then((value) async {
          if (value == true) {
            await sharedPref.setBool('FingerPrintEnable', val);
            setState(() {
              appController.enabledBiometric.value = val;
            });
          }
          return value;
        });
        print('didAuth============$didAuthenticate');
        await auth.stopAuthentication();
      } on PlatformException catch (e) {
        print('ex============$e');
      }
    } else {
      await sharedPref.setBool('FingerPrintEnable', val);
      setState(() {
        appController.enabledBiometric.value = val;
      });
    }
  }
}
