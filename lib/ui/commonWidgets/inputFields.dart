import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controllers/appController.dart';
import '../../constants/colors.dart';

class InputFields extends StatelessWidget {
  final appController = Get.find<AppController>();
  final String headerText;
  final String hintText;
  final bool hasHeader;
  final bool? isPass;
  final int? maxLines;
  final TextEditingController? textController;
  final bool? isEditable;
  final Widget? suffixIcon;
  final Widget? prefix;
  final Function? onChange;
  final TextInputType? inputType;

  InputFields(
      {Key? key,
      this.maxLines,
      required this.headerText,
      required this.hintText,
      required this.hasHeader,
      this.textController,
      this.isEditable,
      this.isPass,
      this.suffixIcon,
      this.prefix,
      this.inputType,
      required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (hasHeader == true)
          Container(
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$headerText',
                  style: TextStyle(
                    color: labelColorPrimaryShade.value,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 8,
                )
              ],
            ),
          ),
        TextFormField(
          cursorColor: primaryColor.value,
          cursorHeight: 25,
          maxLines: maxLines,
          obscureText: isPass == true ? true : false,
          controller: textController,
          enabled: isEditable,
          keyboardType: inputType ?? TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 23),
              hintStyle: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'metropolis',
                  color: labelColorPrimaryShade.value),
              filled: true,
              fillColor: cardcolor.value,
              hintText: hintText,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              prefix: prefix,
              suffixIcon: suffixIcon != null ? suffixIcon : SizedBox()),
          onChanged: (value) {
            onChange!.call(value);
          },
        ),
      ],
    );
  }
}

class InputFieldPassword extends StatefulWidget {
  final String headerText;
  final String hintText;
  final TextEditingController? textController;
  final bool? isEditable;
  final Function onChange;
  final String? svg;

  InputFieldPassword({
    Key? key,
    required this.headerText,
    required this.hintText,
    required this.textController,
    required this.onChange,
    this.isEditable,
    this.svg,
  }) : super(key: key);

  @override
  State<InputFieldPassword> createState() => _InputFieldPasswordState();
}

class _InputFieldPasswordState extends State<InputFieldPassword> {
  bool _visible = true;
  final appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: primaryColor.value,
      cursorHeight: 18,
      enabled: widget.isEditable,
      onChanged: (val) {
        widget.onChange.call(val);
      },
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
      ),
      controller: widget.textController,
      obscureText: _visible,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 23),
          hintText: widget.hintText,
          hintStyle: TextStyle(
              fontSize: 18.0,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              fontFamily: 'metropolis',
              color: labelColorPrimaryShade.value),
          filled: true,
          //<-- SEE HERE
          fillColor: cardcolor.value,
          //focusColor: activeInputColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8),
          ),
          suffixIcon: IconButton(
              icon: Icon(!_visible ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.white),
              onPressed: () {
                setState(() {
                  _visible = !_visible;
                });
              })),
    );
  }
}

RegExp lowerCase = new RegExp(r"(?=.*[a-z])\w+");
RegExp upperCase = new RegExp(r"(?=.*[A-Z])\w+");
RegExp containsNumber = new RegExp(r"(?=.*?[0-9])");
RegExp hasSpecialCharacters = new RegExp(r"[ !@#$%^&*()_+\-=\[\]{};':" "\\|,.<>\/?]");
