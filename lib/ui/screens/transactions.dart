import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/colors.dart';
import '../../controllers/appController.dart';
import '../../models/tokenModel.dart';
import 'package:http/http.dart' as http;

import '../../models/transactionsModel.dart';
import '../../utilService/UtilService.dart';

class Transactions extends StatefulWidget {
  Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  final appController = Get.find<AppController>();
  RefreshController _refreshController = new RefreshController(initialRefresh: false);
  @override
  void initState() {
    // TODO: implement initState
    if (appController.transactions.length == 0) {
      getTransactions();
    }
    super.initState();
  }
  getTransactions() {
    UtilService().getNativeTransactions(limit: 50, offset: 0, method: '', address: appController.publicKey.value).then((value) {
      _refreshController.refreshCompleted();
    });
  }

  loadMoreTransactions() {
    UtilService().getNativeTransactions(limit: 15, offset: appController.transactions.length, method: 'add', address: appController.publicKey.value).then((value) {
      _refreshController.loadComplete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Scaffold(
        backgroundColor: primaryBackgroundColor.value,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Transactions',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 16,
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
                      getTransactions();
                    },
                    onLoading: () {
                      loadMoreTransactions();
                    },
                    child: appController.getTransactionsLoader.value == true
                        ? ListView.separated(
                      padding: EdgeInsets.only(top: 4.0, bottom: 120, left: 2.0, right: 2),
                      itemCount: 12,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 8,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.withOpacity(0.25),
                          highlightColor: Colors.grey.withOpacity(0.5),
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            width: Get.width,
                            height: 86,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    )
                        : appController.getTransactionsLoader.value == false && appController.transactions.length == 0
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: Get.width,
                          child: Text(
                            'You do not have any transactions associated to your wallet!',
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
                      itemCount: appController.transactions.length,
                      padding: EdgeInsets.only(top: 4.0, bottom: 120, left: 2.0, right: 2),
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
                                  /*Expanded(
                                              child: Text(
                                    '${getTransactionDetails(index)['transactionType'] == 'SPL'?
                                    getTransactionTypeSpl(appController.transactions[index].transaction!.message!.instructions!) :
                                    isSendTransaction(index) == true ? 'Send' : 'Received'}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontFamily: 'DM Sans',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),*/
                                  Expanded(
                                    child: Text(
                                      '${getTransactionDetails(index)['transactionType'] == 'SPL' ||
                                          getTransactionDetails(index)['transactionType'] == 'unknown' ||
                                          getTransactionDetails(index)['transactionType'] == 'spl-associated-token-account' ?
                                      getTransactionDetails(index)['transactionType'] == 'spl-associated-token-account' ?
                                      'Initialize the associated token account' : analyzeTransaction(index)['isSentFromMyAddress'] ?
                                      'Send' : 'Receive' : isSendTransaction(index) == true ? 'Send' : 'Received'}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'DM Sans',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Row(
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
                                        "${getTransactionDetails(index)['address'].substring(0, 5) + '...' + getTransactionDetails(index)['address'].substring(getTransactionDetails(index)['address'].length - 4)}",
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

                                  getTransactionDetails(index)['transactionType'] == 'spl-associated-token-account' ? Text(
                                    'Create SPL Account',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: subtextColor.value,
                                      fontSize: 12,
                                      fontFamily: 'DM Sans',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ):
                                  Column(
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
                                          getTransactionDetails(index)['transactionType'] == 'SPL' || getTransactionDetails(index)['transactionType'] == 'unknown'
                                              ? FutureBuilder<Map<String, dynamic>>(
                                            future: getTokenAmount(appController.transactions[index].transaction!.message!.instructions!),
                                            builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return Text(
                                                  '...',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontFamily: 'DM Sans',
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                );
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                  '',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontFamily: 'DM Sans',
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                );
                                              } else {
                                                final data = snapshot.data ?? {'amount': '0', 'symbol': ''};
                                                return Container(
                                                  constraints: BoxConstraints(
                                                    maxWidth: Get.width * 0.44,
                                                  ),
                                                  child: Text(
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    '${getTransactionDetails(index)['transactionType'] == 'SPL' || getTransactionDetails(index)['transactionType'] == 'unknown' ? data['amount'] : getTransactionDetails(index)['amount']} ${data['symbol']}',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: lightTextColor.value,
                                                      fontSize: 14,
                                                      fontFamily: 'DM Sans',
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          )
                                              : Text(
                                            '${getTransactionDetails(index)['amount']}',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: lightTextColor.value,
                                              fontSize: 14,
                                              fontFamily: 'DM Sans',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            '${getTransactionDetails(index)['transactionType'] == 'SPL' || getTransactionDetails(index)['transactionType'] == 'unknown' ? '' : 'Sol'}',
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
                                      /*SizedBox(height: 36,),
                                                GestureDetector(
                                                  onTap: (){
                                                    print('=========');
                                                    UtilService().launchURL(context,'https://solscan.io/tx/${appController.transactions[index].transaction?.signatures?[0]}');
                                                  },
                                                  child: Container(
                                                    height: 16,
                                                    color:Colors.transparent,
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
                                                ),*/
                                    ],
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
                                          if (appController.transactions[index] != null)
                                            Text(
                                              '${DateFormat('d MMM, y hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(
                                                int.parse(
                                                  (appController.transactions[index].blockTime! * 1000).toString(),
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
                                          UtilService().launchURL(context, 'https://solscan.io/tx/${appController.transactions[index].transaction?.signatures?[0]}');
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getTransactionType({required int index}) {
    if (appController.transactions[index].transaction?.message?.accountKeys?[0] == appController.publicKey.value) {
      return 'Send';
    } else {
      return 'Receive';
    }
    return '';
  }

  bool isSendTransaction(int index) {
    String walletAddress = appController.publicKey.value;
    try {
      List<Instructions> instructions = appController.transactions[index].transaction!.message!.instructions!;

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

  Map<String, dynamic> getTransactionDetails(int index) {
    String walletAddress = appController.publicKey.value;
    const int lamportsPerSol = 1000000000;
    try {
      List<Instructions> instructions = appController.transactions[index].transaction!.message!.instructions!;

      for (var instruction in instructions) {
        var programId = instruction.programId!;
        var info = instruction.parsed?.info;

        if (programId == '11111111111111111111111111111111' || programId == 'ComputeBudget111111111111111111111111111111') {

          var amount = instruction.parsed?.info?.lamports.toString() ?? '0';
          if (info?.source == walletAddress) {
            NumberFormat formatter = NumberFormat('########.#########', 'en_US');
            print("indexparsedsrc ====> ${instruction.parsed?.info?.source} isol");
            return {
              'transactionType': 'SOL',
              'type': 'send',
              'address': info?.destination ?? '',
              'amount': formatter.format((num.parse(amount) / lamportsPerSol)),
              'symbol': 'Sol'
            };
          }

          if (info?.destination == walletAddress) {
            NumberFormat formatter = NumberFormat('#######.#########', 'en_US');
            return {
              'transactionType': 'SOL Transfer',
              'type': 'receive',
              'address': info?.source ?? '',
              'amount': formatter.format((num.parse(amount) / lamportsPerSol)),
              'symbol': 'Sol'
            };
          }
        } else {
          // It's an SPL Token transfer
          Token symbol = appController.tokenList.firstWhere((element) => element.tokenAddress == instruction.parsed!.info!.mint!);

          if (instruction.parsed?.type == 'create') {
            return {'transactionType': 'spl-associated-token-account', 'type': 'Create', 'address': '', 'amount': '', 'symbol': ''};
          }
          if (symbol != null && symbol.symbol != '') {
            return {
              'transactionType': 'SPL',
              'type': isSendTransaction(index) ? 'Send' : 'Received',
              'address': isSendTransaction(index) ? info?.destination ?? '' : info?.source ?? '',
              'amount': getTokenAmount(appController.transactions[index].transaction!.message!.instructions!),
              'symbol': symbol.symbol
            };
            //value not exists
          } else {
            return {
              'transactionType': 'SPL',
              'type': isSendTransaction(index) ? 'Send' : 'Received',
              'address': isSendTransaction(index) ? info?.destination ?? '' : info?.source ?? '',
              'amount': getTokenAmount(appController.transactions[index].transaction!.message!.instructions!),
              'symbol': ''
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
  }

  Future<Map<String, dynamic>> getTokenAmount(List<Instructions> instructions) async {
    for (var instruction in instructions) {
      print(instruction.parsed?.toJson());
      if (instruction.parsed?.type == "transferChecked") {
        var tokenAmount = instruction.parsed?.info?.tokenAmount;
        print('tokenAmountssss ${instruction.parsed!.info!.mint!}');
        if (tokenAmount != null) {
          Token symbol = appController.tokenList.firstWhere(
                (element) => element.tokenAddress == instruction.parsed!.info!.mint!,
            orElse: () => Token(tokenAddress: '', symbol: ''), // Provide a default token if not found
          );
          print("symbol.toJson() ${symbol.toJson()}");
          if (symbol.symbol == '') {
            symbol.symbol = await fetchTokenName(instruction.parsed!.info!.mint!);
          }
          return {"amount": tokenAmount.uiAmountString ?? '0', "symbol": symbol.symbol};
        }
      }
    }
    return {"amount": '0', "symbol": ''};
  }

  String getTransactionTypeSpl(List<Instructions> instructions) {
    String walletAddress = appController.publicKey.value;
    for (var instruction in instructions) {
      bool isSender = instruction.parsed?.info?.source == walletAddress || instruction.parsed?.info?.multisigAuthority == walletAddress;
      bool isReceiver = instruction.parsed?.info?.destination == walletAddress || instruction.parsed?.info?.multisigAuthority == walletAddress;

      if (instruction.parsed?.type == "transferChecked") {
        return isSender ? 'Send' : 'Received';
      }
    }
    return '';
  }

  Future<String> fetchTokenName(String tokenAddress) async {
    final url = 'https://api.shyft.to/sol/v1/token/get_info?network=mainnet-beta&token_address=$tokenAddress';
    final apiKey = 'YOUR-SHYFT-API-KEY-HERE';
    if (appController.tokenNameCache.containsKey(tokenAddress)) {
      return appController.tokenNameCache[tokenAddress]!;
    }
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'x-api-key': apiKey,
        },
      );
      print('response ${response.bodyBytes}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        appController.tokenNameCache[tokenAddress] = data['result']['name'];
        return data['result']['name'] ?? 'Unknown';
      } else {
        print('Failed to load token info: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      print('Error fetching token info: $e');
      return '';
    }
  }

  Map<String, dynamic> analyzeTransaction(int index) {
    String? recipientAddress;
    String? senderAddress;
    bool isSentFromMyAddress = false;

    for (var i = 0; i < (appController.transactions[index].meta!.preTokenBalances!.length! > 2 ? 2 : appController.transactions[index].meta!.preTokenBalances!.length!); i++) {
      var preBalance = appController.transactions[index].meta!.preTokenBalances![i];
      var postBalance = appController.transactions[index].meta!.postTokenBalances![i];

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
