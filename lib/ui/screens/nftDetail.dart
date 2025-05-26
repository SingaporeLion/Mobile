import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:solana_flutter/ui/screens/snedNft.dart';

import '../../constants/colors.dart';
import '../../controllers/appController.dart';
import '../../models/newNftModel.dart';
import '../../models/nftModel.dart';
import '../../utilService/UtilService.dart';
import '../commonWidgets/bottomRectangularbtn.dart';

class NftDetails extends StatefulWidget {
  NftDetails({super.key, required this.nft, required this.onSent});
  final NewNftModel nft;
  final Function onSent;

  @override
  State<NftDetails> createState() => _NftDetailsState();
}

class _NftDetailsState extends State<NftDetails> {
  final appController = Get.find<AppController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor.value,
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Container(
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
                    Obx(
                      () => GestureDetector(
                        onTap: () {
                          UtilService().saveImageToGallery(imageUrl: (widget.nft.name?.contains('Raydium')??false)
                              ? 'https://assets.coingecko.com/coins/images/13928/large/PSigc4ie_400x400.jpg?1696513668':
                          widget.nft.imageUri!, context: context);
                        },
                        child: Container(
                          height: 32,
                          width: 32,
                          padding: EdgeInsets.all(6),
                          decoration: ShapeDecoration(
                            color: cardcolor.value,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: appController.saveImageToGalleryLoader.value == true
                              ? CircularProgressIndicator(
                                  strokeWidth: 3.0,
                                  color: primaryColor.value,
                                  backgroundColor: Colors.transparent,
                                )
                              : Icon(
                                  Icons.save_alt,
                                  color: primaryColor.value,
                                  size: 16,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: Get.width,
                height: 311,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: CachedNetworkImage(
                  imageUrl: (widget.nft.name?.contains('Raydium')??false)
                      ? 'https://assets.coingecko.com/coins/images/13928/large/PSigc4ie_400x400.jpg?1696513668':
                  widget.nft.imageUri ?? '',
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Icon(Icons.broken_image),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              width: Get.width,
              padding: EdgeInsets.only(top: 8, bottom: 23, right: 12, left: 12),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: cardcolor.value,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 44,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.nft.name}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ).extractHash("#", widget.nft.name, true),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
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
                                      '${widget.nft.description}',
                                      style: TextStyle(
                                        color: subtextColor.value,
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                        Container(
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
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              child: Text(
                                                'Properties',
                                                style: TextStyle(
                                                  color: lightTextColor.value,
                                                  fontSize: 18,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    /*  SizedBox(height: 12),
                                    Container(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 80,
                                            child: Text(
                                              'Price',
                                              style: TextStyle(
                                                color: subtextColor.value,
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                            SizedBox(width: 4),
                                          Text(
                                            '6.64 SOL',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: lightTextColor.value,
                                              fontSize: 14,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),*/
                                    SizedBox(height: 12),
                                    Container(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 80,
                                            child: Text(
                                              'Network',
                                              style: TextStyle(
                                                color: subtextColor.value,
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'Solana',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: lightTextColor.value,
                                              fontSize: 14,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Container(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Contract Address',
                                            style: TextStyle(
                                              color: subtextColor.value,
                                              fontSize: 14,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            '${widget.nft.mint!.substring(0, 5) + '...' + widget.nft.mint!.substring(widget.nft.mint!.length - 4)}',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: lightTextColor.value,
                                              fontSize: 14,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Container(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'View on SolScan',
                                            style: TextStyle(
                                              color: subtextColor.value,
                                              fontSize: 14,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              UtilService().launchURL(context, 'https://solscan.io/token/${widget.nft.mint}');
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  "assets/images/hyperlink.png",
                                                  height: 16,
                                                  width: 16,
                                                  color: labelColorPrimaryShade.value,
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  '${Uri.tryParse('https://solscan.io/token/${widget.nft.mint}')?.host ?? 'solscan.io'}',
                                                  style: TextStyle(
                                                    color: subtextColor.value,
                                                    fontSize: 14,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),


                                    SizedBox(height: 12),
                                    Container(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'NFT Image Url',
                                            style: TextStyle(
                                              color: subtextColor.value,
                                              fontSize: 14,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              UtilService().copyToClipboard('${widget.nft.imageUri}');
                                            },
                                            child: Container(
                                              color: Colors.transparent,
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/images/copy.png",
                                                    height: 18,
                                                    width: 18,
                                                    color: labelColorPrimaryShade.value,
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    '${Uri.tryParse('${widget.nft.imageUri}')?.host ?? ''}',
                                                    style: TextStyle(
                                                      color: subtextColor.value,
                                                      fontSize: 14,
                                                      fontFamily: 'Poppins',
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                        SizedBox(height: 24),
                        BottomRectangularBtn(
                            onTapFunc: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      duration: Duration(milliseconds: 100),
                                      type: PageTransitionType.topToBottom,
                                      child: SendNftScreen(
                                        nft: widget.nft,
                                        onSent: () {
                                          widget.onSent.call();
                                          Get.back();
                                        },
                                      )));
                            },
                            btnTitle: "Transfer")
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
