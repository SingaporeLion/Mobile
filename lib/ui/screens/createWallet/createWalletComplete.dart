import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:horizontal_stepper_flutter/horizontal_stepper_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:solana/solana.dart';
import 'package:solana_flutter/constants/colors.dart';
import 'package:solana_flutter/ui/commonWidgets/bottomRectangularbtn.dart';
import 'package:solana_flutter/ui/commonWidgets/inputFields.dart';
import 'package:solana_flutter/ui/screens/resetApp.dart';

import '../../commonWidgets/bottomNav/bottomNavBar.dart';
import '../../commonWidgets/navCustom.dart';

class CreateWalletComplete extends StatefulWidget {
  const CreateWalletComplete({super.key, required this.mnemonic, required this.passWord});
  final String mnemonic;
  final String passWord;

  @override
  State<CreateWalletComplete> createState() => _CreateWalletCompleteState();
}

class _CreateWalletCompleteState extends State<CreateWalletComplete> {
  bool userFaceId = true;
  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    height: 16,
                  ),
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
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: ShapeDecoration(
                                    color: primaryColor.value,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: 121,
                                    height: 4,
                                    decoration: ShapeDecoration(
                                      color: primaryColor.value,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 18,
                                  height: 18,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: ShapeDecoration(
                                    color: primaryColor.value,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: 121,
                                    height: 4,
                                    decoration: ShapeDecoration(
                                      color: primaryColor.value,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 18,
                                  height: 18,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: ShapeDecoration(
                                    color: primaryColor.value,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 32,
                          child: Text(
                            '3/3',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              height: 0.12,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 32,
                  ),
                  SvgPicture.asset("assets/svg/check-select.svg"),
                  SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    width: 311,
                    child: Text(
                      'Congratulations',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    width: 311,
                    child: Text(
                      '''You've successfully protected your wallet. Remember to keep your seed phrase safe, it's your responsibility!''',
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
                    height: 24,
                  ),
                  SizedBox(
                    width: 311,
                    child: Text(
                      'ELLAsset cannot recover your wallet should you lose it. You can find your seedphrase in\nSetings > Security & Privacy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: labelColorPrimaryShade.value,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  BottomRectangularBtn(
                      // color: shapeDecorationColor.value,

                      // isDisabled: true,
                      onTapFunc: () {
                        createWallet();
                      },
                      btnTitle: "Take me in"),
                  SizedBox(
                    height: 32,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  createWallet() async {
    final keypair = await Ed25519HDKeyPair.fromMnemonic(widget.mnemonic);
    print("keypair ${keypair.address}");
    print("keypair ${keypair.publicKey}");
    print("mnemonic ${widget.mnemonic}");
    final storage = FlutterSecureStorage();
    await storage.write(key: 'password', value: widget.passWord);
    await storage.write(key: 'privKey', value: keypair.address);
    await storage.write(key: 'mnemonic', value: widget.mnemonic);
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
