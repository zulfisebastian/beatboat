import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../utils/input_formatter.dart';

class CustomInputNumber extends StatefulWidget {
  CustomInputNumber({
    required this.textEditingController,
    required this.hintText,
    required this.errorMessage,
    required this.onChanged,
    this.focusNode,
    this.textInputAction,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.height,
    this.width,
    this.readOnly = false,
    this.maxInput = 50,
    this.maxLines,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.center,
    this.borderSideWidth = 0.1,
    this.fontWeight = FontWeight.w400,
    this.radius = 6,
  });

  final TextEditingController textEditingController;
  final FocusNode? focusNode;
  final String hintText;
  final String errorMessage;
  final Function(String) onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  final double? height;
  final double? width;
  final int maxInput;
  final int? maxLines;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final double borderSideWidth;
  final FontWeight fontWeight;
  final double radius;

  @override
  State<CustomInputNumber> createState() => _CustomInputNumberState();
}

class _CustomInputNumberState extends State<CustomInputNumber> {
  ThemeController _theme = Get.find(tag: "ThemeController");

  @override
  Widget build(BuildContext context) {
    var inputFormatters = [
      LengthLimitingTextInputFormatter(widget.maxInput),
      ThousandsSeparatorInputFormatter(),
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
        keyboardType: TextInputType.number,
        inputFormatters: inputFormatters,
        style: TextStyle(
          fontSize: CDimension.space40,
          color: _theme.accent.value,
        ),
        decoration: InputDecoration(
          fillColor: _theme.backgroundAppOther.value,
          filled: true,
          hintText: widget.hintText,
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: _theme.textHint.value,
            fontSize: CFontSize.font20,
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
