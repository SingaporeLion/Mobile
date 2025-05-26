import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:get/get.dart';
import 'package:solana/dto.dart';
import 'package:solana/solana.dart';
import 'package:solana_flutter/ui/commonWidgets/bottomRectangularbtn.dart';
import 'package:solana_flutter/ui/commonWidgets/commonWidgets.dart';
import 'package:solana_flutter/ui/screens/transactions.dart';
import 'package:solana_flutter/ui/screens/verifyPassword.dart';
import 'package:solana_flutter/utilService/UtilService.dart';
import 'package:solana_flutter/utilService/dataService.dart';

import '../../constants/colors.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:solana/solana.dart' as solana;

import '../../controllers/appController.dart';
import '../../models/newNftModel.dart';
import '../../models/nftModel.dart';

class SendNftScreen extends StatefulWidget {
  SendNftScreen({super.key, required this.nft, required this.onSent});
  final NewNftModel nft;
  final Function onSent;

  @override
  State<SendNftScreen> createState() => _SendNftScreenState();
}

class _SendNftScreenState extends State<SendNftScreen> {
  final appController = Get.find<AppController>();
  TextEditingController toAddressController = TextEditingController();
  var addressErr = ''.obs;
  var fee = 0.0.obs;
  var isSending = false.obs;
  var createAccountMesagge;

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Scaffold(
        backgroundColor: primaryBackgroundColor.value,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                                  color: primaryColor.value,
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
                  height: Get.height * 0.15,
                ),
                Container(
                    width: Get.width,
                    child: Column(
                      children: [
                        Container(
                          width: 164,
                          height: 164,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: (widget.nft.name?.contains('Raydium') ?? false)
                                ? 'https://assets.coingecko.com/coins/images/13928/large/PSigc4ie_400x400.jpg?1696513668'
                                : widget.nft.imageUri ?? '',
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Icon(Icons.person),
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          '${widget.nft.name}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: Get.height * 0.15,
                ),
                BottomRectangularBtn(
                    onTapFunc: () async {
                      if (toAddressController.text.trim() == '') {
                        addressErr.value = 'Please enter the address';
                      } else {
                        // await UtilService().getTransactionFee().then((value) {
                        //   if (value != null) {
                        //     print('fee: $value');
                        //     fee.value = value;
                        //     Get.bottomSheet(
                        //         clipBehavior: Clip.antiAlias,
                        //         isScrollControlled: true,
                        //         shape:
                        //         OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                        //         confirmTransfer());
                        //   }
                        // });
                        getFeeToken(widget.nft, toAddressController.text);
                      }
                    },
                    btnTitle: "Continue")
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget confirmTransfer(client, message, mainWalletSolana) {
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
      child: ListView(
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
                      Container(
                        width: Get.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              clipBehavior: Clip.antiAlias,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: (widget.nft.name?.contains('Raydium') ?? false)
                                    ? 'https://assets.coingecko.com/coins/images/13928/large/PSigc4ie_400x400.jpg?1696513668'
                                    : widget.nft.imageUri ?? '',
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Icon(Icons.person),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                '${widget.nft.name}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
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
          SizedBox(height: 76),
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
                    if (appController.enabledBiometric.value == true) {
                      Get.to(VerifyPassword(fromPage: 'send'))!.then((value) {
                        if (value == 'verified') {
                          //getFeeToken(widget.nft, toAddressController.text);
                          send_nft(widget.nft, toAddressController.text).then((value) async {
                            if (value != null && value != '') {
                              Get.back();
                              widget.onSent.call();
                              Get.bottomSheet(
                                  clipBehavior: Clip.antiAlias,
                                  isScrollControlled: true,
                                  shape: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                                  transationSuccessful());
                            }
                          });
                        }
                      });
                    } else {
                      //getFeeToken(widget.nft, toAddressController.text);
                      send_nft(widget.nft, toAddressController.text).then((value) async {
                        if (value != null && value != '') {
                          Get.back();
                          widget.onSent.call();
                          Get.bottomSheet(
                              clipBehavior: Clip.antiAlias,
                              isScrollControlled: true,
                              shape: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                              transationSuccessful());
                        }
                      });
                    }
                  },
                  onSwipe: () {},
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget transationSuccessful() {
    return Obx(
          () => Container(
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
                        child: Center(child: Icon(Icons.close, color: Colors.white))),
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
                          child: SvgPicture.asset("assets/svg/transactionSuccess.svg"),
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
                    decoration: BoxDecoration(color: primaryColor.value, borderRadius: BorderRadius.circular(100)),
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
      ),
    );
  }

  Future<String> send_nft(NewNftModel nft, String address) async {
    isSending.value = true;
    final storage = FlutterSecureStorage();

    final client =
    solana.SolanaClient(rpcUrl: Uri.parse(appController.rpcUrl), websocketUrl: Uri.parse(appController.wssUrl), timeout: Duration(seconds: 120));

    final mainWalletKey = await storage.read(key: 'mnemonic');

    final mainWalletSolana = await solana.Ed25519HDKeyPair.fromMnemonic(
      mainWalletKey!,
    );

    final tokenMintAddress = solana.Ed25519HDPublicKey.fromBase58(nft.mint!);

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
          funder: mainWalletSolana.publicKey, address: destinationAta, owner: destinationAddress, mint: tokenMintAddress);

      final createAccountMesagge = solana.Message(instructions: [createAccountInstruction]);

      await client
          .sendAndConfirmTransaction(
        message: createAccountMesagge,
        signers: [mainWalletSolana],
        commitment: solana.Commitment.confirmed,
      )
          .onError((error, stackTrace) {
        print(error);
        isSending.value = false;
        UtilService().showToast(error);
        return '';
      });
    } else {
      destinationAta = solana.Ed25519HDPublicKey.fromBase58(getATA.pubkey);
    }

    final instruction = solana.TokenInstruction.transferChecked(
        amount: 1,
        decimals: 0,
        source: sourceAta,
        destination: destinationAta,
        mint: tokenMintAddress,
        signers: [mainWalletSolana.publicKey],
        owner: mainWalletSolana.publicKey);

    final message = solana.Message(instructions: [instruction]);
    print('message $message');
    final result = await client
        .sendAndConfirmTransaction(
      message: message,
      signers: [mainWalletSolana],
      commitment: solana.Commitment.confirmed,
    )
        .onError((error, stackTrace) {
      print(error);
      isSending.value = false;
      UtilService().showToast(error);
      return '';
    });
    print('res $result');
    return result;
  }

  getFeeToken(NewNftModel nft, String address) async {
    final storage = FlutterSecureStorage();

    final client =
    solana.SolanaClient(rpcUrl: Uri.parse(appController.rpcUrl), websocketUrl: Uri.parse(appController.wssUrl), timeout: Duration(seconds: 120));

    final mainWalletKey = await storage.read(key: 'mnemonic');

    final mainWalletSolana = await solana.Ed25519HDKeyPair.fromMnemonic(
      mainWalletKey!,
    );

    final tokenMintAddress = solana.Ed25519HDPublicKey.fromBase58(nft.mint!);

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
          funder: mainWalletSolana.publicKey, address: destinationAta, owner: destinationAddress, mint: tokenMintAddress);

      createAccountMesagge = solana.Message(instructions: [createAccountInstruction]);

    } else {
      destinationAta = solana.Ed25519HDPublicKey.fromBase58(getATA.pubkey);
    }

    final instruction = solana.TokenInstruction.transferChecked(
        amount: 1,
        decimals: 0,
        source: sourceAta,
        destination: destinationAta,
        mint: tokenMintAddress,
        signers: [mainWalletSolana.publicKey],
        owner: mainWalletSolana.publicKey);

    final message = solana.Message(instructions: [instruction]);
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
    if(createAccountMesagge != null){
      await client
          .sendAndConfirmTransaction(
        message: createAccountMesagge,
        signers: [mainWalletSolana],
        commitment: solana.Commitment.confirmed,
      )
          .onError((error, stackTrace) {
        print(error);
        isSending.value = false;
        UtilService().showToast(error);
        return '';
      });
      createAccountMesagge = null;
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
      if (error.toString().contains('insufficient')) {
        UtilService().showToast('Insufficient Balance');
      } else {
        UtilService().showToast(error);
      }
      return '';
    });

    print('result ===== > ${result}');
    isSending.value = false;
    return result;
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#005761', ' ', false, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      //_scanBarcode = barcodeScanRes;
      toAddressController.text = barcodeScanRes;
    });
  }
}
