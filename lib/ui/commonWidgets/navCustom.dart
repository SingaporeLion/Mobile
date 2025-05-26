import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:solana/base58.dart';
import 'package:solana/solana.dart';
import 'package:solana_flutter/constants/colors.dart';

import '../../controllers/appController.dart';
import '../screens/homeScreen.dart';
import '../screens/nftsScreen.dart';
import '../screens/profile.dart';
import '../screens/solTransactions.dart';
import '../screens/swap.dart';
import '../screens/transactions.dart';

class BottomNavBarV2 extends StatefulWidget {
  @override
  _BottomNavBarV2State createState() => _BottomNavBarV2State();
}

class _BottomNavBarV2State extends State<BottomNavBarV2> {
  var currentIndex = 0.obs;
  List pages = [HomeScreen(), NftsScreen(), /*Swap(),*/ SolTrnasactions(), ProfileScreen()];
  final appController = Get.find<AppController>();
  void initState() {
    // TODO: implement initState
    getKey();
    super.initState();
  }

  getKey() async {
    final storage = FlutterSecureStorage();
    if (await storage.containsKey(key: 'privKey')) {
      String privKey = (await storage.read(key: 'privKey'))!;
      print('appController.privKey.value ${privKey}');
      List<int> bytes = base58decode(privKey);
      print("bytes===> ${bytes}");
      appController.publicKey.value = await Ed25519HDPublicKey(bytes).toString();
      print("appController.publicKey.value ${appController.publicKey.value}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white.withAlpha(55),
        body: Stack(
          children: [
            pages[currentIndex.value],
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: size.width,
                height: 80,
                child: Stack(
                  //overflow: Overflow.visible,
                  children: [
                    // CustomPaint(
                    //   size: Size(size.width, 80),
                    //   painter: BNBCustomPainter(),
                    // ),
                    // Center(
                    //   heightFactor: 0.6,
                    //   child: Container(
                    //       decoration: BoxDecoration(color: primaryColor.value, borderRadius: BorderRadius.circular(100), boxShadow: [
                    //         BoxShadow(
                    //           color: Color.fromRGBO(112, 237, 239, 15).withOpacity(0.95),
                    //           spreadRadius: 5,
                    //           blurRadius: 25,
                    //           offset: Offset(0, 2), // changes position of shadow
                    //         ),
                    //       ]),
                    //       clipBehavior: Clip.antiAlias,
                    //       child: FloatingActionButton(backgroundColor: primaryColor.value, child: SvgPicture.asset("assets/svg/iconoir_coins-swap.svg"), onPressed: () {
                    //
                    //       })),
                    // ),
                    Container(
                      width: size.width,
                      height: 80,
                      color: cardcolor.value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                currentIndex.value = 0;
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: SvgPicture.asset(
                                  'assets/svg/home.svg',
                                  color: currentIndex == 0 ? primaryColor.value : labelColorPrimaryShade.value,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                currentIndex.value = 1;
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: SvgPicture.asset(
                                  'assets/svg/3d-cube-scan.svg',
                                  color: currentIndex == 1 ? primaryColor.value : labelColorPrimaryShade.value,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                currentIndex.value = 2;
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: SvgPicture.asset(
                                  'assets/svg/clipboard-text.svg',
                                  color: currentIndex == 2 ? primaryColor.value : labelColorPrimaryShade.value,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                currentIndex.value = 3;
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: SvgPicture.asset(
                                  'assets/svg/profile-circle.svg',
                                  color: currentIndex == 3 ? primaryColor.value : labelColorPrimaryShade.value,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = cardcolor.value
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20), radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
