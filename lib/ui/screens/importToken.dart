import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../../controllers/appController.dart';
import '../commonWidgets/bottomRectangularbtn.dart';
import '../commonWidgets/commonWidgets.dart';
import '../commonWidgets/inputFields.dart';

class ImportToken extends StatefulWidget {
  ImportToken({super.key});

  @override
  State<ImportToken> createState() => _ImportTokenState();
}

class _ImportTokenState extends State<ImportToken> {
  final appController = Get.find<AppController>();
  TextEditingController addressController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController symbolController = new TextEditingController();
  TextEditingController imageController = new TextEditingController();
  TextEditingController decimalController = new TextEditingController();
  TextEditingController coinGeckoController = new TextEditingController();
  var nameErr = ''.obs;
  var addressErr = ''.obs;
  var symbolErr = ''.obs;
  var imageErr = ''.obs;
  var decimalErr = ''.obs;
  var coinGeckoErr = ''.obs;
  var importLoader = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        //resizeToAvoidBottomInset: false,
        backgroundColor: primaryBackgroundColor.value,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 24,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
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
                            'Import SPL Token',
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
                            width: 24,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    InputFields(
                        headerText: "Contract Address",
                        hintText: "",
                        hasHeader: true,
                        textController: addressController,
                        onChange: (v) {
                          addressErr.value = '';
                        }),
                    CommonWidgets.showErrorMessage(addressErr.value),
                    InputFields(
                      headerText: "Token Name",
                      hintText: "",
                      textController: nameController,
                      onChange: (value) {
                        if (value != null && value != '') {
                          nameErr.value = '';
                        }
                      },
                      hasHeader: true,
                    ),
                    CommonWidgets.showErrorMessage(nameErr.value),
                    InputFields(
                      headerText: "Token Symbol",
                      hintText: "",
                      textController: symbolController,
                      onChange: (value) {
                        if (value != null && value != '') {
                          symbolErr.value = '';
                        }
                      },
                      hasHeader: true,
                    ),
                    CommonWidgets.showErrorMessage(symbolErr.value),
                    InputFields(
                      headerText: "Token Image Url",
                      hintText: "",
                      textController: imageController,
                      onChange: (value) {
                        if (value != null && value != '') {
                          imageErr.value = '';
                        }
                      },
                      hasHeader: true,
                    ),
                    CommonWidgets.showErrorMessage(imageErr.value),
                    InputFields(
                      headerText: "Token Decimals",
                      inputType: TextInputType.number,
                      hintText: "",
                      textController: decimalController,
                      onChange: (value) {
                        if (value != null && value != '') {
                          decimalErr.value = '';
                        }
                      },
                      hasHeader: true,
                    ),
                    CommonWidgets.showErrorMessage(decimalErr.value),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      height: 48,
                      child: BottomRectangularBtn(
                          color: primaryColor.value,
                          buttonTextColor: textDarkColor.value,
                          onTapFunc: () {
                            verify();
                          },
                          isLoading: importLoader.value,
                          loadingText: 'Processing...',
                          btnTitle: 'Import'),
                    ),
                    SizedBox(
                      height: 32,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  verify() async {
    if (addressController.text.trim() == '') {
      addressErr.value = 'Please add token address';
    } else if (nameController.text.trim() == '') {
      nameErr.value = 'Please enter token name';
    } else if (symbolController.text.trim() == '') {
      symbolErr.value = 'Please enter token symbol';
    } else if (imageController.text.trim() == '') {
      imageErr.value = 'Please enter token image url';
    } else if (decimalController.text.trim() == '') {
      decimalErr.value = 'Please enter token decimal';
    } /* else if (coinGeckoController.text.trim() == '') {
      coinGeckoErr.value = 'Please enter Coingecko token API ID';
    }*/
    else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, Object> data = {
        "decimals": num.parse(decimalController.text),
        "balance": 0.0,
        "name": "${nameController.text}",
        "uri": "${imageController.text}",
        "symbol": "${symbolController.text}",
        "tokenAddress": "${addressController.text}"
      };
      appController.savedTokens.add(data);
      final userEncode = jsonEncode(appController.savedTokens);
      await prefs.setString('savedSplTokens', userEncode);
      Get.back(result: 'added');
    }
  }
}
