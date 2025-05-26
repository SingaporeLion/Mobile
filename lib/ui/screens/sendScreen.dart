import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'qr_scan_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:get/get.dart';
//import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:solana/dto.dart';
import 'package:solana/solana.dart';
import 'package:solana_flutter/ui/screens/transactions.dart';
import 'package:solana_flutter/ui/screens/verifyPassword.dart';

import '../../../constants/colors.dart';
import '../../../controllers/appController.dart';
import '../../../utilService/UtilService.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:solana/solana.dart' as solana;

import '../../../utilService/dataService.dart';
import '../commonWidgets/bottomRectangularbtn.dart';
import '../commonWidgets/commonWidgets.dart';
import '../commonWidgets/keyboardDone.dart';

class SendScreen extends StatefulWidget {
  SendScreen({super.key, this.index, required this.onSend});
  int? index;
  final Function onSend;

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  final appController = Get.find<AppController>();
  TextEditingController toAddressController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  var addressErr = ''.obs;
  var amountErr = ''.obs;
  var fee = 0.0.obs;
  var selectedTokenIndex = 0.obs;
  var isSending = false.obs;
  var feeLoader = false.obs;
  FocusNode numberFocusNode = FocusNode();
  var createPlatformAccountMessage;
  var platformATA;
  var createAccountMesagge;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isIOS) {
      numberFocusNode.addListener(() {
        bool hasFocus = numberFocusNode.hasFocus;
        if (hasFocus) {
          KeyboardOverlay.showOverlay(context);
        } else {
          KeyboardOverlay.removeOverlay();
        }
      });
    }
    getPlatformData();
    selectedTokenIndex.value = widget.index ?? 0;
  }

  getPlatformData() async {
    DataService().fetchPlatformData().then((data) {
      if (data != null) {
        appController.platformFeeAddress.value = data['feeReceiverAddress'];
        appController.platformFee.value = data['platformFeePercentage'];
      }
      print('feeReceiverAddress ${appController.platformFeeAddress.value}');
      print('platformFeePercentage ${appController.platformFee.value}');
    });
  }

  @override
  void dispose() {
    // Clean up the focus node
    numberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: primaryBackgroundColor.value,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
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
                                  'Send',
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
                            height: 40,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: appController.tokenList.length,
                              itemBuilder: (BuildContext context, int index) {
                                print(appController.tokenList.length);
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedTokenIndex.value = index;
                                      amountController.clear();
                                      toAddressController.clear();
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: selectedTokenIndex.value == index ? Color(0x2670EDEF) : cardcolor.value,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Center(
                                      child: Text(
                                        '${appController.tokenList[index].symbol}',
                                        style: TextStyle(
                                          color: selectedTokenIndex.value == index ? Colors.white : labelColorPrimaryShade.value,
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return SizedBox(width: 16);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'To:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: toAddressController,
                                  cursorColor: primaryColor.value,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Wallet Address",
                                    hintStyle: TextStyle(
                                      color: labelColorPrimaryShade.value,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    border: OutlineInputBorder(borderSide: BorderSide.none),
                                  ),
                                  onChanged: (v) {
                                    addressErr.value = '';
                                  },
                                ),
                              ),
                              SizedBox(width: 4),
                              GestureDetector(
                                onTap: () async {
                                  final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                                  toAddressController.text = clipboardData?.text ?? '';
                                  setState(() {});
                                  addressErr.value = '';
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: ShapeDecoration(
                                    color: Color(0x2670EDEF),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Paste',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  scanQR();
                                },
                                child: Container(
                                  height: 32,
                                  width: 32,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(0x2670EDEF)),
                                  child: SvgPicture.asset(
                                    "assets/svg/scan.svg",
                                    color: primaryColor.value,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      CommonWidgets.showErrorMessage(addressErr.value),
                      SizedBox(
                        height: Get.height * 0.085,
                      ),
                      Container(
                        width: Get.width,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${appController.tokenList[selectedTokenIndex.value].balance} ${appController.tokenList[selectedTokenIndex.value].symbol} available',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: labelColorPrimaryShade.value,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 12),
                            Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 50,
                                    width: Get.width,
                                    child: TextFormField(
                                      controller: amountController,
                                      cursorColor: primaryColor.value,
                                      textAlign: TextAlign.center,
                                      focusNode: numberFocusNode,
                                      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 36,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "0 ${appController.tokenList[selectedTokenIndex.value].symbol}",
                                        hintStyle: TextStyle(
                                          color: labelColorPrimaryShade.value,
                                          fontSize: 36,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        border: OutlineInputBorder(borderSide: BorderSide.none),
                                      ),
                                      onChanged: (v) {
                                        amountErr.value = '';
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CommonWidgets.showErrorMessage(amountErr.value),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  amountController.text = (appController.tokenList[selectedTokenIndex.value].balance ?? 0).toString();
                                  amountErr.value = '';
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: ShapeDecoration(
                                  color: Color(0x1970ECEF),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Max',
                                      style: TextStyle(
                                        color: primaryColor.value,
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 100,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                BottomRectangularBtn(
                    onTapFunc: () async {
                      if (toAddressController.text.trim() == '') {
                        addressErr.value = 'Please enter the address';
                      } else if (amountController.text.trim() == '') {
                        amountErr.value = 'Please enter an amount';
                      } else if (double.parse(amountController.text) <= 0) {
                        amountErr.value = 'Amount should be greater than 0.';
                      } else if (double.parse(amountController.text) > (appController.tokenList[selectedTokenIndex.value].balance ?? 0)) {
                        amountErr.value = 'Insufficient Balance.';
                      } else {
                        /*await UtilService().getTransactionFee().then((value) {
                          if (value != null) {
                            print('fee: $value');
                            fee.value = value;
                            Get.bottomSheet(
                                clipBehavior: Clip.antiAlias,
                                isScrollControlled: true,
                                shape:
                                OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                                confirmTransfer());
                          }
                        });*/

                        double amount = double.parse(amountController.text);
                        if (selectedTokenIndex.value == 0) {
                          await getFee_Sol(toAddressController.text, amount);
                        } else {
                          await getFeeToken(
                              mint: appController.tokenList[selectedTokenIndex.value].tokenAddress ?? '',
                              address: toAddressController.text,
                              amount: double.parse(amountController.text),
                              decimals: (appController.tokenList[selectedTokenIndex.value].decimals)!.toInt());
                        }
                      }
                    },
                    btnTitle: "Send")
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget confirmTransfer(client, message, mainWalletSolana) {
    getPlatformData();
    return Obx(
      () => Container(
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
                  SizedBox(),
                  Text(
                    'Confirm Transfer',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
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
            SizedBox(height: 24),
            SizedBox(
              width: 311,
              child: Text(
                'We care about your privacy.  Please make sure that you want to transfer crypto.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: subtextColor.value,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
            SizedBox(height: 24),
            Container(
              width: Get.width,
              padding: EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
                bottom: 24,
              ),
              decoration: ShapeDecoration(
                color: cardcolor.value,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'To',
                          style: TextStyle(
                            color: labelColorPrimaryShade.value,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${toAddressController.text}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Divider(
                    height: 0.5,
                    thickness: 0.1,
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 52,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount',
                          style: TextStyle(
                            color: labelColorPrimaryShade.value,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${amountController.text} ${appController.tokenList[selectedTokenIndex.value].symbol}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                              /*SizedBox(width: 4),
                              Text(
                                'US\$0.00',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: labelColorPrimaryShade.value,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),*/
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: Get.width,
              padding: EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
                bottom: 24,
              ),
              decoration: ShapeDecoration(
                color: cardcolor.value,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 52,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transfer Fee',
                          style: TextStyle(
                            color: labelColorPrimaryShade.value,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${fee.value} SOL',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            /*SizedBox(height: 16),
            Container(
              width: Get.width,
              padding: EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
                bottom: 24,
              ),
              decoration: ShapeDecoration(
                color: cardcolor.value,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 52,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Platform Fee',
                          style: TextStyle(
                            color: labelColorPrimaryShade.value,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${appController.platformFee.value}%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                              */ /*SizedBox(width: 4),
                              Text(
                                'US\$0.00',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: labelColorPrimaryShade.value,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),*/ /*
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),*/
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isSending.value == true
                    ? Row(
                        children: [
                          SizedBox(
                            height: 28.0,
                            width: 28.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 3.0,
                              color: primaryColor.value,
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Processing...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          )
                        ],
                      )
                    : Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), border: Border.all(width: 1, color: Color(0x1970ECEF))),
                        child: SwipeButton(
                          activeTrackColor: primaryBackgroundColor.value,
                          activeThumbColor: primaryColor.value,
                          height: 60,
                          width: 255,
                          thumbPadding: EdgeInsets.all(7),
                          trackPadding: EdgeInsets.all(0),
                          elevationThumb: 10,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 60,
                              ),
                              Text(
                                'Swipe to Confirm Transfer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              )
                            ],
                          ),
                          onSwipeEnd: () async {
                            double amount = double.parse(amountController.text);
                            if (selectedTokenIndex.value == 0) {
                              if (appController.enabledBiometric.value == true) {
                                Get.to(VerifyPassword(fromPage: 'send'))!.then((value) {
                                  if (value == 'verified') {
                                    List<Ed25519HDKeyPair> l = [];
                                    l.add(mainWalletSolana);
                                    send_sol(client, message, l).then((value) async {
                                      if (value != null && value != '') {
                                        Get.back();
                                        widget.onSend.call();
                                        Get.bottomSheet(
                                          clipBehavior: Clip.antiAlias,
                                          isScrollControlled: true,
                                          shape: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(32),
                                              topLeft: Radius.circular(32),
                                            ),
                                          ),
                                          transationSuccessful(),
                                        );
                                      }
                                    });
                                  }
                                });
                              } else {
                                List<Ed25519HDKeyPair> l = [];
                                l.add(mainWalletSolana);
                                send_sol(client, message, l).then((value) async {
                                  if (value != null && value != '') {
                                    Get.back();
                                    widget.onSend.call();
                                    Get.bottomSheet(
                                      clipBehavior: Clip.antiAlias,
                                      isScrollControlled: true,
                                      shape: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(32),
                                          topLeft: Radius.circular(32),
                                        ),
                                      ),
                                      transationSuccessful(),
                                    );
                                  }
                                });
                              }
                            } else {
                              if (appController.enabledBiometric.value == true) {
                                Get.to(VerifyPassword(fromPage: 'send'))!.then((value) {
                                  if (value == 'verified') {
                                    send_token(client, message, mainWalletSolana).then((value) async {
                                      if (value != null && value != '') {
                                        Get.back();
                                        widget.onSend.call();
                                        Get.bottomSheet(
                                            clipBehavior: Clip.antiAlias,
                                            isScrollControlled: true,
                                            shape: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(32),
                                                topLeft: Radius.circular(32),
                                              ),
                                            ),
                                            transationSuccessful());
                                      }
                                    });
                                  }
                                });
                              } else {
                                send_token(client, message, mainWalletSolana).then((value) async {
                                  if (value != null && value != '') {
                                    Get.back();

                                    Get.bottomSheet(
                                      clipBehavior: Clip.antiAlias,
                                      isScrollControlled: true,
                                      shape: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(32),
                                          topLeft: Radius.circular(32),
                                        ),
                                      ),
                                      transationSuccessful(),
                                    );
                                  }
                                });
                              }
                            }
                          },
                          onSwipe: () {},
                        ),
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget transationSuccessful() {
    return Container(
      width: Get.width,
      height: Get.height * 0.8,
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
                SizedBox(),
                Text(
                  'Transfer Successful',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
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
                    child: Center(
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: Get.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: ShapeDecoration(
                    color: Color(0x1903F982),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFF1A1A1A)),
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        child: SvgPicture.asset(
                          "assets/svg/transactionSuccess.svg",
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: Get.width * 0.8,
                  child: Text(
                    'Your transaction has been completed, view details in transaction history.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: subtextColor.value,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(Transactions());
                },
                child: Container(
                  height: 50,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: primaryColor.value,
                    borderRadius: BorderRadius.circular(
                      100,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'View History',
                        style: TextStyle(
                          color: textDarkColor.value,
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
                  Get.back();
                },
                child: Container(
                  height: 50,
                  width: Get.width,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: primaryColor.value,
                      ),
                      borderRadius: BorderRadius.circular(100)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Home',
                        style: TextStyle(
                          color: primaryColor.value,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 76),
            ],
          ),
        ],
      ),
    );
  }

  getFee_Sol(String address, double amount) async {
    feeLoader.value = true;
    final storage = FlutterSecureStorage();
    final client = solana.SolanaClient(
      rpcUrl: Uri.parse(appController.rpcUrl),
      websocketUrl: Uri.parse(appController.wssUrl),
      timeout: Duration(seconds: 120),
    );

    final mainWalletKey = await storage.read(key: 'mnemonic');

    final mainWalletSolana = await solana.Ed25519HDKeyPair.fromMnemonic(
      mainWalletKey!,
    );

    final destinationAddress = solana.Ed25519HDPublicKey.fromBase58(address);

    // Calculate the amounts
    int lamportAmount = (amount * solana.lamportsPerSol).toInt();
    int platformAmount = (lamportAmount * (appController.platformFee.value! / 100)).toInt();

    print('Destination amount: $lamportAmount');
    print('Platform amount: $platformAmount');

    // Create the transfer instruction for the destination address
    final instructionToDestination = solana.SystemInstruction.transfer(
      fundingAccount: mainWalletSolana.publicKey,
      recipientAccount: destinationAddress,
      lamports: lamportAmount,
    );

    // Platform address
    final platformAddress = solana.Ed25519HDPublicKey.fromBase58(appController.platformFeeAddress.value);

    // Create the transfer instruction for the platform address
    final instructionToPlatform = solana.SystemInstruction.transfer(
      fundingAccount: mainWalletSolana.publicKey,
      recipientAccount: platformAddress,
      lamports: platformAmount,
    );

    // Combine both instructions into a single message
    final message = solana.Message(instructions: [instructionToDestination, instructionToPlatform]);
    print('initialmesage ${message}');
    final feePayer = solana.Ed25519HDPublicKey.fromBase58(appController.publicKey.value);
    String blockHash = await UtilService().getLatestBlockhash(appController.rpcUrl);
    print('message => ${message.compile(recentBlockhash: blockHash, feePayer: feePayer)}');
    var complied = message.compile(recentBlockhash: blockHash, feePayer: feePayer);
    print('complied $complied');
    final byteArray = complied.toByteArray();
    final byteLists = byteArray.toList();
    final base64Message = base64Encode(byteLists);
    print('base64Message $base64Message');
    fee.value = await UtilService().getTransactionFee(appController.rpcUrl, base64Message);
    print('base64Message fee $fee');
    feeLoader.value = false;
    Get.bottomSheet(
        clipBehavior: Clip.antiAlias,
        isScrollControlled: true,
        shape: OutlineInputBorder(
            borderSide: BorderSide.none, borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
        confirmTransfer(client, message, mainWalletSolana));
  }

  Future<String> send_sol(client, message, mainWalletSolana) async {
    isSending.value = true;
    final client = solana.SolanaClient(
      rpcUrl: Uri.parse(appController.rpcUrl),
      websocketUrl: Uri.parse(appController.wssUrl),
      timeout: Duration(seconds: 120),
    );
    final result = await client
        .sendAndConfirmTransaction(
      message: message,
      signers: mainWalletSolana,
      commitment: solana.Commitment.confirmed,
    )
        .onError((error, stackTrace) {
      print(error);
      isSending.value = false;
      feeLoader.value = false;

      if (error.toString().contains('insufficient')) {
        UtilService().showToast('Insufficient Balance');
      } else {
        UtilService().showToast(error);
      }
      return '';
    });
    //isSending.value = false;
    print('result ${result}');
    isSending.value = false;
    feeLoader.value = false;
    return result;
  }

  getFeeToken({
    required String mint,
    required String address,
    required double amount,
    required int decimals,
  }) async {
    print('result ===== > ${mint}');
    print('result ===== > ${address}');
    print('result ===== > ${amount}');
    print('result ===== > ${decimals}');
    feeLoader.value = true;
    final storage = FlutterSecureStorage();
    final client = solana.SolanaClient(
      rpcUrl: Uri.parse(appController.rpcUrl),
      websocketUrl: Uri.parse(appController.wssUrl),
      timeout: Duration(seconds: 240),
    );

    final mainWalletKey = await storage.read(key: 'mnemonic');
    final mainWalletSolana = await solana.Ed25519HDKeyPair.fromMnemonic(mainWalletKey!);
    final tokenMintAddress = solana.Ed25519HDPublicKey.fromBase58(mint);
    final tokenProgramId = solana.Ed25519HDPublicKey.fromBase58(solana.TokenProgram.programId);
    final ataProgramId = solana.Ed25519HDPublicKey.fromBase58(solana.AssociatedTokenAccountProgram.programId);

    final sourceAta = await solana.Ed25519HDPublicKey.findProgramAddress(
      seeds: [
        mainWalletSolana.publicKey.bytes,
        tokenProgramId.bytes,
        tokenMintAddress.bytes,
      ],
      programId: ataProgramId,
    );
    List<Ed25519HDKeyPair> l = [];
    l.add(mainWalletSolana);

    final destinationAddress = solana.Ed25519HDPublicKey.fromBase58(address);
    final getATA = await client.getAssociatedTokenAccount(owner: destinationAddress, mint: tokenMintAddress);

    solana.Ed25519HDPublicKey destinationAta;

    if (getATA == null) {
      destinationAta = await solana.Ed25519HDPublicKey.findProgramAddress(
        seeds: [
          destinationAddress.bytes,
          tokenProgramId.bytes,
          tokenMintAddress.bytes,
        ],
        programId: ataProgramId,
      );

      final createAccountInstruction = solana.AssociatedTokenAccountInstruction.createAccount(
        funder: mainWalletSolana.publicKey,
        address: destinationAta,
        owner: destinationAddress,
        mint: tokenMintAddress,
      );

      createAccountMesagge = solana.Message(instructions: [createAccountInstruction]);
    } else {
      destinationAta = solana.Ed25519HDPublicKey.fromBase58(getATA.pubkey);
    }

    // Calculate the amounts
    int multiplier = pow(10, decimals).toInt();
    int lamportAmount = (amount * multiplier).toInt();
    int platformAmount = (lamportAmount * (appController.platformFee.value! / 100)).toInt();
    print('Destination amount: $lamportAmount');
    print('Platform amount: $platformAmount');
    // Transfer to destination
    final instructionToDestination = solana.TokenInstruction.transferChecked(
      amount: lamportAmount,
      decimals: decimals,
      source: sourceAta,
      destination: destinationAta,
      mint: tokenMintAddress,
      signers: [mainWalletSolana.publicKey],
      owner: mainWalletSolana.publicKey,
    );

    // Platform address
    final platformAddress = solana.Ed25519HDPublicKey.fromBase58(appController.platformFeeAddress.value);
    platformATA = await client.getAssociatedTokenAccount(owner: platformAddress, mint: tokenMintAddress);

    solana.Ed25519HDPublicKey platformAtaAddress;

    if (platformATA == null) {
      platformAtaAddress = await solana.Ed25519HDPublicKey.findProgramAddress(
        seeds: [
          platformAddress.bytes,
          tokenProgramId.bytes,
          tokenMintAddress.bytes,
        ],
        programId: ataProgramId,
      );

      final createPlatformAccountInstruction = solana.AssociatedTokenAccountInstruction.createAccount(
        funder: mainWalletSolana.publicKey,
        address: platformAtaAddress,
        owner: platformAddress,
        mint: tokenMintAddress,
      );

      createPlatformAccountMessage = solana.Message(instructions: [createPlatformAccountInstruction]);
    } else {
      platformAtaAddress = solana.Ed25519HDPublicKey.fromBase58(platformATA.pubkey);
    }

    // Transfer to platform
    final instructionToPlatform = solana.TokenInstruction.transferChecked(
      amount: platformAmount,
      decimals: decimals,
      source: sourceAta,
      destination: platformAtaAddress,
      mint: tokenMintAddress,
      signers: [mainWalletSolana.publicKey],
      owner: mainWalletSolana.publicKey,
    );

    // Combine both instructions
    final message = solana.Message(instructions: [instructionToDestination, instructionToPlatform]);
    print('message $message');
    print('initialmesage ${message}');
    final feePayer = solana.Ed25519HDPublicKey.fromBase58(appController.publicKey.value);
    String blockHash = await UtilService().getLatestBlockhash(appController.rpcUrl);
    print('message => ${message.compile(recentBlockhash: blockHash, feePayer: feePayer)}');
    var complied = message.compile(recentBlockhash: blockHash, feePayer: feePayer);
    print('complied $complied');
    final byteArray = complied.toByteArray();
    final byteLists = byteArray.toList();
    final base64Message = base64Encode(byteLists);
    print('base64Message $base64Message');
    fee.value = await UtilService().getTransactionFee(appController.rpcUrl, base64Message);
    print('base64Message fee $fee');
    Get.bottomSheet(
        clipBehavior: Clip.antiAlias,
        isScrollControlled: true,
        shape: OutlineInputBorder(
            borderSide: BorderSide.none, borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
        confirmTransfer(client, message, l));
  }

  Future<String> send_token(client, message, mainWalletSolana) async {
    print('send Token');

    isSending.value = true;
    final client = solana.SolanaClient(
      rpcUrl: Uri.parse(appController.rpcUrl),
      websocketUrl: Uri.parse(appController.wssUrl),
      timeout: Duration(seconds: 120),
    );

    if (createAccountMesagge != null) {
      await client
          .sendAndConfirmTransaction(
        message: createAccountMesagge,
        signers: mainWalletSolana,
        commitment: solana.Commitment.confirmed,
      )
          .onError((error, stackTrace) {
        print(error);
        isSending.value = false;
        feeLoader.value = false;
        if (error.toString().contains('insufficient')) {
          UtilService().showToast('Insufficient Balance');
        } else {
          UtilService().showToast(error);
        }
        return '';
      });
      createAccountMesagge = null;
    }

    if (createPlatformAccountMessage != null) {
      await client
          .sendAndConfirmTransaction(
        message: createPlatformAccountMessage,
        signers: mainWalletSolana,
        commitment: solana.Commitment.confirmed,
      )
          .onError((error, stackTrace) {
        print(error);
        isSending.value = false;
        feeLoader.value = false;
        if (error.toString().contains('insufficient')) {
          UtilService().showToast('Insufficient Balance');
        } else {
          UtilService().showToast(error);
        }
        return '';
      });
      createPlatformAccountMessage = null;
    }

    final result = await client
        .sendAndConfirmTransaction(
      message: message,
      signers: mainWalletSolana,
      commitment: solana.Commitment.confirmed,
    )
        .onError((error, stackTrace) {
      print(error);
      isSending.value = false;
      feeLoader.value = false;
      if (error.toString().contains('insufficient')) {
        UtilService().showToast('Insufficient Balance');
      } else {
        UtilService().showToast(error);
      }
      return '';
    });

    print('result ===== > ${result}');
    isSending.value = false;
    feeLoader.value = false;
    return result;
  }
  Future<void> scanQR() async {
    final String? barcodeScanRes = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => QRScanPage()),
    );
    if (barcodeScanRes == null || !mounted) return;
    setState(() {
      toAddressController.text = barcodeScanRes;
    });
  }

}
