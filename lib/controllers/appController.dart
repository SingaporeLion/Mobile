import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solana_flutter/models/nftModel.dart';
import 'package:solana_flutter/models/transactionsModel.dart';
import 'package:solana_flutter/utilService/dataService.dart';

import '../constants/colors.dart';
import '../models/newNftModel.dart';
import '../models/tokenModel.dart';

class AppController extends GetxController {
  String transakBaseUrl = 'https://global.transak.com';
  String transakUrlForPrice = 'https://api.transak.com/api/v2/currencies/price';
  String apiKey = 'YOUR-TRANSAK-APIKEY-HERE';
  var publicKey = "".obs;
  var bottomNavIndex = 0.obs;
  var accountSolBalance = 0.0.obs;
  var transactions = <SolanaNotificationModel>[].obs;
  var tokenTransactions = <SolanaNotificationModel>[].obs;
  var getTokenTransactionsLoader = false.obs;
  var nftData = NftModel().obs;
  var getNFTLoader = false.obs;
  var getTokensLoader = false.obs;
  var getTransactionsLoader = false.obs;
  var showBalance = true.obs;
  var enabledBiometric = false.obs;
  // String rpcUrl = 'https://api.devnet.solana.com';
  // String wssUrl = 'wss://api.devnet.solana.com';
  String rpcUrl = 'https://api.mainnet-beta.solana.com';
  String wssUrl = 'wss://api.mainnet-beta.solana.com';
  var platformFeeAddress = ''.obs;
  //var platformFee = 0.obs;
  var loadingPrice = false.obs;

  RxnNum platformFee = RxnNum(0);
  var tokenList = <Token>[].obs;
  List<String> splTokenList = [];
  var tokenNameCache = <String, String>{}.obs;
  var solTransactions = <SolanaNotificationModel>[].obs;
  var saveImageToGalleryLoader = false.obs;
  var newNftDataList = <NewNftModel>[].obs;
  RxnNum walletBalanceInUsd = RxnNum(0);

  var savedTokens = [
    {
      "decimals": 6,
      "balance": 0.0,
      "name": "USDT",
      "uri":
      "https://w7.pngwing.com/pngs/520/303/png-transparent-tether-united-states-dollar-cryptocurrency-fiat-money-market-capitalization-bitcoin-logo-bitcoin-trade-thumbnail.png",
      "symbol": "USDT",
      "tokenAddress": "Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB",
      "coinGeckoID": "tether",
      "balanceInUSD": 0
    },
    {
      "decimals": 6,
      "balance": 0.0,
      "name": "USDC",
      "uri": "https://cryptologos.cc/logos/usd-coin-usdc-logo.png",
      "symbol": "USDC",
      "tokenAddress": "EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v",
      "coinGeckoID": "usd-coin",
      "balanceInUSD": 0
    },
    {
      "decimals": 6,
      "balance": 0.0,
      "name": "RAY",
      "uri": "https://s1.coincarp.com/logo/1/raydium.png",
      "symbol": "RAY",
      "tokenAddress": "4k3Dyjzvzp8eMZWUXbBCjEvwSkkk59S5iCNLY3QrkX6R",
      "coinGeckoID": "raydium",
      "balanceInUSD": 0
    },
    {
      "decimals": 6,
      "balance": 0.0,
      "name": "LINK",
      "uri": "https://s2.coinmarketcap.com/static/img/coins/64x64/1975.png",
      "symbol": "LINK",
      "tokenAddress": "CWE8jPTUYhdCTZYWPTe1o5DFqfdjzWKc9WKz6rSjQUdG",
      "coinGeckoID": "chainlink",
      "balanceInUSD": 0
    },
    {
      "decimals": 6,
      "balance": 0.0,
      "name": "dogwifhat",
      "uri": "https://cdn.coinranking.com/lmn49VWrx/dogwifhat.PNG?size=68x68",
      "symbol": "WIF",
      "tokenAddress": "EKpQGSJtjMFqKZ9KQanSqYXRcF8fBopzLHYxdM65zcjm",
      "coinGeckoID": "dogwifcoin",
      "balanceInUSD": 0
    },
    {
      "decimals": 6,
      "balance": 0.0,
      "name": "Jupiter",
      "uri": "https://cdn.coinranking.com/ss1JeYZ8t/JUP.PNG?size=68x68",
      "symbol": "JUP",
      "tokenAddress": "JUPyiwrYJFskUPiHa7hkeR8VUtAeFoSYbKedZNsDvCN",
      "coinGeckoID": "jupiter-exchange-solana",
      "balanceInUSD": 0
    },
    {
      "decimals": 8,
      "balance": 0.0,
      "name": "Lido DAO",
      "uri": "https://cdn.coinranking.com/Wp6LFY6ZZ/8000.png?size=68x68",
      "symbol": "LDO",
      "tokenAddress": "HZRCwxP2Vq9PCpPXooayhJ2bxTpo5xfpQrwB1svh332p",
      "coinGeckoID": "lido-dao",
      "balanceInUSD": 0
    },
    {
      "decimals": 5,
      "balance": 0.0,
      "name": "Bonk",
      "uri": "https://cdn.coinranking.com/8YnJOyn2H/bonk.png?size=68x68",
      "symbol": "BONK",
      "tokenAddress": "DezXAZ8z7PnrnRJjz3wXBoRgixCa6xjnB7YaB1pPB263",
      "coinGeckoID": "bonk",
      "balanceInUSD": 0
    },
    {
      "decimals": 8,
      "balance": 0.0,
      "name": "The Sandbox",
      "uri": "https://cdn.coinranking.com/kd_vwOcnI/sandbox.png?size=68x68",
      "symbol": "SAND",
      "tokenAddress": "49c7WuCZkQgc3M4qH8WuEUNXfgwupZf1xqWkDQ7gjRGt",
      "coinGeckoID": "the-sandbox",
      "balanceInUSD": 0
    },
    {
      "decimals": 8,
      "balance": 0.0,
      "name": "Frax",
      "uri": "https://cdn.coinranking.com/BpVNCX-NM/frax.png?size=68x68",
      "symbol": "FRAX",
      "tokenAddress": "FR87nWEUxVgerFGhZM8Y4AggKGLnaXswr1Pd8wZ4kZcp",
      "coinGeckoID": "frax",
      "balanceInUSD": 0
    },
  ];
}
