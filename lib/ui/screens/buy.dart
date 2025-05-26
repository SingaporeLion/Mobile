import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:solana_flutter/ui/commonWidgets/inputFields.dart';
import 'package:solana_flutter/ui/screens/verifyPassword.dart';

import '../../../constants/colors.dart';
import '../../../controllers/appController.dart';
import 'package:intl/intl.dart';

import '../../models/coinPriceModel.dart';
import '../../utilService/UtilService.dart';
import '../commonWidgets/bottomRectangularbtn.dart';
import '../commonWidgets/commonWidgets.dart';
import 'openLink.dart';

class Buy extends StatefulWidget {
  Buy({super.key});

  @override
  State<Buy> createState() => _BuyState();
}

class _BuyState extends State<Buy> {
  TextEditingController amountController = new TextEditingController();
  var amountErr = ''.obs;
  var loading = false.obs;
  var selectedCoinPrice = '0.0'.obs;
  var totalFee = '0.0'.obs;
  var selectedWalletAddress = ''.obs;
  var coinsToBuy = [
    {
      'name': 'SOL',
      'uri': 'https://logos-world.net/wp-content/uploads/2024/01/Solana-Logo.png',
    },
    {
      'name': 'USDC',
      'uri': 'https://cryptologos.cc/logos/usd-coin-usdc-logo.png',
    }
  ];
  var selectedTokenIndex = 0.obs;

  CoinPriceData coinPriceData = CoinPriceData();
  final appController = Get.find<AppController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedWalletAddress.value = appController.publicKey.value;
    print('WalletAddress ${selectedWalletAddress.value}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor.value,
      body: Obx(
        () => SafeArea(
          child: Container(
            width: Get.width,
            height: Get.height,
            child: ListView(
              //crossAxisAlignment: CrossAxisAlignment.start,
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
                        'Buy',
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  decoration: BoxDecoration(
                    color: primaryBackgroundColor.value,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  constraints: BoxConstraints(minHeight: Get.height - 110, minWidth: Get.width),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            width: Get.width,
                            height: 40,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: 2,
                              itemBuilder: (BuildContext context, int index) {
                                print(appController.tokenList.length);
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedTokenIndex.value = index;
                                      if (amountController.text.trim() != '') {
                                        getCoinPrice();
                                      }
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: selectedTokenIndex.value == index ? Color(0x2670EDEF) : cardcolor.value,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Center(
                                      child: Text(
                                        '${coinsToBuy[index]['name']}',
                                        style: TextStyle(
                                          color: selectedTokenIndex.value == index ? primaryColor.value : labelColorPrimaryShade.value,
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return SizedBox(width: 16);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          InputFields(
                            textController: amountController,
                            headerText: 'Amount in USD',
                            hintText: 'Amount',
                            inputType: TextInputType.number,
                            hasHeader: true,
                            onChange: (value) {
                              amountErr.value = '';
                              selectedCoinPrice.value = value;
                              if (value == '') {
                                selectedCoinPrice.value = '0.0';
                                totalFee.value = '0.0';
                              }
                              setState(() {});
                              if (value != '') {
                                _onChangeHandler();
                              }
                            },
                            //svg: 'walletArrow',
                            suffixIcon: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              child: Text(
                                'USD',
                                style: TextStyle(
                                    fontFamily: 'sfpro', fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 14.0, letterSpacing: 0.37, color: labelColor.value),
                              ),
                            ),
                          ),
                          CommonWidgets.showErrorMessage(amountErr.value),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'By Paying',
                                style: TextStyle(
                                  color: labelColor.value,
                                  fontFamily: 'sfpro',
                                ),
                              ),
                              Expanded(
                                flex: 10,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        amountController.text.isEmpty ? "0.0" : '${amountController.text}',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: labelColor.value,
                                          fontFamily: 'sfpro',
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      height: 30,
                                      width: 30,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: cardcolor.value,
                                        borderRadius: BorderRadius.all(Radius.circular(40)),
                                        //boxShadow: appShadow,
                                      ),
                                      child: Text(
                                        NumberFormat.simpleCurrency(
                                          name: "USD", //currencyCode
                                          decimalDigits: 0,
                                        ).currencySymbol,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: 'sfpro',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Text(
                                'You will Receive',
                                style: TextStyle(
                                  color: labelColor.value,
                                  fontFamily: 'sfpro',
                                ),
                              ),
                              Expanded(
                                flex: 10,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: loading.value
                                          ? Shimmer.fromColors(
                                              baseColor: labelColor.value,
                                              highlightColor: Colors.white,
                                              child: Text(
                                                'Loading...   ',
                                                style: TextStyle(
                                                  color: labelColor.value,
                                                  fontFamily: 'sfpro',
                                                ),
                                              ),
                                            )
                                          : Text(
                                              '${amountController.text == '' ? '0.0' : UtilService().toFixed2DecimalPlaces(selectedCoinPrice.value.toString(), decimalPlaces: 4)} ',
                                              style: TextStyle(
                                                color: labelColor.value,
                                                fontFamily: 'sfpro',
                                              ),
                                            ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    CachedNetworkImage(
                                      imageUrl: selectedTokenIndex.value == 0 ? coinsToBuy[0]['uri']! : coinsToBuy[1]['uri']!,
                                      width: 20,
                                      height: 20,
                                      errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Fee',
                                style: TextStyle(
                                  color: labelColor.value,
                                  fontFamily: 'sfpro',
                                ),
                              ),
                              SizedBox(),
                              loading.value
                                  ? Expanded(
                                      flex: 10,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Shimmer.fromColors(
                                            baseColor: labelColor.value,
                                            highlightColor: Colors.white,
                                            child: Text(
                                              'Loading...   ',
                                              style: TextStyle(
                                                color: labelColor.value,
                                                fontFamily: 'sfpro',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Expanded(
                                      flex: 10,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${UtilService().toFixed2DecimalPlaces(totalFee.value.toString(), decimalPlaces: 4)}',
                                            style: TextStyle(
                                              color: labelColor.value,
                                              fontFamily: 'sfpro',
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Container(
                                            height: 30,
                                            width: 30,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: cardcolor.value,
                                              borderRadius: BorderRadius.all(Radius.circular(40)),
                                              //boxShadow: appShadow,
                                            ),
                                            child: Text(
                                              NumberFormat.simpleCurrency(
                                                name: "USD", //currencyCode
                                                decimalDigits: 0,
                                              ).currencySymbol,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontFamily: 'sfpro',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          BottomRectangularBtn(
                              onTapFunc: () {
                                if (appController.enabledBiometric.value == true) {
                                  Get.to(VerifyPassword(fromPage: 'send'))!.then((value) {
                                    if (value == 'verified') {
                                      onTapBuy();
                                    }
                                  });
                                } else {
                                  onTapBuy();
                                }
                              },
                              btnTitle: 'Buy'),
                          SizedBox(
                            height: 45,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onTapBuy() {
    if (amountController.text.isEmpty) {
      amountErr.value = 'Please enter amount';
    } else {
      var userData = {
        "firstName": '',
        "lastName": '',
        "email": '',
        "mobileNumber": '',
        "dob": "1990-11-26",
      };
      var queryParams = jsonEncode(userData);
      var walletAddress = selectedWalletAddress.value;
      var title = 'Payment';
      var coins = 'USDC,SOL';
      var fiatAmount = amountController.text;
      var faitCurrency = 'USD';
      var cryptoCurrency = selectedTokenIndex.value == 0 ? "SOL" : "USDC";
      var email = '';
      String network = 'solana';

      String url = '${appController.transakBaseUrl}?apiKey=${appController.apiKey}&redirectURL=https://transak.com'
          '&cryptoCurrencyList=$coins&defaultCryptoCurrency=$cryptoCurrency&walletAddress=$walletAddress'
          '&fiatAmount=$fiatAmount&defaultFiatAmount=$fiatAmount&fiatCurrency=$faitCurrency&disableWalletAddressForm=true'
          '&exchangeScreenTitle=$title&isFeeCalculationHidden=true&email=$email&network=$network';
      print(url);
      Get.to(OpenLink(url: url, fromPage: ''), duration: Duration(milliseconds: 300), transition: Transition.rightToLeft);
    }
  }

  void getCoinPrice() async {
    loading.value = true;
    selectedCoinPrice.value = "0.0";
    String faitAmount = amountController.text;
    String fiatCurrency = 'USD';
    String paymentMethod = 'credit_debit_card';
    var cryptoCurrency = selectedTokenIndex.value == 0 ? "SOL" : "USDC";
    String network = 'solana';
    var basrUrl = '${appController.transakUrlForPrice}/';
    var _dio = Dio(BaseOptions(baseUrl: basrUrl, headers: {"Content-Type": "application/json"}));
    var apis =
        '${appController.transakUrlForPrice}?partnerApiKey=${appController.apiKey}&fiatCurrency=USD&cryptoCurrency=$cryptoCurrency&isBuyOrSell=BUY&network=$network&paymentMethod=$paymentMethod&fiatAmount=$faitAmount';
    print('--->$apis');
    var response;
    try {
      response = await _dio.get('$apis');
      print('response data ==>${response.data}');
      coinPriceData = CoinPriceData.fromJson(response.data);
      selectedCoinPrice.value = coinPriceData.response!.cryptoAmount.toString();
      loading.value = false;
      amountErr.value = '';
      amountErr.value = '';
      print('price : ${selectedCoinPrice.value}');
      print('fee : ${coinPriceData.response?.totalFee}');
      totalFee.value = (coinPriceData.response?.totalFee).toString();
      setState(() {});
    } on DioError catch (e) {
      if (e.response != null) {}
      response = e.response;
      loading.value = false;
      amountErr.value = '${e.response?.data['error']['message']}';
    }
    // print('$api' + ' Status_Code: ${response!.statusCode}');
  }

  late Timer searchOnStoppedTyping = new Timer(Duration(milliseconds: 1), () {});

  _onChangeHandler() {
    loading.value = true;
    const duration = Duration(milliseconds: 1000); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping.cancel()); // clear timer
    }
    setState(() => searchOnStoppedTyping = new Timer(duration, () {
          if (amountController.text != '') {
            getCoinPrice();
          } else {
            loading.value = false;
          }
        }));
  }
}
