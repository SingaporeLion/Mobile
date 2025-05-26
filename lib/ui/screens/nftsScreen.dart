import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/colors.dart';
import '../../controllers/appController.dart';
import '../../models/nftModel.dart';
import '../../utilService/UtilService.dart';
import '../commonWidgets/commonWidgets.dart';
import 'nftDetail.dart';

class NftsScreen extends StatefulWidget {
  NftsScreen({super.key});

  @override
  State<NftsScreen> createState() => _NftsScreenState();
}

class _NftsScreenState extends State<NftsScreen> {
  final appController = Get.find<AppController>();
  RefreshController _refreshController = new RefreshController(initialRefresh: false);
  var page = 1.obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNftData();
  }

  getNftData() async {
    // await UtilService().getNFTData(page: page.value, method: '').then((value) {
    //   _refreshController.refreshCompleted();
    // });
    await UtilService().fetchNewNFTs(page: page.value, method: '', walletAddress: appController.publicKey.value).then((value) {
      _refreshController.refreshCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor.value,
      body: Obx(
        () => SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
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
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        'NFTs',
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
                      ),
                      /*GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 32,
                          width: 32,
                          padding: EdgeInsets.all(6),
                          decoration: ShapeDecoration(
                            color: cardcolor.value,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Icon(
                            Icons.add,
                            color: primaryColor.value,
                            size: 16,
                          ),
                        ),
                      ),*/
                    ],
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Expanded(
                  child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: WaterDropMaterialHeader(
                      backgroundColor: primaryBackgroundColor.value,
                      color: primaryColor.value,
                    ),
                    controller: _refreshController,
                    onRefresh: () {
                      page.value = 1;
                      getNftData();
                    },
                    onLoading: () async {
                      page.value += 1;
                      await UtilService().fetchNewNFTs(page: page.value, method: 'add', walletAddress: appController.publicKey.value).then((value) {
                        _refreshController.refreshCompleted();
                      });
                    },
                    child: appController.getNFTLoader.value == true
                        ? GridView.builder(
                            padding: EdgeInsets.only(top: 4.0, bottom: 80, left: 2.0, right: 2),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisExtent: 200, crossAxisSpacing: 12, mainAxisSpacing: 12, crossAxisCount: 2),
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return CommonWidgets.nftSkeletonWidget();
                            },
                          )
                        : appController.getNFTLoader.value == false && appController.newNftDataList.length == 0
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset('assets/svg/noNFT.svg'),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Container(
                                        width: Get.width,
                                        child: Text(
                                          'No NFTs Available',
                                          style: TextStyle(
                                            color: primaryColor.value,
                                            fontSize: 16,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            : GridView.builder(
                                padding: EdgeInsets.only(top: 4.0, bottom: 80, left: 2.0, right: 2),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisExtent: 200, crossAxisSpacing: 12, mainAxisSpacing: 12, crossAxisCount: 2),
                                itemCount: appController.newNftDataList.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          duration: Duration(milliseconds: 300),
                                          type: PageTransitionType.bottomToTop,
                                          curve: Curves.easeOut,
                                          child: NftDetails(
                                            nft: appController.newNftDataList[index],
                                            onSent: () {
                                              appController.newNftDataList.removeAt(index);
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                      decoration: ShapeDecoration(
                                        color: cardcolor.value,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 130,
                                            width: Get.width,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: ShapeDecoration(
                                              color: primaryBackgroundColor.value,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: (appController.newNftDataList[index].name?.contains('Raydium') ?? false)
                                                  ? 'https://assets.coingecko.com/coins/images/13928/large/PSigc4ie_400x400.jpg?1696513668'
                                                  : appController.newNftDataList[index].imageUri ?? '',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      '${appController.newNftDataList[index].name}',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontFamily: 'Poppins',
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ).extractHash('#', appController.newNftDataList[index].name, false),
                                                  ),
                                                  /*SizedBox(height: 2),
                                        Container(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Opacity(
                                                opacity: 0.50,
                                                child: Container(
                                                  width: 7.50,
                                                  height: 15,
                                                  child: Image.asset("assets/images/Ethereum.png"),
                                                ),
                                              ),
                                              SizedBox(width: 6),
                                              Text(
                                                '${appController.nftData.value.result?.assets?[index]}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),*/
                                                ],
                                              ),
                                              /*SizedBox(width: 8),
                                    Container(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [

                                          Text(
                                            '#1234',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: labelColorPrimaryShade.value,
                                              fontSize: 10,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            '3,99%',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF56CDAD),
                                              fontSize: 10,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),*/
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
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
