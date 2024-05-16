import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/theme/theme_controller.dart';

// ignore: must_be_immutable
class CustomInputArea extends StatelessWidget {
  final TextEditingController textEditingController;
  final FocusNode? focusNode;
  final String hintText;
  final String errorMessage;
  final Function(String) onChanged;
  final bool isSecureText;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  final double? height;
  final double? width;
  final TextInputType keyboardType;
  final int maxInput;
  final int? maxLines;
  final TextCapitalization textCapitalization;
  List<TextInputFormatter>? inputFormatters;
  final bool isUsingSymbol;
  final TextAlign textAlign;
  final double borderSideWidth;
  final bool isWithShadow;
  final FontWeight fontWeight;
  final double radius;

  CustomInputArea({
    required this.textEditingController,
    required this.hintText,
    required this.errorMessage,
    required this.onChanged,
    this.focusNode,
    this.isSecureText = false,
    this.textInputAction,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.height,
    this.width,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.maxInput = 50,
    this.maxLines,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.textAlign = TextAlign.left,
    this.isUsingSymbol = false,
    this.isWithShadow = false,
    this.borderSideWidth = 0.1,
    this.fontWeight = FontWeight.w400,
    this.radius = 6,
  });

  ThemeController _theme = Get.find(tag: "ThemeController");

  @override
  Widget build(BuildContext context) {
    inputFormatters = [
      LengthLimitingTextInputFormatter(maxInput),
      if (isUsingSymbol) FilteringTextInputFormatter.allow(RegExp('[A-Z0-9]')),
    ];
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        border: Border.all(
          color: _theme.line.value,
          width: 1,
        ),
      ),
      padding: EdgeInsets.only(
        left: 4,
        top: 4,
        right: 0,
        bottom: 10,
      ),
      child: TextFormField(
        textAlign: textAlign,
        readOnly: readOnly,
        textInputAction: textInputAction,
        controller: textEditingController,
        focusNode: focusNode,
        maxLength: maxInput,
        maxLines: maxLines,
        minLines: 4,
        style: GoogleFonts.inter(
          color: readOnly
              ? _theme.inputFormTextReadonly.value
              : _theme.inputFormText.value,
          fontSize: 14,
          fontWeight: fontWeight,
        ),
        obscureText: isSecureText,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          fillColor: readOnly
              ? _theme.inputFormBgReadonly.value
              : _theme.inputFormBg.value,
          filled: true,
          hintText: hintText,
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: _theme.textHint.value,
          ),
          errorStyle: TextStyle(height: 0),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          suffixIcon: readOnly ? null : suffixIcon,
          prefixIcon: readOnly ? null : prefixIcon,
        ),
        textCapitalization: textCapitalization,
        buildCounter: (_,
                {required currentLength, maxLength, required isFocused}) =>
            Container(
          alignment: Alignment.centerRight,
          child: Text(
            currentLength.toString() + "/" + maxLength.toString(),
            style: TextStyle(
              color: _theme.textHint.value,
            ),
          ),
        ),
        validator: validator ??
            (value) {
              if (value!.length <= 0)
                return errorMessage;
              else
                return null;
            },
        onChanged: onChanged,
      ),
    );
  }
}
