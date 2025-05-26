import 'dart:convert';

import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:solana/solana.dart';
import 'package:solana_flutter/controllers/appController.dart';
import 'package:solana_web3/solana_web3.dart';

import '../../constants/colors.dart';
import '../../utilService/jupiterSwapService.dart';
import '../commonWidgets/bottomRectangularbtn.dart';

class Swap extends StatefulWidget {
  Swap({super.key});

  @override
  State<Swap> createState() => _SwapState();
}

class _SwapState extends State<Swap> {
  final appController = Get.find<AppController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor.value,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView(
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
                            'Swap',
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
                            width: 30,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      width: Get.width,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: cardcolor.value,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Swap Token',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                  letterSpacing: -0.15,
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Get.bottomSheet(
                                        clipBehavior: Clip.antiAlias,
                                        isScrollControlled: true,
                                        backgroundColor: primaryBackgroundColor.value,
                                        shape: OutlineInputBorder(
                                            borderSide: BorderSide.none, borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                                        slippageSettings());
                                  },
                                  child: Container(
                                      child: SvgPicture.asset(
                                    "assets/svg/Setting.svg",
                                  ))),
                            ],
                          ),
                          SizedBox(height: 24),
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 24),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: ShapeDecoration(
                                        color: shapeDecorationDarkColor.value,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    '0.00',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 28,
                                                      fontFamily: 'Poppins',
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.bottomSheet(
                                                          clipBehavior: Clip.antiAlias,
                                                          isScrollControlled: true,
                                                          backgroundColor: primaryBackgroundColor.value,
                                                          shape: OutlineInputBorder(
                                                              borderSide: BorderSide.none,
                                                              borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                                                          chooseToken());
                                                    },
                                                    child: Container(
                                                      // width: 78.03,
                                                      height: 32,
                                                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                                      clipBehavior: Clip.antiAlias,
                                                      decoration: ShapeDecoration(
                                                        color: cardcolor.value,
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                                      ),
                                                      child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Container(width: 20, height: 20, decoration: BoxDecoration(), child: Image.asset("assets/images/sol.png")),
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  'SOL',
                                                                  style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 12,
                                                                    fontFamily: 'Poppins',
                                                                    fontWeight: FontWeight.w400,
                                                                    height: 0.09,
                                                                    letterSpacing: -0.15,
                                                                  ),
                                                                ),
                                                                SizedBox(width: 4),
                                                                Icon(
                                                                  Icons.keyboard_arrow_down,
                                                                  color: Colors.white,
                                                                  size: 17,
                                                                ),
                                                              ],
                                                            ),
                                                          ]),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 18),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        'Balance:',
                                                        style: TextStyle(
                                                          color: labelColorPrimaryShade.value,
                                                          fontSize: 14,
                                                          fontFamily: 'Poppins',
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                      SizedBox(width: 6),
                                                      Text(
                                                        '2.8989 SOL',
                                                        style: TextStyle(
                                                          color: labelColorPrimaryShade.value,
                                                          fontSize: 14,
                                                          fontFamily: 'Poppins',
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 24),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: ShapeDecoration(
                                        color: shapeDecorationDarkColor.value,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    '0.00',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 28,
                                                      fontFamily: 'Poppins',
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.bottomSheet(
                                                          clipBehavior: Clip.antiAlias,
                                                          isScrollControlled: true,
                                                          backgroundColor: primaryBackgroundColor.value,
                                                          shape: OutlineInputBorder(
                                                              borderSide: BorderSide.none,
                                                              borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                                                          chooseToken());
                                                    },
                                                    child: Container(
                                                      // width: 78.03,Gesture
                                                      height: 32,
                                                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                                      clipBehavior: Clip.antiAlias,
                                                      decoration: ShapeDecoration(
                                                        color: cardcolor.value,
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                                      ),
                                                      child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Container(width: 20, height: 20, decoration: BoxDecoration(), child: Image.asset("assets/images/usdc.png")),
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  'USDC',
                                                                  style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 12,
                                                                    fontFamily: 'Poppins',
                                                                    fontWeight: FontWeight.w400,
                                                                    height: 0.09,
                                                                    letterSpacing: -0.15,
                                                                  ),
                                                                ),
                                                                SizedBox(width: 4),
                                                                Icon(
                                                                  Icons.keyboard_arrow_down,
                                                                  color: Colors.white,
                                                                  size: 17,
                                                                ),
                                                              ],
                                                            ),
                                                          ]),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 18),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        'Balance:',
                                                        style: TextStyle(
                                                          color: labelColorPrimaryShade.value,
                                                          fontSize: 14,
                                                          fontFamily: 'Poppins',
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                      SizedBox(width: 6),
                                                      Text(
                                                        '2.8989 USDC',
                                                        style: TextStyle(
                                                          color: labelColorPrimaryShade.value,
                                                          fontSize: 14,
                                                          fontFamily: 'Poppins',
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/svg/swapIcon.svg",
                                    height: 54,
                                    width: 54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    BottomRectangularBtn(onTapFunc: () {
                      _swapTokens();
                    }, btnTitle: "Swap")
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget chooseToken() {
    return Container(
      width: Get.width,
      height: Get.height * 0.4,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: shapeDecorationDarkColor.value,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: Get.width,
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Choose Token',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                      width: 24,
                      height: 24,
                      // padding:  EdgeInsets.all(7.12),
                      decoration: BoxDecoration(),
                      child: Center(child: Icon(Icons.close, color: Colors.white))),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Expanded(
            child: Container(
              width: Get.width,
              child: ListView.separated(
                itemCount: 5,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 12,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: Get.width,
                    height: 56,
                    padding: EdgeInsets.all(12),
                    decoration: ShapeDecoration(
                      color: shapeDecorationDarkColor.value,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.50, color: Color(0xFF36394A)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: 32,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(),
                                        child: Image.asset("assets/images/usdc.png"),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'USDC',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget slippageSettings() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: shapeDecorationDarkColor.value,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Get.width,
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Slippage Settings',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                      width: 24,
                      height: 24,
                      // padding:  EdgeInsets.all(7.12),
                      decoration: BoxDecoration(),
                      child: Center(child: Icon(Icons.close, color: Colors.white))),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Your transaction will fail if the price changes more than the slippage. The recommended default is ',
                  style: TextStyle(
                    color: subtextColor.value,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                TextSpan(
                  text: '0.1%',
                  style: TextStyle(
                    color: lightTextColor.value,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                TextSpan(
                  text: ' - too high of a value will result in an unfavorable trade.',
                  style: TextStyle(
                    color: subtextColor.value,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            width: 197,
            height: 40,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: ShapeDecoration(
                    color: primaryColor.value,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Center(
                      child: Container(
                    height: 2,
                    width: 10,
                    color: primaryBackgroundColor.value,
                  )),
                ),
                SizedBox(width: 32),
                Text(
                  '0.1%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    height: 0.06,
                  ),
                ),
                SizedBox(width: 32),
                Container(
                  padding: EdgeInsets.all(7.50),
                  decoration: ShapeDecoration(
                    color: primaryColor.value,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          CustomSlidingSegmentedControl<int>(
            fromMax: true,
            customSegmentSettings: CustomSegmentSettings(
              radius: 100,
              hoverColor: Colors.white,
              borderRadius: BorderRadius.circular(100),
              highlightColor: Colors.white,
              splashColor: Colors.white,
            ),
            isShowDivider: false,
            isStretch: true,
            initialValue: 1,
            children: {
              1: Text(
                '0.1%',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
              2: Text(
                '0.3%',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
              3: Text(
                '0.5%',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
              4: Text(
                '1%',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              )
            },
            decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(100), border: Border.all(width: 1, color: Color(0xFF36394A))),
            thumbDecoration: BoxDecoration(
              color: primaryColor.value,
              borderRadius: BorderRadius.circular(100),
            ),
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInToLinear,
            onValueChanged: (v) {
              print(v);
            },
          ),
          SizedBox(
            height: 32,
          ),
          BottomRectangularBtn(onTapFunc: () {}, btnTitle: "Confirm"),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  final JupiterSwapService _jupiterSwapService = JupiterSwapService();

  String inputMint = 'So11111111111111111111111111111111111111112'; // SOL mint address
  String outputMint = 'EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v'; // Replace with USDC mint address
  String amount = '100000000'; // Amount in lamports (100000000 = 0.1 SOL)
  int slippageBps = 50; // 0.5% slippage tolerance
  /*Future<void> _swapTokens() async {
    try {

      // Get a quote for swapping
      final quote = await _jupiterSwapService.getQuote(
        inputMint: inputMint,
        outputMint: outputMint,
        amount: amount,
        slippageBps: slippageBps,
      );
      print('Quote $quote');

      // Create a transaction
      var transaction ;

      // Add swap instructions to the transaction
      final route = quote['route']; // Get the swap route from the quote
      for (var instruction in route['instructions']) {
        final swapInstruction = TransactionInstruction(
          programId: instruction['programId'],
          keys: List.from(instruction['keys']),
          data: base64Decode(instruction['data']),
        );
        transaction.add(swapInstruction);
      }
      final storage = FlutterSecureStorage();
      String? mnemonic =  await storage.read(key: 'mnemonic');
      final keypair = await Ed25519HDKeyPair.fromMnemonic(mnemonic!);
      // Sign the transaction
      await transaction.sign([keypair]);

      // Send the transaction to the network
      final response = await _jupiterSwapService.executeSwap(
        route: jsonEncode(route),
        userPublicKey: appController.publicKey.value,
        signature: base64Encode(transaction.serialize()),
      );

      print('Swap successful: $response');
    } catch (e) {
      print('Error: $e');
    }
  }*/

  Future<void> _swapTokens() async {
    try {
      // Create a wallet if not created already

      // Get a quote for swapping
      final quote = await _jupiterSwapService.getQuote(
        inputMint: inputMint,
        outputMint: outputMint,
        amount: amount,
        slippageBps: slippageBps,
      );

      // Extract relevant swap information
      final routePlan = quote['routePlan'];
      var transaction;
print('quote $quote');

      Pubkey pb = Pubkey.fromBase58(appController.publicKey.value);
      // Create swap instructions based on routePlan
      for (var swap in routePlan) {
        final swapInfo = swap['swapInfo'];
        final instruction = TransactionInstruction(
          programId: swapInfo['ammKey'], // AMM program ID
          keys: [
            AccountMeta(
              pb, // User's wallet public key
              isSigner: true,
              isWritable: true,
            ),
            // Additional keys required for swap, add them based on the swapInfo structure
            // These typically include:
            // - Input account (where SOL is held)
            // - Output account (where USDC will be sent)
            // - Any other accounts needed based on the specific swap protocol
          ],
          data: base64Decode(swapInfo['data'] ?? ''), // Ensure you have the correct data field
        );

        transaction.add(instruction);
      }

      // Sign the transaction
      final storage = FlutterSecureStorage();
      String? mnemonic =  await storage.read(key: 'mnemonic');
      final keypair = await Ed25519HDKeyPair.fromMnemonic(mnemonic!);
      // Sign the transaction
      await transaction.sign([keypair]);

      // Serialize the signed transaction for submission
      final signedTransactionBase64 = base64Encode(transaction.serialize());

      // Execute the swap
      final swapResult = await _jupiterSwapService.executeSwap(
        route: quote['route'],
        userPublicKey: appController.publicKey.value,
        signature: signedTransactionBase64,
      );

      print('Swap successful: $swapResult');
    } catch (e) {
      print('Error: $e');
    }
  }
}
