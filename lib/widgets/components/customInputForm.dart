import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../utils/input_formatter.dart';

class CustomInputForm extends StatefulWidget {
  CustomInputForm({
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
    this.textAlign = TextAlign.left,
    this.isUsingSymbol = false,
    this.isWithShadow = false,
    this.isForCard = false,
    this.isCurrency = false,
    this.borderSideWidth = 0.1,
    this.fontWeight = FontWeight.w400,
    this.radius = 6,
  });

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
  final bool isUsingSymbol;
  final TextAlign textAlign;
  final double borderSideWidth;
  final bool isWithShadow;
  final bool isForCard;
  final bool isCurrency;
  final FontWeight fontWeight;
  final double radius;

  @override
  State<CustomInputForm> createState() => _CustomInputFormState();
}

class _CustomInputFormState extends State<CustomInputForm> {
  ThemeController _theme = Get.find(tag: "ThemeController");

  @override
  Widget build(BuildContext context) {
    var inputFormatters = widget.isForCard
        ? [
            LengthLimitingTextInputFormatter(widget.maxInput),
            FilteringTextInputFormatter.digitsOnly,
            CardFormatter(),
          ]
        : widget.isCurrency
            ? [
                LengthLimitingTextInputFormatter(widget.maxInput),
                ThousandsSeparatorInputFormatter(),
              ]
            : [
                LengthLimitingTextInputFormatter(widget.maxInput),
                if (widget.isUsingSymbol)
                  FilteringTextInputFormatter.allow(RegExp('[A-Z0-9]')),
              ];
    return Container(
      height: widget.height,
      width: widget.width,
      child: TextFormField(
        textAlign: widget.textAlign,
        readOnly: widget.readOnly,
        textInputAction: widget.textInputAction,
        controller: widget.textEditingController,
        focusNode: widget.focusNode,
        maxLines: widget.maxLines,
        // style: TextStyle(
        //   color: widget.readOnly
        //       ? _theme.inputFormTextReadonly.value
        //       : _theme.inputFormText.value,
        //   fontSize: 14,
        //   fontFamily: "Gotham",
        // ),
        obscureText: widget.isSecureText,
        keyboardType: widget.keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          fillColor: widget.readOnly
              ? _theme.inputFormBgReadonly.value
              : _theme.inputFormBg.value,
          filled: true,
          hintText: widget.hintText,
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: _theme.textHint.value,
          ),
          errorStyle: TextStyle(height: 0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
            borderSide: BorderSide(
              color: _theme.inputFormBorder.value,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
            borderSide: BorderSide(
              color: widget.readOnly
                  ? _theme.inputFormBorder.value
                  : _theme.inputFormBorderFocused.value,
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
            borderSide: BorderSide(
              color: _theme.inputFormBorderError.value,
              width: 1,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          suffixIcon: widget.readOnly ? null : widget.suffixIcon,
          prefixIcon: widget.readOnly ? null : widget.prefixIcon,
        ),
        textCapitalization: widget.textCapitalization,
        validator: widget.validator ??
            (value) {
              if (value!.length <= 0)
                return widget.errorMessage;
              else
                return null;
            },
        onChanged: widget.onChanged,
      ),
    );
  }
}
