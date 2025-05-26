import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:dot_curved_bottom_nav/dot_curved_bottom_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:solana/base58.dart';
import 'package:solana/solana.dart';
import 'package:solana_flutter/ui/screens/homeScreen.dart';
import 'package:solana_flutter/ui/screens/nftsScreen.dart';
import 'package:solana_flutter/ui/screens/transactions.dart';

import '../../../constants/colors.dart';
import '../../../controllers/appController.dart';
import '../../screens/profile.dart';
import '../../screens/solTransactions.dart';
import '../../screens/swap.dart';

final GlobalKey four = GlobalKey();
final GlobalKey five = GlobalKey();
final GlobalKey six = GlobalKey();
final GlobalKey seven = GlobalKey();
final GlobalKey eight = GlobalKey();

class BottomNavigationBar1 extends StatefulWidget {
  const BottomNavigationBar1({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBar1> createState() => _BottomNavigationBar1State();
}

class _BottomNavigationBar1State extends State<BottomNavigationBar1> {
  @override
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

  final appController = Get.find<AppController>();
  List<TabItem> items = [
    TabItem(
      icon: Icons.home,
      title: 'Home',
    ),
    TabItem(
      icon: Icons.nfc,
      title: 'Nfts',
    ),
    /*TabItem(
      icon: Icons.swap_horiz,
      title: 'Swap',
    ),*/
    TabItem(
      icon: Icons.history,
      title: 'History',
    ),
    TabItem(
      icon: Icons.supervised_user_circle,
      title: 'Profile',
    ),
  ];
  var _currentPage = 0.obs;
  int previousIndex = 0;
  double height = 30;
  Color colorSelect = const Color(0XFF462D81);
  Color color = const Color(0XFF462D81);
  Color color2 = const Color(0XFF462D81);
  List pages = [HomeScreen(), NftsScreen(), /*Swap(),*/ SolTrnasactions(), ProfileScreen()];
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Scaffold(
          body: Container(
            width: Get.width,
            height: Get.height,
            child: Stack(
              children: [
                Container(
                  width: Get.width,
                  height: Get.height,
                  child: pages.elementAt(_currentPage.value),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: DotCurvedBottomNav(
                      scrollController: _scrollController,
                      hideOnScroll: true,
                      indicatorColor: primaryColor.value,
                      backgroundColor: Color(0xff272332),
                      animationDuration: const Duration(milliseconds: 300),
                      animationCurve: Curves.ease,
                      selectedIndex: _currentPage.value,
                      indicatorSize: 6,
                      borderRadius: 0,
                      margin: EdgeInsets.only(
                        top: 20,
                      ),
                      height: 70,
                      onTap: (index) {
                        setState(() => _currentPage.value = index);
                      },
                      items: [
                        GestureDetector(
                          onTap: () {
                            _currentPage.value = 0;
                          },
                          child: Column(
                            children: [
                              Container(
                                color: Colors.transparent,
                                child: SvgPicture.asset(
                                  'assets/svg/home.svg',
                                  color: _currentPage == 0 ? primaryColor.value : labelColorPrimaryShade.value,
                                  height: 22,
                                ),
                              ),
                              Column(
                                children: [
                                  SizedBox(height: 2,),
                                  Text(
                                    'HOME',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _currentPage == 0 ? primaryColor.value :Colors.transparent,
                                      fontSize: 10,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                ],
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _currentPage.value = 1;
                          },
                          child: Column(
                            children: [
                              Container(
                                color: Colors.transparent,
                                child: SvgPicture.asset(
                                  'assets/svg/3d-cube-scan.svg',
                                  color: _currentPage == 1 ? primaryColor.value : labelColorPrimaryShade.value,height: 22,
                                ),
                              ),
                              Column(
                                children: [
                                  SizedBox(height: 2,),
                                  Text(
                                    'NFTs',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _currentPage == 1 ? primaryColor.value :Colors.transparent,
                                      fontSize: 10,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _currentPage.value = 2;
                          },
                          child: Column(
                            children: [
                              Container(
                                color: Colors.transparent,
                                child: SvgPicture.asset(
                                  'assets/svg/clipboard-text.svg',
                                  color: _currentPage == 2 ? primaryColor.value : labelColorPrimaryShade.value,height: 22,
                                ),
                              ),
                              Column(
                                children: [
                                  SizedBox(height: 2,),
                                  Text(
                                    'History',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _currentPage == 2 ? primaryColor.value :Colors.transparent,
                                      fontSize: 10,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                ],
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _currentPage.value = 3;
                          },
                          child: Column(
                            children: [
                              Container(
                                color: Colors.transparent,
                                child: SvgPicture.asset(
                                  'assets/svg/profile-circle.svg',
                                  color: _currentPage == 3 ? primaryColor.value : labelColorPrimaryShade.value,height: 22,
                                ),
                              ),
                              Column(
                                children: [
                                  SizedBox(height: 2,),
                                  Text(
                                    'Profile',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _currentPage == 3 ? primaryColor.value :Colors.transparent,
                                      fontSize: 10,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                ],
                              ),
                            ],
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
      ),
    );
  }
}
