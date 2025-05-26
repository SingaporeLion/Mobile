import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:solana/solana.dart';

import '../anchorTypes/ata_data.dart';
import '../anchorTypes/token_data.dart';
import '../controllers/appController.dart';
import 'package:get/get.dart' as getx;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:solana/dto.dart';
import 'package:solana/metaplex.dart';
import 'package:solana/solana.dart' as solana;
//import 'package:solana_common/utils/buffer.dart' as solana_buffer;
import 'package:solana_buffer/buffer.dart' as solana_buffer;

import '../models/tokenModel.dart';

class DataService {
  String authToken = '';
  var response;
  final appController = getx.Get.find<AppController>();

  Future<Response?> genericDioPostCall(String api, {var data}) async {
    var _dio = Dio(BaseOptions(baseUrl: api, headers: {"Authorization": "${authToken}", "Content-Type": "application/json"}));
    var response;
    print('$api' + ' data: ${data}');
    try {
      response = await _dio.post(api, data: data);
    } on DioError catch (e) {
      print("e.type ${e.response!.statusCode}");
      response = e.response;
    }
    print('$api' + ' Status_Code: ${response.statusCode}');
    return response;
  }

  Future<Response?> genericDioGetCall(String api) async {
    print('$api');
    var _dio = Dio(BaseOptions(baseUrl: api, headers: {"Authorization": "$authToken", "Content-Type": "application/json"}));
    var _response;
    try {
      _response = await _dio.get('$api');
    } on DioError catch (e) {
      print("e.type ${e.response!.statusCode}");
      print("e.response ${e.response}");
      response = e.response;
      return null;
    }
    print('$api' + ' Status_Code: ${response}');
    return _response;
  }

  Future<List<Token>> fetch_tokens(solana.SolanaClient? client, String? pubkey) async {
    print("fetching tokens");
    List<Token> tokenList = [];
    // if (client == null || pubkey == null) {
    //   return tokenList;
    // }
    print(pubkey);
    final ataList = await SolanaClient(
      rpcUrl: Uri.parse(appController.rpcUrl),
      websocketUrl: Uri.parse(appController.wssUrl),
    )!
        .rpcClient
        .getTokenAccountsByOwner(
          pubkey!,
          TokenAccountsFilter.byProgramId(solana.TokenProgram.programId),
          encoding: Encoding.base64,
          commitment: Commitment.confirmed,
        )
        .value;
    ProgramAccount pr;

    for (var ata in ataList) {
      final ataBytes = ata.account.data as BinaryAccountData;
      final ataData = AtaData.fromBorsh(ataBytes.data as Uint8List);
      final mintInfo = await SolanaClient(
        rpcUrl: Uri.parse(appController.rpcUrl),
        websocketUrl: Uri.parse(appController.wssUrl),
      )
          .rpcClient
          .getAccountInfo(
            ataData.mint.toString(),
            commitment: Commitment.confirmed,
            encoding: Encoding.base64,
          )
          .value;
      print("mintInfo $mintInfo");
      print("mintInfo ${mintInfo?.data?.toJson()}");
      final mintBytes = mintInfo?.data as BinaryAccountData;
      final mintData = TokenData.fromBorsh(mintBytes.data as Uint8List);
      if (mintData.decimals > 0) {
        Token token = Token();
        final balance = await SolanaClient(
          rpcUrl: Uri.parse(appController.rpcUrl),
          websocketUrl: Uri.parse(appController.wssUrl),
        ).rpcClient.getTokenAccountBalance(ata.pubkey).value;
        print("balance tok = ${balance}");
        print("balance tok = ${balance.toJson()}");

        token.balance = double.tryParse(balance.uiAmountString!);
        token.decimals = mintData.decimals;
        token.tokenAddress = ataData.mint.toString();
        if (appController.tokenList.indexWhere((element) => element.tokenAddress == token.tokenAddress) >= 0) {
          int index = appController.tokenList.indexWhere((element) => element.tokenAddress == token.tokenAddress);
          appController.tokenList[index].balance = token.balance;
          appController.tokenList[index].decimals = token.decimals;
        }
        // ///kiki
        // if(token.tokenAddress == 'GpQ4rNAVg1rNRzQmkQK5PxziJL4XyGPS4gfN268eJb9z'){
        //   int index = appController.tokenList.indexWhere((element) =>
        //   element.tokenAddress == 'GpQ4rNAVg1rNRzQmkQK5PxziJL4XyGPS4gfN268eJb9z');
        //   appController.tokenList[index].balance = token.balance;
        // }
        print("balance tok = ${token.toJson()}");
        //if (token.balance! > 0) {
        const metaplexProgramId = 'metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s';
        final metaplexProgramIdPublicKey = solana.Ed25519HDPublicKey.fromBase58(metaplexProgramId);
        final metadataPda = await solana.Ed25519HDPublicKey.findProgramAddress(
          seeds: [
            solana_buffer.Buffer.fromString("metadata"),
            metaplexProgramIdPublicKey.bytes,
            ataData.mint.bytes,
          ],
          programId: metaplexProgramIdPublicKey,
        );
        final metadataPdaInfo = await SolanaClient(
          rpcUrl: Uri.parse(appController.rpcUrl),
          websocketUrl: Uri.parse(appController.wssUrl),
        )
            .rpcClient
            .getAccountInfo(
              metadataPda.toString(),
              commitment: Commitment.confirmed,
              encoding: Encoding.base64,
            )
            .value;
        print("metadataPdaInfo $metadataPdaInfo");
        print("metadataPdaInfo2 ${metadataPdaInfo?.toJson()}");
        if (metadataPdaInfo != null) {
          final metadataPdaBytes = metadataPdaInfo.data as BinaryAccountData;

          final metadata = Metadata.fromBinary(metadataPdaBytes.data as Uint8List);
          token.name = metadata.name;
          token.symbol = metadata.symbol;
          if (metadata.uri != null && metadata.uri != '') {
            var response = await http.get(Uri.parse(metadata.uri));
            var jsonData = jsonDecode(response.body);
            token.uri = jsonData['image'];
          }
          if (appController.tokenList.indexWhere((element) => element.tokenAddress == token.tokenAddress) >= 0) {
            int index = appController.tokenList.indexWhere((element) => element.tokenAddress == token.tokenAddress);
            appController.tokenList[index].balance = token.balance;
            appController.tokenList[index].name = token.name;
            appController.tokenList[index].symbol = token.symbol;
            appController.tokenList[index].decimals = token.decimals;
            if (metadata.uri != null && metadata.uri != '') {
              var response = await http.get(Uri.parse(metadata.uri));
              var jsonData = jsonDecode(response.body);
              appController.tokenList[index].uri = jsonData['image'];
            }
          } else {
            tokenList.add(token);
          }
          //}
        }
      }
    }

    return tokenList;
  }

  Future<Map<String, dynamic>?> fetchPlatformData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('platformData')
          .doc('platformData')
          .get();
      if (documentSnapshot.exists) {
        return documentSnapshot.data() as Map<String, dynamic>;
      } else {
        print("Document does not exist");
        return null;
      }
    } catch (e) {
      print("Error fetching document: $e");
      return null;
    }
  }
}
