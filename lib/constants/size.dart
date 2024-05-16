import 'package:get/get.dart';

class CIconSize {
  static const medium = 24.0;
}

class CButtonSize {
  static const small = 32.0;

  static const medium = 40.0;

  static const large = 56.0;
}

class CFontSize {
  static const _minimalDefaultWidthOne = 400;
  static const _minimalDefaultWidthTwo = 350;
  static double _isLowerThanDefaultWidth(double font) {
    try {
      if (Get.width > _minimalDefaultWidthTwo &&
          Get.width < _minimalDefaultWidthOne) {
        return font - 1;
      }
      if (Get.width < _minimalDefaultWidthTwo) {
        return font - 2;
      }
      return font;
    } catch (_) {
      return font;
    }
  }

  static double get font9 => _isLowerThanDefaultWidth(9);

  static double get font10 => _isLowerThanDefaultWidth(10);

  static double get font11 => _isLowerThanDefaultWidth(11);

  static double get font11p5 => _isLowerThanDefaultWidth(11.5);

  static double get font12 => _isLowerThanDefaultWidth(12);

  static double get font12p5 => _isLowerThanDefaultWidth(12.5);

  static double get font13 => _isLowerThanDefaultWidth(13);

  static double get font14 => _isLowerThanDefaultWidth(14);

  static double get font14p5 => _isLowerThanDefaultWidth(14.5);

  static double get font15 => _isLowerThanDefaultWidth(15);

  static double get font16 => _isLowerThanDefaultWidth(16);

  static double get font17 => _isLowerThanDefaultWidth(17);

  static double get font18 => _isLowerThanDefaultWidth(18);

  static double get font18p5 => _isLowerThanDefaultWidth(18.5);

  static double get font19 => _isLowerThanDefaultWidth(19);

  static double get font20 => _isLowerThanDefaultWidth(20);

  static double get font21 => _isLowerThanDefaultWidth(21);

  static double get font22 => _isLowerThanDefaultWidth(22);

  static double get font23 => _isLowerThanDefaultWidth(23);

  static double get font24 => _isLowerThanDefaultWidth(24);

  static double get font25 => _isLowerThanDefaultWidth(25);

  static double get font26 => _isLowerThanDefaultWidth(26);

  static double get font27 => _isLowerThanDefaultWidth(27);

  static double get font28 => _isLowerThanDefaultWidth(28);

  static double get font29 => _isLowerThanDefaultWidth(29);

  static double get font30 => _isLowerThanDefaultWidth(30);

  static double get font31 => _isLowerThanDefaultWidth(31);

  static double get font32 => _isLowerThanDefaultWidth(32);

  static double get font33 => _isLowerThanDefaultWidth(33);

  static double get font34 => _isLowerThanDefaultWidth(34);

  static double get font35 => _isLowerThanDefaultWidth(35);

  static double get font36 => _isLowerThanDefaultWidth(36);

  static double get font37 => _isLowerThanDefaultWidth(37);

  static double get font38 => _isLowerThanDefaultWidth(38);

  static double get font39 => _isLowerThanDefaultWidth(39);

  static double get font40 => _isLowerThanDefaultWidth(40);

  static double get font41 => _isLowerThanDefaultWidth(41);
}
