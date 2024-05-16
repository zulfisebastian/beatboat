import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/theme/theme_controller.dart';
import 'text/ctext_button.dart';

class CustomButtonWhite extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;
  final bool disabled;
  final double? fontSize;
  final double? width;
  final double radius;
  final FontWeight fontWeight;
  final Widget icon;
  final Widget rightIcon;

  CustomButtonWhite(
    this.title, {
    required this.onPressed,
    this.disabled = false,
    this.fontSize,
    this.fontWeight = FontWeight.w700,
    this.width,
    this.radius = 6,
    this.icon = const SizedBox(),
    this.rightIcon = const SizedBox(),
  });

  @override
  State<CustomButtonWhite> createState() => _CustomButtonWhiteState();
}

class _CustomButtonWhiteState extends State<CustomButtonWhite> {
  ThemeController _ctrl = Get.find(tag: "ThemeController");

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: 50,
      child: AbsorbPointer(
        absorbing: widget.disabled,
        child: Obx(
          () => TextButton(
            onPressed: widget.onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.icon,
                Center(
                  child: Obx(
                    () => CTextButton(
                      widget.title,
                      color: !widget.disabled
                          ? _ctrl.buttonWhiteText.value
                          : _ctrl.buttonWhiteTextDisabled.value,
                      fontWeight: FontWeight.bold,
                      align: TextAlign.end,
                    ),
                  ),
                ),
                widget.rightIcon,
              ],
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.radius),
                ),
              ),
              side: MaterialStateProperty.all<BorderSide>(
                BorderSide(
                  color: !widget.disabled
                      ? _ctrl.buttonWhiteBorder.value
                      : _ctrl.buttonWhiteBorderDisabled.value,
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                !widget.disabled
                    ? _ctrl.buttonWhiteBg.value
                    : _ctrl.buttonWhiteBgDisabled.value,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButtonBlack extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;
  final bool disabled;
  final double? fontSize;
  final double paddingVertical;
  final double paddingHorizontal;
  final double? width;
  final double radius;
  final FontWeight fontWeight;
  final Widget icon;
  final Widget rightIcon;

  CustomButtonBlack(
    this.title, {
    required this.onPressed,
    this.disabled = false,
    this.fontSize,
    this.paddingVertical = 12,
    this.paddingHorizontal = 16,
    this.fontWeight = FontWeight.w700,
    this.width,
    this.radius = 6,
    this.icon = const SizedBox(),
    this.rightIcon = const SizedBox(),
  });

  @override
  State<CustomButtonBlack> createState() => _CustomButtonBlackState();
}

class _CustomButtonBlackState extends State<CustomButtonBlack> {
  ThemeController _ctrl = Get.find(tag: "ThemeController");

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: AbsorbPointer(
        absorbing: widget.disabled,
        child: Obx(
          () => TextButton(
            onPressed: widget.onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.icon,
                Obx(
                  () => CTextButton(
                    widget.title,
                    color: !widget.disabled
                        ? _ctrl.buttonBlackText.value
                        : _ctrl.buttonBlackTextDisabled.value,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                widget.rightIcon,
              ],
            ),
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(
                  horizontal: widget.paddingHorizontal,
                  vertical: widget.paddingVertical,
                ),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.radius),
                ),
              ),
              side: MaterialStateProperty.all<BorderSide>(
                BorderSide(
                  color: !widget.disabled
                      ? _ctrl.buttonBlackBorder.value
                      : _ctrl.buttonBlackBorderDisabled.value,
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                !widget.disabled
                    ? _ctrl.buttonBlackBg.value
                    : _ctrl.buttonBlackBgDisabled.value,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButtonBlue extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;
  final bool disabled;
  final double? fontSize;
  final double paddingVertical;
  final double paddingHorizontal;
  final double? width;
  final double radius;
  final FontWeight fontWeight;
  final Widget icon;
  final Widget rightIcon;

  CustomButtonBlue(
    this.title, {
    required this.onPressed,
    this.disabled = false,
    this.fontSize,
    this.paddingVertical = 12,
    this.paddingHorizontal = 16,
    this.fontWeight = FontWeight.w700,
    this.width,
    this.radius = 6,
    this.icon = const SizedBox(),
    this.rightIcon = const SizedBox(),
  });

  @override
  State<CustomButtonBlue> createState() => _CustomButtonBlueState();
}

class _CustomButtonBlueState extends State<CustomButtonBlue> {
  ThemeController _ctrl = Get.find(tag: "ThemeController");

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: AbsorbPointer(
        absorbing: widget.disabled,
        child: Obx(
          () => TextButton(
            onPressed: widget.onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.icon,
                Obx(
                  () => CTextButton(
                    widget.title,
                    color: !widget.disabled
                        ? _ctrl.buttonBlueText.value
                        : _ctrl.buttonBlueTextDisabled.value,
                    fontSize: widget.fontSize ?? 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                widget.rightIcon,
              ],
            ),
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(
                  horizontal: widget.paddingHorizontal,
                  vertical: widget.paddingVertical,
                ),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.radius),
                ),
              ),
              side: MaterialStateProperty.all<BorderSide>(
                BorderSide(
                  color: !widget.disabled
                      ? _ctrl.buttonBlueBorder.value
                      : _ctrl.buttonBlueBorderDisabled.value,
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                !widget.disabled
                    ? _ctrl.buttonBlueBg.value
                    : _ctrl.buttonBlueBgDisabled.value,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButtonRed extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;
  final bool disabled;
  final double? fontSize;
  final double paddingVertical;
  final double paddingHorizontal;
  final double? width;
  final double radius;
  final FontWeight fontWeight;
  final Widget icon;
  final Widget rightIcon;

  CustomButtonRed(
    this.title, {
    required this.onPressed,
    this.disabled = false,
    this.fontSize,
    this.paddingVertical = 12,
    this.paddingHorizontal = 16,
    this.fontWeight = FontWeight.w700,
    this.width,
    this.radius = 6,
    this.icon = const SizedBox(),
    this.rightIcon = const SizedBox(),
  });

  @override
  State<CustomButtonRed> createState() => _CustomButtonRedState();
}

class _CustomButtonRedState extends State<CustomButtonRed> {
  ThemeController _ctrl = Get.find(tag: "ThemeController");

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: AbsorbPointer(
        absorbing: widget.disabled,
        child: Obx(
          () => TextButton(
            onPressed: widget.onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.icon,
                Obx(
                  () => CTextButton(
                    widget.title,
                    color: !widget.disabled
                        ? _ctrl.buttonRedText.value
                        : _ctrl.buttonRedTextDisabled.value,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                widget.rightIcon,
              ],
            ),
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(
                  horizontal: widget.paddingHorizontal,
                  vertical: widget.paddingVertical,
                ),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.radius),
                ),
              ),
              side: MaterialStateProperty.all<BorderSide>(
                BorderSide(
                  color: !widget.disabled
                      ? _ctrl.buttonRedBorder.value
                      : _ctrl.buttonRedBorderDisabled.value,
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                !widget.disabled
                    ? _ctrl.buttonRedBg.value
                    : _ctrl.buttonRedBgDisabled.value,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButtonUntheme extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool disabled;
  final double? fontSize;
  final double paddingVertical;
  final double paddingHorizontal;
  final Color? defaultColor;
  final Color? textColor;
  final Color borderColor;
  final double? width;
  final double radius;
  final FontWeight fontWeight;
  final Widget icon;
  final Widget rightIcon;

  CustomButtonUntheme(
    this.title, {
    required this.onPressed,
    this.disabled = false,
    this.fontSize,
    this.paddingVertical = 12,
    this.paddingHorizontal = 16,
    this.defaultColor,
    this.textColor,
    this.borderColor = Colors.transparent,
    this.fontWeight = FontWeight.w700,
    this.width,
    this.radius = 6,
    this.icon = const SizedBox(),
    this.rightIcon = const SizedBox(),
  });

  final ThemeController _ctrl = Get.find(tag: "ThemeController");

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: AbsorbPointer(
        absorbing: disabled,
        child: TextButton(
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              CTextButton(
                title,
                color: !disabled
                    ? _ctrl.buttonWhiteText.value
                    : _ctrl.buttonWhiteTextDisabled.value,
                fontWeight: FontWeight.bold,
              ),
              rightIcon,
            ],
          ),
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(
                horizontal: paddingHorizontal,
                vertical: paddingVertical,
              ),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
            side: MaterialStateProperty.all<BorderSide>(
                BorderSide(color: borderColor)),
            backgroundColor: MaterialStateProperty.all<Color>(
              !disabled
                  ? defaultColor ?? _ctrl.backgroundApp.value
                  : _ctrl.disabled.value,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButtonBorderWhite extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool disabled;
  final double? fontSize;
  final double paddingVertical;
  final double paddingHorizontal;
  final double? width;
  final double radius;
  final FontWeight fontWeight;
  final Widget icon;
  final Widget rightIcon;

  CustomButtonBorderWhite(
    this.title, {
    required this.onPressed,
    this.disabled = false,
    this.fontSize,
    this.paddingVertical = 12,
    this.paddingHorizontal = 16,
    this.fontWeight = FontWeight.w700,
    this.width,
    this.radius = 6,
    this.icon = const SizedBox(),
    this.rightIcon = const SizedBox(),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: AbsorbPointer(
        absorbing: disabled,
        child: TextButton(
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              CTextButton(
                title,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              rightIcon,
            ],
          ),
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(
                horizontal: paddingHorizontal,
                vertical: paddingVertical,
              ),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
            side: MaterialStateProperty.all<BorderSide>(
              BorderSide(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButtonBorderBlack extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool disabled;
  final double? fontSize;
  final double paddingVertical;
  final double paddingHorizontal;
  final double? width;
  final double radius;
  final FontWeight fontWeight;
  final Widget icon;
  final Widget rightIcon;

  CustomButtonBorderBlack(
    this.title, {
    required this.onPressed,
    this.disabled = false,
    this.fontSize,
    this.paddingVertical = 12,
    this.paddingHorizontal = 16,
    this.fontWeight = FontWeight.w700,
    this.width,
    this.radius = 6,
    this.icon = const SizedBox(),
    this.rightIcon = const SizedBox(),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: AbsorbPointer(
        absorbing: disabled,
        child: TextButton(
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              CTextButton(
                title,
                color: !disabled ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
              rightIcon,
            ],
          ),
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(
                horizontal: paddingHorizontal,
                vertical: paddingVertical,
              ),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
            side: MaterialStateProperty.all<BorderSide>(
              BorderSide(
                color: Colors.black12,
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
              !disabled ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
