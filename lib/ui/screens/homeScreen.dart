import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:solana/base58.dart';
import 'package:solana/dto.dart';
import 'package:solana/solana.dart';
import 'package:solana_flutter/controllers/appController.dart';
import 'package:solana_flutter/ui/screens/buy.dart';
import 'package:solana_flutter/ui/screens/sendScreen.dart';
import 'package:solana_flutter/ui/screens/tokenDetail.dart';
import 'package:solana_flutter/ui/screens/transactions.dart';
import 'package:solana_flutter/utilService/UtilService.dart';
import 'package:solana_flutter/utilService/dataService.dart';

import '../../constants/colors.dart';
import '../../models/tokenModel.dart';
import '../commonWidgets/backupWidget.dart';
import '../commonWidgets/commonWidgets.dart';
import '../commonWidgets/navCustom.dart';
import 'importToken.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final appController = Get.find<AppController>();
  SolanaClient? client;
  RefreshController _refreshController = new RefreshController(initialRefresh: false);
  //var balance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (appController.tokenList.length == 0) {
      getBalance();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: primaryBackgroundColor.value,
        body: SafeArea(
          child: Container(
            width: Get.width,
            height: Get.height,
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: false,
              header: WaterDropMaterialHeader(
                backgroundColor: primaryBackgroundColor.value,
                color: primaryColor.value,
              ),
              controller: _refreshController,
              onRefresh: () {
                getBalance();
              },
              onLoading: () {
                // onLoading();
              },
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          appController.showBalance.value = !appController.showBalance.value;
                        },
                        child: Container(
                          width: 18,
                          height: 18,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Icon(
                            appController.showBalance.value == true ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            size: 18,
                            color: Color(0xffA6A0BB),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "My Wallet",
                        style: TextStyle(
                          color: Color(0xffA6A0BB),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 11,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          appController.showBalance.value == true
                              ? 'SOL ${UtilService().toFixed2DecimalPlaces((appController.accountSolBalance.value).toString(), decimalPlaces: 4)}'
                              : "* * * *",
                          style: TextStyle(
                            color: lightTextColor.value,
                            fontSize: 34,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 11,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          UtilService().copyToClipboard(appController.publicKey.value);
                        },
                        child: Container(
                          width: 190,
                          height: 33,
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: ShapeDecoration(
                            color: Color(0x191C1924),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 0.50, color: cardcolor.value),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (appController.publicKey.value != '')
                                Text(
                                  '${appController.publicKey.value.substring(0, 5) + '...' + appController.publicKey.value.substring(appController.publicKey.value.length - 4)}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              SizedBox(width: 4),
                              Container(
                                width: 20,
                                height: 20,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(),
                                child: SvgPicture.asset("assets/svg/Icons.svg"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Container(
                    width: 343,
                    height: 59.67,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (appController.getTokensLoader.value == false) {
                                Get.to(SendScreen(
                                  onSend: () {
                                    getBalance();
                                  },
                                ));
                              }
                            },
                            child: Container(
                              height: 59.67,
                              padding: EdgeInsets.symmetric(horizontal: 27, vertical: 9),
                              clipBehavior: Clip.antiAlias,
                              decoration: ShapeDecoration(
                                color: cardcolor.value,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 16.67,
                                          height: 16.67,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(),
                                          child: SvgPicture.asset("assets/svg/Out.svg"),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Send',
                                          style: TextStyle(
                                            color: primaryColor.value,
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.bottomSheet(
                                  clipBehavior: Clip.antiAlias,
                                  isScrollControlled: true,
                                  backgroundColor: primaryBackgroundColor.value,
                                  shape: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                                  receive());
                            },
                            child: Container(
                              height: 59.67,
                              padding: EdgeInsets.symmetric(horizontal: 27, vertical: 9),
                              clipBehavior: Clip.antiAlias,
                              decoration: ShapeDecoration(
                                color: cardcolor.value,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 16.67,
                                          height: 16.67,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(),
                                          child: SvgPicture.asset("assets/svg/Icon Frame.svg"),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Receive',
                                          style: TextStyle(
                                            color: primaryColor.value,
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            height: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 59.67,
                            padding: EdgeInsets.symmetric(horizontal: 26, vertical: 9),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: cardcolor.value,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      Buy(),
                                    );
                                  },
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 16.67,
                                          height: 16.67,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(),
                                          child: SvgPicture.asset("assets/svg/walletSol.svg"),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Buy',
                                          style: TextStyle(
                                            color: primaryColor.value,
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            height: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  BackupReminderWidget(),
                  Container(
                    width: Get.width,
                    // height: 366,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: Get.width,
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: Color(0xFF16141C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Coins',
                                style: TextStyle(
                                  color: primaryColor.value,
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  height: 0.08,
                                ),
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  Get.to(ImportToken())!.then((value) {
                                    if (value == 'added') {
                                      getBalance();
                                    }
                                  });
                                },
                                child: Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '+ Import token',
                                        style: TextStyle(
                                          color: primaryColor.value,
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.all(12),
                            decoration: ShapeDecoration(
                              color: cardcolor.value,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                            ),
                            child: ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                ///SPL Tokens
                                appController.getTokensLoader.value == true
                                    ? ListView.separated(
                                        itemCount: 6,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        separatorBuilder: (BuildContext context, int index) {
                                          return SizedBox(
                                            height: 12,
                                          );
                                        },
                                        itemBuilder: (BuildContext context, int index) {
                                          return CommonWidgets.tokensHomeSkeletonWidget();
                                        },
                                      )
                                    : ListView.separated(
                                        itemCount: appController.tokenList.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        separatorBuilder: (BuildContext context, int index) {
                                          return SizedBox(
                                            height: 12,
                                          );
                                        },
                                        itemBuilder: (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: (){
                                              Get.to(TokenDetail(
                                                token: appController.tokenList[index],
                                                index: index,
                                              ));
                                            },
                                            child: Container(
                                              width: Get.width,
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: Color(0xff272332)
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                              width: 40,
                                                              height: 40,
                                                              clipBehavior: Clip.antiAlias,
                                                              decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: Colors.white,
                                                              ),
                                                              child: CachedNetworkImage(
                                                                imageUrl: appController.tokenList[index].uri ?? '',
                                                                fit: BoxFit.cover,
                                                                errorWidget: (context, url, error) => Icon(Icons.error),
                                                              )),
                                                        ],
                                                      ),
                                                      SizedBox(width: 12),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            '${appController.tokenList[index].symbol}',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 16,
                                                              fontFamily: 'Poppins',
                                                              fontWeight: FontWeight.w600,
                                                              letterSpacing: -0.41,
                                                            ),
                                                          ),
                                                          // SizedBox(height: 4),
                                                          // Text(
                                                          //   '${appController.tokenList[index].balance} ${appController.tokenList[index].symbol}',
                                                          //   textAlign: TextAlign.center,
                                                          //   style: TextStyle(
                                                          //     color: labelColorPrimaryShade.value,
                                                          //     fontSize: 12,
                                                          //     fontFamily: 'Poppins',
                                                          //     fontWeight: FontWeight.w400,
                                                          //     letterSpacing: 0.07,
                                                          //   ),
                                                          // ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        appController.showBalance.value != true ? " * * * * ${appController.tokenList[index].symbol}" :
                                                        "${appController.tokenList[index].balance} ${appController.tokenList[index].symbol}",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          color: labelColorPrimaryShade.value,
                                                          fontSize: 12,
                                                          fontFamily: 'Poppins',
                                                          fontWeight: FontWeight.w400,
                                                          letterSpacing: 0.07,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ],
                            )),
                        SizedBox(height: 100),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget receive() {
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
                SizedBox(),
                Text(
                  'Receive',
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
          SizedBox(height: 64),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: 40,
                  height: 40,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    "assets/images/sol.png",
                    fit: BoxFit.cover,
                  )),
              SizedBox(width: 8),
              SizedBox(
                width: 66,
                child: Text(
                  'SOL',
                  style: TextStyle(
                    color: lightTextColor.value,
                    fontSize: 24,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: ShapeDecoration(
                  color: cardcolor.value,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Color(0xFF242438)),
                    borderRadius: BorderRadius.circular(18.63),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 190,
                      height: 190,
                      child: Container(
                        width: 197.92,
                        height: 197.92,
                        decoration: BoxDecoration(),
                        child: QrImageView(
                          backgroundColor: Colors.transparent,
                          data: appController.publicKey.value,
                          version: QrVersions.auto,
                          foregroundColor: primaryColor.value,
                          // size: 200.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'Send only the specified coins to this deposit address. This address does support deposit of non-fungible token.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: subtextColor.value,
              fontSize: 14,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Deposit Address',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: subtextColor.value,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${appController.publicKey.value.substring(0, 5) + '...' + appController.publicKey.value.substring(appController.publicKey.value.length - 4)}',
                style: TextStyle(
                  color: lightTextColor.value,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 76),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Share.share(appController.publicKey.value);
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
                        Image.asset(
                          "assets/images/share.png",
                          height: 20,
                          width: 20,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Share',
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
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    UtilService().copyToClipboard(appController.publicKey.value);
                  },
                  child: Container(
                    height: 50,
                    width: Get.width,
                    decoration: BoxDecoration(color: primaryColor.value, borderRadius: BorderRadius.circular(100)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/copy.png",
                          height: 20,
                          width: 20,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Copy',
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  void getBalance() async {
    appController.loadingPrice.value = true;
    final storage = FlutterSecureStorage();
    if (await storage.containsKey(key: 'privKey')) {
      String privKey = (await storage.read(key: 'privKey'))!;
      List<int> bytes = base58decode(privKey);
      appController.publicKey.value = await Ed25519HDPublicKey(bytes).toString();
      final getBalance = await SolanaClient(
        rpcUrl: Uri.parse(appController.rpcUrl),
        websocketUrl: Uri.parse(appController.wssUrl),
      ).rpcClient.getBalance(appController.publicKey.value, commitment: Commitment.confirmed);
      var balanceSol = (getBalance!.value) / lamportsPerSol;
      appController.accountSolBalance.value = balanceSol;
      _refreshController.refreshCompleted();
    }
    getTokensList();
  }

  getTokensList() async {
    if (appController.tokenList.isEmpty) {
      appController.getTokensLoader.value = true;
    }
    appController.tokenList.clear();
    Token sol = Token(
        name: 'Solana',
        symbol: 'SOL',
        balance: appController.accountSolBalance.value,
        uri: 'https://logos-world.net/wp-content/uploads/2024/01/Solana-Logo.png',
        tokenAddress: '',
        coinGeckoID: 'solana');
    if (appController.tokenList.map((item) => item.tokenAddress).contains(sol.tokenAddress)) {
      print('EXISTTTTSSSSS');
    } else {
      appController.tokenList.add(sol);
    }


    final userEncode = jsonEncode(appController.savedTokens);


    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (await prefs.containsKey('savedSplTokens') && appController.tokenList.length <= 1) {
      var splList = jsonDecode(prefs.getString('savedSplTokens')!);
      appController.tokenList.addAll((splList as List).map((x) => Token.fromJson(x)).toList());
    } else {
      prefs.setString('savedSplTokens', userEncode);
      var splList = jsonDecode(userEncode);
      appController.tokenList.addAll((splList as List).map((x) => Token.fromJson(x)).toList());
    }
    Future.delayed(Duration(milliseconds: 600), () async {
      appController.tokenList.addAll(await DataService()
          .fetch_tokens(
          SolanaClient(
            rpcUrl: Uri.parse(appController.rpcUrl),
            websocketUrl: Uri.parse(appController.wssUrl),
          ),
          appController.publicKey.value)
          .whenComplete(() {
        appController.getTokensLoader.value = false;
      }));
      appController.tokenList.refresh();
    });
  }
}
