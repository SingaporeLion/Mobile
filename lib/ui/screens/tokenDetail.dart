import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:solana_flutter/ui/screens/sendScreen.dart';

import '../../constants/colors.dart';
import '../../controllers/appController.dart';
import '../../models/tokenModel.dart';
import '../../models/transactionsModel.dart';
import '../../utilService/UtilService.dart';
import '../commonWidgets/commonWidgets.dart';
import 'buy.dart';

class TokenDetail extends StatefulWidget {
  TokenDetail({super.key, required this.token, required this.index});
  final Token token;
  final int index;
  @override
  _TokenDetailState createState() => _TokenDetailState();
}

class _TokenDetailState extends State<TokenDetail> {
  var isLoading = false.obs;
  RefreshController _refreshController = new RefreshController(initialRefresh: false);
  @override
  void initState() {
    appController.tokenTransactions.clear();
    super.initState();
    getTokenTransactions();
  }

  getTokenTransactions() {
    UtilService()
        .getTokenTransactions(
            limit: 30,
            offset: 0,
            method: '',
            tokenAddress: widget.token.tokenAddress ?? '',
            address: appController.publicKey.value,
            isSol: widget.index == 0 ? true : false)
        .then((value) {
      _refreshController.refreshCompleted();
    });
  }

  loadMoreTokenTransactions() {
    UtilService()
        .getTokenTransactions(
            limit: 10,
            offset: appController.tokenTransactions.length,
            method: 'add',
            tokenAddress: widget.token.tokenAddress ?? '',
            address: appController.publicKey.value,
            isSol: widget.index == 0 ? true : false)
        .then((value) {
      _refreshController.loadComplete();
    });
  }

  final appController = Get.find<AppController>();

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
              enablePullUp: true,
              header: WaterDropMaterialHeader(
                backgroundColor: primaryBackgroundColor.value,
                color: primaryColor.value,
              ),
              controller: _refreshController,
              onRefresh: () {
                getTokenTransactions();
              },
              onLoading: () {
                loadMoreTokenTransactions();
              },
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: Get.width,
                      height: 64,
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
                            '${widget.token.name}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              height: 0.09,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 32,
                              width: 32,
                              padding: EdgeInsets.all(6),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                imageUrl: widget.token.uri ?? '',
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              '${widget.token.symbol}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w800,
                                height: 0.09,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          appController.showBalance.value != true
                              ? " * * * * ${widget.token.symbol}"
                              : '${widget.token.balance} ${widget.token.symbol}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
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
                                    index: widget.index,
                                    onSend: () {},
                                  ))!
                                      .then((value) {});
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
                                            child: SvgPicture.asset(
                                              "assets/svg/Out.svg",
                                              color: primaryColor.value,
                                            ),
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
                                            child: SvgPicture.asset(
                                              "assets/svg/Icon Frame.svg",
                                              color: primaryColor.value,
                                            ),
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
                                            child: SvgPicture.asset(
                                              "assets/svg/walletSol.svg",
                                              color: primaryColor.value,
                                            ),
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
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Transactions',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: appController.getTokenTransactionsLoader.value == true
                        ? ListView.separated(
                            padding: EdgeInsets.only(top: 4.0, bottom: 120, left: 2.0, right: 2),
                            itemCount: 12,
                            shrinkWrap: true,
                            separatorBuilder: (BuildContext context, int index) {
                              return SizedBox(
                                height: 8,
                              );
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return CommonWidgets.transactionSkeletonWidget();
                            },
                          )
                        : appController.getTokenTransactionsLoader.value == false && appController.tokenTransactions.length == 0
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 60,
                                  ),
                                  SvgPicture.asset('assets/svg/noTransactions.svg'),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Container(
                                    width: Get.width,
                                    child: Text(
                                      'No Transaction History',
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
                            : ListView.separated(
                                shrinkWrap: true,
                                itemCount: appController.tokenTransactions.length,
                                padding: EdgeInsets.only(top: 4.0, bottom: 120, left: 2.0, right: 2),
                                physics: NeverScrollableScrollPhysics(),
                                separatorBuilder: (BuildContext context, int index) {
                                  return SizedBox(
                                    height: 8,
                                  );
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    width: Get.width,
                                    padding: EdgeInsets.all(16),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: ShapeDecoration(
                                      color: cardcolor.value,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${getTransactionDetails(index)['transactionType'] == 'SPL' || getTransactionDetails(index)['transactionType'] == 'unknown' || getTransactionDetails(index)['transactionType'] == 'spl-associated-token-account' ? getTransactionDetails(index)['transactionType'] == 'spl-associated-token-account' ? 'Initialize the associated token account' : analyzeTransaction(index)['isSentFromMyAddress'] ? 'Send' : 'Receive' : isSendTransaction(index) == true ? 'Send' : 'Received'}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontFamily: 'DM Sans',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            getTransactionType(index: index) == "Swap"
                                                ? SizedBox(
                                                    height: 0,
                                                    width: 0,
                                                  )
                                                : Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        getTransactionDetails(index)['transactionType'] == 'SPL' ||
                                                                getTransactionDetails(index)['transactionType'] == 'unknown' ||
                                                                getTransactionDetails(index)['transactionType'] == 'spl-associated-token-account'
                                                            ? getTransactionDetails(index)['transactionType'] == 'spl-associated-token-account'
                                                                ? ''
                                                                : analyzeTransaction(index)['isSentFromMyAddress']
                                                                    ? 'To:'
                                                                    : 'From:'
                                                            : isSendTransaction(index) == true
                                                                ? 'To:'
                                                                : 'From:',
                                                        style: TextStyle(
                                                          color: subtextColor.value,
                                                          fontSize: 12,
                                                          fontFamily: 'DM Sans',
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                      SizedBox(width: 2),
                                                      getTransactionDetails(index)['transactionType'] == 'SPL' ||
                                                              getTransactionDetails(index)['transactionType'] == 'unknown' ||
                                                              getTransactionDetails(index)['transactionType'] == 'spl-associated-token-account'
                                                          ? getTransactionDetails(index)['transactionType'] == 'spl-associated-token-account'
                                                              ? SizedBox()
                                                              : Text(
                                                                  "${analyzeTransaction(index)['isSentFromMyAddress'] ? analyzeTransaction(index)['recipientAddress'] == null ? '' : analyzeTransaction(index)['recipientAddress'].substring(0, 5) + '...' + analyzeTransaction(index)['recipientAddress'].substring(analyzeTransaction(index)['recipientAddress'].length - 4) : analyzeTransaction(index)['senderAddress'] == null ? '' : analyzeTransaction(index)['senderAddress'].substring(0, 5) + '...' + analyzeTransaction(index)['senderAddress'].substring(analyzeTransaction(index)['senderAddress'].length - 4)}",
                                                                  style: TextStyle(
                                                                    color: subtextColor.value,
                                                                    fontSize: 12,
                                                                    fontFamily: 'DM Sans',
                                                                    fontWeight: FontWeight.w400,
                                                                  ),
                                                                )
                                                          : Text(
                                                              getTransactionDetails(index)['address'].length < 5
                                                                  ? ""
                                                                  : "${getTransactionDetails(index)['address'].substring(0, 5) + '...' + getTransactionDetails(index)['address'].substring(getTransactionDetails(index)['address'].length - 4)}",
                                                              style: TextStyle(
                                                                color: subtextColor.value,
                                                                fontSize: 12,
                                                                fontFamily: 'DM Sans',
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                        SizedBox(height: 6),
                                        Container(
                                          width: Get.width,
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 1,
                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                color: Color(0xFF242438),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            getTransactionDetails(index)['transactionType'] == 'spl-associated-token-account'
                                                ? Text(
                                                    'Create SPL Account',
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      color: subtextColor.value,
                                                      fontSize: 12,
                                                      fontFamily: 'DM Sans',
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  )
                                                : Column(
                                                    //mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Amount',
                                                        textAlign: TextAlign.right,
                                                        style: TextStyle(
                                                          color: subtextColor.value,
                                                          fontSize: 12,
                                                          fontFamily: 'DM Sans',
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                      SizedBox(height: 4),
                                                      Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            widget.index == 0
                                                                ? getTransactionDetails(index)['amount']
                                                                : '${getTokenAmount(appController.tokenTransactions[index].transaction!.message!.instructions!)}',
                                                            textAlign: TextAlign.right,
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 14,
                                                              fontFamily: 'DM Sans',
                                                              fontWeight: FontWeight.w700,
                                                            ),
                                                          ),
                                                          SizedBox(width: 4),
                                                          Text(
                                                            '${widget.token.symbol}',
                                                            textAlign: TextAlign.right,
                                                            style: TextStyle(
                                                              color: lightTextColor.value,
                                                              fontSize: 14,
                                                              fontFamily: 'DM Sans',
                                                              fontWeight: FontWeight.w700,
                                                              height: 0.09,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                            if (getTransactionType(index: index) == "Swap")
                                              Container(
                                                width: 20,
                                                height: 20,
                                                child: SvgPicture.asset("assets/svg/swap.svg"),
                                              ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  getTransactionType(index: index) == "Swap" ? 'To' : 'Date',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color: subtextColor.value,
                                                    fontSize: 12,
                                                    fontFamily: 'DM Sans',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                getTransactionType(index: index) == "Swap"
                                                    ? Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            '0.68612',
                                                            textAlign: TextAlign.right,
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 14,
                                                              fontFamily: 'DM Sans',
                                                              fontWeight: FontWeight.w700,
                                                            ),
                                                          ),
                                                          SizedBox(width: 4),
                                                          Text(
                                                            'ETH',
                                                            textAlign: TextAlign.right,
                                                            style: TextStyle(
                                                              color: subtextColor.value,
                                                              fontSize: 14,
                                                              fontFamily: 'DM Sans',
                                                              fontWeight: FontWeight.w700,
                                                              height: 0.09,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Row(
                                                        children: [
                                                          if (appController.tokenTransactions[index] != null)
                                                            Text(
                                                              '${DateFormat('d MMM, y hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(
                                                                int.parse(
                                                                  (appController.tokenTransactions[index].blockTime! * 1000).toString(),
                                                                ),
                                                              ))}',
                                                              textAlign: TextAlign.right,
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 12,
                                                                fontFamily: 'DM Sans',
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                SizedBox(
                                                  height: 36,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    print('=========');
                                                    UtilService().launchURL(context,
                                                        'https://solscan.io/tx/${appController.tokenTransactions[index].transaction?.signatures?[0]}');
                                                  },
                                                  child: Container(
                                                    height: 16,
                                                    color: Colors.transparent,
                                                    child: Text(
                                                      'View on SOLSCAN',
                                                      textAlign: TextAlign.right,
                                                      style: TextStyle(
                                                        color: subtextColor.value,
                                                        fontSize: 14,
                                                        fontFamily: 'DM Sans',
                                                        fontWeight: FontWeight.w700,
                                                        height: 0.09,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                  ),
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
                child: CachedNetworkImage(
                  imageUrl: widget.token.uri ?? '',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 8),
              SizedBox(
                width: 66,
                child: Text(
                  '${widget.token.symbol}',
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
                          backgroundColor: Colors.white,
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
                          color: primaryColor.value,
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

  String getTransactionType({required int index}) {
    if (appController.tokenTransactions[index].transaction?.message?.accountKeys?[0] == appController.publicKey.value) {
      return 'Send';
    } else {
      return 'Receive';
    }
    return '';
  }

  bool isSendTransaction(int index) {
    String walletAddress = appController.publicKey.value;
    try {
      List<Instructions> instructions = appController.tokenTransactions[index].transaction!.message!.instructions!;

      for (var instruction in instructions) {
        var info = instruction.parsed!.info!;
        //print('info =====> ${info.source}');
        // Check if the source matches your wallet address, indicating a send transaction
        if (info.source == walletAddress) {
          return true; // It's a send transaction
        } else {
          return false;
        }
      }
    } catch (e) {
      print('Error parsing transaction: $e');
    }

    return false; // Default to receive if nothing matches
  }

  String isSendTransactionAddress(int index) {
    String walletAddress = appController.publicKey.value;
    try {
      List<Instructions> instructions = appController.tokenTransactions[index].transaction!.message!.instructions!;

      for (var instruction in instructions) {
        var info = instruction.parsed!.info!;
        //print('info =====> ${info.source}');
        // Check if the source matches your wallet address, indicating a send transaction
        if (info.source == walletAddress) {
          return info.source ?? ''; // It's a send transaction
        } else {
          return walletAddress;
        }
      }
    } catch (e) {
      print('Error parsing transaction: $e');
    }

    return ''; // Default to receive if nothing matches
  }

  String getTransactionTypeAddress(int index) {
    String walletAddress = appController.publicKey.value;
    try {
      List<Instructions> instructions = appController.tokenTransactions[index].transaction!.message!.instructions!;

      for (var instruction in instructions) {
        var info = instruction.parsed!.info!;
        //print('Source: ${info.source}, Destination: ${info.destination}');

        // Check if the source matches your wallet address, indicating a send transaction
        if (info.source == walletAddress) {
          return info.destination ?? ''; // Return the destination address if it's a send transaction
        }

        // Check if the destination matches your wallet address, indicating a receive transaction
        if (info.destination == walletAddress) {
          return info.source ?? ''; // Return the source address if it's a receive transaction
        }
      }
    } catch (e) {
      print('Error parsing transaction: $e');
    }

    return ''; // Return an empty string if no relevant transaction type is found
  }

/*  Map<String, dynamic> getTransactionDetails(int index) {
    String walletAddress = appController.publicKey.value;
    const int lamportsPerSol = 1000000000;
    try {
      List<Instructions> instructions = appController.tokenTransactions[index].transaction!.message!.instructions!;

      for (var instruction in instructions) {
        var programId = instruction.programId!;
        var info = instruction.parsed?.info;

        if (programId != '11111111111111111111111111111111') {
          // It's an SPL Token transfer
          Token symbol = appController.tokenList.firstWhere((element) => element.tokenAddress == instruction.parsed!.info!.mint!);

          if (symbol != null && symbol.symbol != '') {
            return {
              'transactionType': 'SPL',
              'type': isSendTransaction(index) ? 'Send' : 'Received',
              'address': isSendTransaction(index) ? info?.destination ?? '' : info?.source ?? '',
              'amount': info?.tokenAmount?.uiAmountString ?? '0',
              'symbol': symbol.symbol
            };
            //value not exists
          } else {
            return {
              'transactionType': 'SPL',
              'type': isSendTransaction(index) ? 'Send' : 'Received',
              'address': isSendTransaction(index) ? info?.destination ?? '' : info?.source ?? '',
              'amount': info?.tokenAmount?.uiAmountString ?? '0',
              'symbol': ''
            };
          }
        } else {
          // It's likely a native SOL transfer
          var amount = instruction.parsed?.info?.lamports.toString() ?? '0';

          if (info?.source == walletAddress) {
            return {
              'transactionType': 'SOL',
              'type': 'send',
              'address': info?.destination ?? '',
              'amount': (num.parse(amount) / lamportsPerSol).toString(),
            };
          }

          if (info?.destination == walletAddress) {
            return {
              'transactionType': 'SOL Transfer',
              'type': 'receive',
              'address': info?.source ?? '',
              'amount': (num.parse(amount) / lamportsPerSol).toString(),
            };
          }
        }
      }
    } catch (e) {
      print('Error parsing transaction: $e');
    }

    return {
      'transactionType': 'unknown',
      'type': 'unknown',
      'address': '',
      'amount': '0',
    }; // Default return if no relevant transaction type is found
  }*/

  /*Map<String, dynamic> getTransactionDetails(int index) {
    String walletAddress = appController.publicKey.value;
    const int lamportsPerSol = 1000000000;

    try {
      List<Instructions> instructions = appController.tokenTransactions[index].transaction!.message!.instructions!;

      print(appController.tokenTransactions[index].transaction!.signatures![0]);
      for (var instruction in instructions) {
        var programId = instruction.programId!;
        var info = instruction.parsed?.info;

        print("index $index    parsed : ${instruction.parsed}");
        print("index $index    type : ${instruction.parsed!.type}");
        if (programId != '11111111111111111111111111111111') {
          // It's an SPL Token transfer
          Token? symbol = appController.tokenList.firstWhere(
                (element) => element.tokenAddress == info?.mint,
            orElse: () => Token(tokenAddress: '', symbol: ''), // Default empty token if not found
          );
          //print("symbol.toJson() ${symbol.toJson()}");

          bool isSender = info?.source == walletAddress || info?.multisigAuthority == walletAddress;
          bool isReceiver = info?.destination == walletAddress || info?.multisigAuthority == walletAddress;
          var amount;
          if (instruction.parsed?.type == "transferChecked") {
            var tokenAmount = instruction.parsed?.info?.tokenAmount;
            if (tokenAmount != null) {
              amount =tokenAmount.uiAmountString ?? 0.0;
            }
          }
          if (isSender || isReceiver) {
            return {
              'transactionType': 'SPL',
              'type': isSender ? 'Send' : 'Received',
              'address': isSender ? info?.destination ?? '' : info?.source ?? '',
              'amount': amount ?? '0',
              'symbol': (symbol.symbol == null || symbol.symbol == 'null') ? '' : symbol.symbol,
            };
          }
        }
      }
    } catch (e) {
      print('Error parsing transaction: $e');
    }

    return {
      'transactionType': 'unknown',
      'type': 'unknown',
      'address': '',
      'amount': '0',
      'symbol': 'Unknown'
    }; // Default return if no relevant transaction type is found
  }*/

  Map<String, dynamic> getTransactionDetails(int index) {
    String walletAddress = appController.publicKey.value;
    const int lamportsPerSol = 1000000000;
    try {
      List<Instructions> instructions = appController.tokenTransactions[index].transaction!.message!.instructions!;
      for (var instruction in instructions) {
        var programId = instruction.programId!;
        var info = instruction.parsed?.info;

        if (programId == '11111111111111111111111111111111' || programId == 'ComputeBudget111111111111111111111111111111') {
          // It's likely a native SOL transfer
          var amount = instruction.parsed?.info?.lamports.toString() ?? '0';

          if (info?.source == walletAddress) {
            return {
              'transactionType': 'SOL',
              'type': 'send',
              'address': info?.destination ?? '',
              'amount': (num.parse(amount) / lamportsPerSol).toString(),
            };
          }

          if (info?.destination == walletAddress) {
            return {
              'transactionType': 'SOL Transfer',
              'type': 'receive',
              'address': info?.source ?? '',
              'amount': (num.parse(amount) / lamportsPerSol).toString(),
            };
          }
        } else {
          if (instruction.parsed?.type == 'create') {
            return {'transactionType': 'spl-associated-token-account', 'type': 'Create', 'address': '', 'amount': '', 'symbol': ''};
          }
          // Iterate over instructions based on length
          for (int i = 0; i < instructions.length; i++) {
            var instruction = instructions[i];
            var info = instruction.parsed?.info;

            // It's an SPL Token transfer
            Token? symbol = appController.tokenList.firstWhere(
              (element) => element.tokenAddress == info?.mint,
              orElse: () => Token(tokenAddress: '', symbol: ''), // Default empty token if not found
            );

            bool isSender = info?.source == walletAddress || info?.multisigAuthority == walletAddress;
            bool isReceiver = info?.destination == walletAddress || info?.multisigAuthority == walletAddress;

            if (instruction.parsed?.type == "transferChecked") {
              var tokenAmount = instruction.parsed?.info?.tokenAmount;
              if (tokenAmount != null) {
                String amount = tokenAmount.uiAmountString ?? '0';

                if (isSender || isReceiver) {
                  return {
                    'transactionType': 'SPL',
                    'type': isSendTransaction(index) ? 'Send' : 'Received',
                    'address': isSendTransaction(index) ? info?.destination ?? '' : info?.source ?? '',
                    'amount': amount,
                    'symbol': (symbol.symbol == null || symbol.symbol == 'null') ? '' : symbol.symbol,
                  };
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print('Error parsing transaction: $e');
    }

    return {
      'transactionType': 'unknown',
      'type': 'unknown',
      'address': '',
      'amount': '0',
      'symbol': 'Unknown'
    }; // Default return if no relevant transaction type is found
  }

  String getTokenAmount(List<Instructions> instructions) {
    for (var instruction in instructions) {
      print(instruction.parsed?.toJson());
      if (instruction.parsed?.type == "transferChecked") {
        var tokenAmount = instruction.parsed?.info?.tokenAmount;
        if (tokenAmount != null) {
          return tokenAmount.uiAmountString ?? '0';
        }
      }
    }
    return '0';
  }

  Widget infoWidget({
    required String title,
    required String data,
    required bool isUsd,
    bool? isLast,
    required bool showSign,
  }) {
    return Obx(
      () => Column(
        children: [
          Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$title',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: subtextColor.value,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                appController.loadingPrice.value == true
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.25),
                        highlightColor: Colors.grey.withOpacity(0.5),
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          width: 50,
                          height: 11,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : isUsd == true
                        ? Text(
                            NumberFormat.compactCurrency(decimalDigits: 2, locale: 'en_US', symbol: showSign == false ? '' : '\$')
                                .format(num.tryParse(data)),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                            ),
                          )
                        : Container(
                            constraints: BoxConstraints(
                              maxWidth: 150,
                            ),
                            child: Text(
                              title == 'Contract Address' ? '${data.substring(0, 5) + '...' + data.substring(data.length - 4)}' : '$data',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
              ],
            ),
          ),
          if (isLast != true) SizedBox(height: 8),
          if (isLast != true)
            Container(
              width: double.infinity,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: Color(0xFF242438),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget webLinkWidget({required String title, required String data, bool? isLast, Widget? iconWidget}) {
    return Obx(
      () => Column(
        children: [
          Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$title',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: subtextColor.value,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                appController.loadingPrice.value == true
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.25),
                        highlightColor: Colors.grey.withOpacity(0.5),
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          width: 50,
                          height: 11,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : iconWidget ??
                        Text(
                          '$data',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
              ],
            ),
          ),
          if (isLast != true) SizedBox(height: 8),
          if (isLast != true)
            Container(
              width: double.infinity,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: Color(0xFF242438),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Map<String, dynamic> analyzeTransaction(int index) {
    String? recipientAddress;
    String? senderAddress;
    bool isSentFromMyAddress = false;

    for (var i = 0;
        i <
            (appController.tokenTransactions[index].meta!.preTokenBalances!.length! > 2
                ? 2
                : appController.tokenTransactions[index].meta!.preTokenBalances!.length!);
        i++) {
      var preBalance = appController.tokenTransactions[index].meta!.preTokenBalances![i];
      var postBalance = appController.tokenTransactions[index].meta!.postTokenBalances![i];

      // Check if the token amount decreased in any account, indicating a transfer out
      if (int.parse(preBalance.uiTokenAmount!.amount!) > int.parse(postBalance.uiTokenAmount!.amount!)) {
        if (preBalance.owner == appController.publicKey.value) {
          isSentFromMyAddress = true;
          senderAddress = preBalance.owner; // Store the sender's address
        } else {
          senderAddress = preBalance.owner; // The sender is another address
        }
      }

      // Check if the token amount increased in any account, indicating a transfer in
      if (int.parse(preBalance.uiTokenAmount!.amount!) < int.parse(postBalance.uiTokenAmount!.amount!)) {
        if (postBalance.owner == appController.publicKey.value) {
          recipientAddress = postBalance.owner; // Your address is the recipient
        } else {
          recipientAddress = postBalance.owner; // The recipient is another address
        }
      }
    }

    return {
      'isSentFromMyAddress': isSentFromMyAddress,
      'senderAddress': senderAddress,
      'recipientAddress': recipientAddress,
    };
  }
}
