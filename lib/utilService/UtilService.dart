import 'dart:convert';
import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solana/solana.dart';
import 'package:solana_flutter/models/nftModel.dart';
import 'package:solana_flutter/models/signaturesModel.dart';
import 'package:solana_flutter/models/transactionsModel.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/colors.dart';
import '../controllers/appController.dart';
import '../models/newNftModel.dart';
import 'dataService.dart';
import 'package:solana_web3/solana_web3.dart'as web3;
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';

class UtilService {
  static String? selectedLanguage;
  static bool firstLaunch = true;
  final appController = Get.find<AppController>();

  bool isEmail(String email) {
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(email);
  }

  static Future<void> getSavedData() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    if (!sharedPref.containsKey('firstLaunch')) {
      await sharedPref.setBool('firstLaunch', false);
    } else {
      UtilService.firstLaunch = sharedPref.getBool("firstLaunch")!;
    }
  }

  Future<void> copyToClipboard(String copiedText) async {
    await Clipboard.setData(ClipboardData(text: copiedText));
    HapticFeedback.vibrate();
  }

  showToast(message, {Color color = Colors.red}) {
    Fluttertoast.showToast(
        msg: "$message", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: color, textColor: Colors.white, fontSize: 16.0);
  }

  static bool deviceSizeAbove750(context) {
    Size size = MediaQuery.of(context).size;
    if (size.height > 750) {
      return true;
    } else {
      return false;
    }
  }

  String toFixed2DecimalPlaces(String? data, {int decimalPlaces = 2}) {
    if (data != null && data != 'null') {
      data = Decimal.parse(data).toString();
      List<String> values = data.split('.');
      if (values.length == 2 && values[1].length > decimalPlaces) {
        return values[0] + '.' + values[1].substring(0, decimalPlaces);
      } else {
        return data.toString();
      }
    }
    return '0';
  }

  void getLanguage() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    selectedLanguage = _prefs.getString('SELECTED_LANGUAGE') ?? 'uk';
    print("getStatic $selectedLanguage");
  }
  launchUrl(String url) async {
    print(url);
    if(await canLaunchUrl(Uri.parse(url))){
      await launchUrl(url);
    }else {
      throw 'Could not launch $url';
    }
  }
  void launchURL(BuildContext context, url) async {
    try {
      await launch(
        url,
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
  getDangerMsg(
    String msg,
    BuildContext context,
  ) {
    // Toast.show(msg, context,
    //     gravity: Toast.CENTER, duration: 2, backgroundColor: dangerColor);
    Fluttertoast.showToast(
        msg: "$msg", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
  }

  Future getNFTData({required int page, required method}) async {
    final appController = getx.Get.find<AppController>();
    if (method != 'add') {
      appController.getNFTLoader.value = true;
    }

    String str = '';

    Response? response = await DataService().genericDioPostCall('YOUR-QUICKNODE-FETCH-NFT-URL-HERE', data: {
      "id": 67,
      "jsonrpc": "2.0",
      "method": "qn_fetchNFTs",
      "params": {"wallet": "${appController.publicKey.value}", "page": page, "perPage": 7}
    });
    bool res = false;
    if (response!.statusCode! <= 201) {
      if (response.data != null) {
        print("nft res data ${response.data}");
        if (method == 'add') {
          var nft = NftModel.fromJson(response.data);
          appController.nftData.value.result!.assets!.addAll(nft.result!.assets as Iterable<Assets>);
          appController.nftData.refresh();
        } else {
          appController.nftData.value = NftModel.fromJson(response.data);
        }
        appController.getNFTLoader.value = false;
      }
    } else {
      appController.getNFTLoader.value = false;
    }
    return res;
  }

  // Function to get the transaction fee in SOL
  final Dio _dio = Dio();
  Future<String> getLatestBlockhash(String rpcUrl) async {
    final headers = {'Content-Type': 'application/json'};
    final blockhashBody = jsonEncode({
      'jsonrpc': '2.0',
      'id': 1,
      'method': 'getLatestBlockhash',
      'params': []
    });

    try {
      Response response = await _dio.post(
        rpcUrl,
        data: blockhashBody,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200 && response.data['result'] != null) {
        final blockhash = response.data['result']['value']['blockhash'];
        print("Latest Blockhash: $blockhash");
        return blockhash;
      } else {
        print("Invalid blockhash response: ${response.data}");
        throw Exception('Failed to fetch latest blockhash.');
      }
    } catch (e) {
      print("Error fetching blockhash: $e");
      throw Exception('Error fetching blockhash: $e');
    }
  }

  Future<double> getTransactionFee(String rpcUrl, String base64Message) async {
    final headers = {'Content-Type': 'application/json'};

    try {

      print("Base64 Encoded Message: $base64Message");

      // Step 2: Call getFeeForMessage with the base64-encoded message
      final feeMessageBody = jsonEncode({
        'jsonrpc': '2.0',
        'id': 2,
        'method': 'getFeeForMessage',
        'params': [
          base64Message,
          {'commitment': 'processed'}
        ]
      });

      Response feeResponse = await _dio.post(
        rpcUrl,
        data: feeMessageBody,
        options: Options(headers: headers),
      );

      if (feeResponse.statusCode == 200 && feeResponse.data['result'] != null) {
        final fee = feeResponse.data['result']['value'];
        print("Transaction Fee (lamports): $fee");
        return fee / lamportsPerSol;
      } else {
        print("Invalid fee response: ${feeResponse.data}");
        throw Exception('Failed to fetch transaction fee.');
      }
    } catch (e) {
      print("Error fetching transaction fee: $e");
      throw Exception('Error fetching transaction fee: $e');
    }
  }


  Future<String> fetchTransactions({required int limit,required String method,}) async {
    final url = 'https://api.shyft.to/sol/v1/wallet/transaction_history?network=mainnet-beta&wallet=${appController.publicKey.value}&tx_num=5';
    final apiKey = 'YOUR-SHYFT-API-KEY-HERE';
    if (method != 'add') {
      appController.getTransactionsLoader.value = true;
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
        if (response != null) {
          if (method == 'add') {
            appController.transactions.addAll((data['result'] as List).map((e) => SolanaNotificationModel.fromJson(e)).toList());
          } else {
            print(data['result']);
            appController.transactions.value = (data['result'] as List).map((x) => SolanaNotificationModel.fromJson(x)).toList();
          }
          appController.getTransactionsLoader.value = false;
        } else {
          appController.getTransactionsLoader.value = false;
        }
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




  Future getNativeTransactions({required int limit,required int offset,
    required String method,required String address}) async {
    final appController = getx.Get.find<AppController>();

    if (method != 'add') {
      appController.getTransactionsLoader.value = true;
    }

    String str = '';

    Response? response = await DataService().genericDioGetCall('YOUR-CLOUD-FUNCTION-BASEURL-HERE/'
        'getSolanaNativeTransactionsLive?address=${appController.publicKey.value}&limit=$limit&offset=$offset&isSol=false');
    bool res = false;
    print('response==? $response');
    if (response != null) {
      if (method == 'add') {
        appController.transactions.addAll((response.data as List).map((e) => SolanaNotificationModel.fromJson(e)).toList());
      } else {
        appController.transactions.value = (response.data as List).map((x) => SolanaNotificationModel.fromJson(x)).toList();
      }
      appController.getTransactionsLoader.value = false;
    } else {
      appController.getTransactionsLoader.value = false;
    }
    return res;
  }
  saveImageToGallery({required String imageUrl,required context}) async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        // Request storage permission for Android versions <= 32
        status = await Permission.storage.request();
      } else {
        // Request photos permission for Android versions > 32
        status = await Permission.photos.request();
      }
    } else {
      // For iOS, request photos permission
      status = await Permission.photos.request();
    }

    if (status.isGranted) {
      appController.saveImageToGalleryLoader.value = true;
      var response = await Dio().get(
          imageUrl,
          options: Options(responseType: ResponseType.bytes));
      print('response ${response.statusCode}');
      if (response.statusCode == 200) {
        await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 100,);
        appController.saveImageToGalleryLoader.value = false;
        showToast('Successfully saved to gallery!',color: greenColor.value);
      } else {
        appController.saveImageToGalleryLoader.value = false;
      }
    } else {
      print('Permission denied!');
      return false;
    }
  }
  Future<void> fetchNewNFTs({required String walletAddress,required int page,String? method}) async {
    if (method != 'add') {
      appController.getNFTLoader.value = true;
    }
    final String apiUrl = 'https://api.shyft.to/sol/v2/nft/read_all';
    final String apiKey = 'YOUR-SHYFT-API-KEY-HERE'; //YOUR-SHYFT-API-KEY-HERE

    final Uri uri = Uri.parse('$apiUrl?network=mainnet-beta&address=$walletAddress&page=$page&size=10');

    print('URL => $uri');
    final response = await http.get(
      uri,
      headers: {
        'accept': 'application/json',
        'x-api-key': apiKey,
      },
    );

    print('Response => ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Handle the data as needed
      data['result']['nfts'];
      print("data ======>$data");
      print("data ======>${data['result']}");
      print("data ======>${data['result']['nfts']}");
      print("data ======>${data['result']['nfts']}");
      if (data != null) {
        if (method == 'add') {
          appController.newNftDataList.addAll((data['result']['nfts'] as List).map((e) => NewNftModel.fromJson(e)).toList());
        } else {
          appController.newNftDataList.value = (data['result']['nfts'] as List).map((x) => NewNftModel.fromJson(x)).toList();
        }
        appController.getNFTLoader.value = false;
      }
    } else {
      print('Failed to fetch NFTs: ${response.statusCode}');
      appController.getNFTLoader.value = false;
    }
  }
  Future getTokenTransactions({required int limit,required int offset,
    required String method,required String address,required String tokenAddress,required bool isSol}) async {
    final appController = getx.Get.find<AppController>();

    if (method != 'add') {
      appController.getTokenTransactionsLoader.value = true;
    }

    String str = '';

    Response? response = await DataService().genericDioGetCall(
        isSol == true? 'YOUR-CLOUD-FUNCTION-BASEURL-HERE/getSolanaNativeTransactionsLive?address=$address&limit=$limit&offset=$offset&isSol=true':
        'YOUR-CLOUD-FUNCTION-BASEURL-HERE/getSolanaTokenTransactionsLive?'
            'address=${appController.publicKey.value}&limit=$limit&offset=$offset&tokenAddress=$tokenAddress');
    bool res = false;
    print('response==? $response');
    if (response != null) {
      if (method == 'add') {
        appController.tokenTransactions.addAll((response.data as List).map((e) => SolanaNotificationModel.fromJson(e)).toList());
      } else {
        appController.tokenTransactions.value = (response.data as List).map((x) => SolanaNotificationModel.fromJson(x)).toList();
      }
      appController.getTokenTransactionsLoader.value = false;
    } else {
      appController.getTokenTransactionsLoader.value = false;
    }
    return res;
  }
}

extension ExtractHash on Text {
  Text extractHash(String target, type, bool isDetail) {
    final textSpans = List.empty(growable: true);
    final escapedTarget = RegExp.escape(target);
    final pattern = RegExp(escapedTarget, caseSensitive: false);
    final matches = pattern.allMatches(data!);

    int currentIndex = 0;
    for (final match in matches) {
      final beforeMatch = data!.substring(currentIndex, match.start);
      if (beforeMatch.isNotEmpty) {
        textSpans.add(
          TextSpan(
            text: beforeMatch,
            style: isDetail == true
                ? TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  )
                : TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
          ),
        );
      }

      var matchedText = data!.substring(match.start, match.end);
      matchedText = matchedText;
      textSpans.add(
        TextSpan(
          text: matchedText,
          style: isDetail == true
              ? TextStyle(
                  color: labelColorPrimaryShade.value,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                )
              : TextStyle(
                  color: labelColorPrimaryShade.value,
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
        ),
      );

      currentIndex = match.end;
    }

    if (currentIndex < data!.length) {
      final remainingText = data!.substring(currentIndex);
      textSpans.add(
        isDetail == true
            ? TextSpan(
                text: remainingText,
                style: TextStyle(
                  color: labelColorPrimaryShade.value,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              )
            : TextSpan(
                text: remainingText,
                style: TextStyle(
                  color: labelColorPrimaryShade.value,
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
      );
    }

    return Text.rich(
      TextSpan(children: <TextSpan>[...textSpans]),
    );
  }
}
