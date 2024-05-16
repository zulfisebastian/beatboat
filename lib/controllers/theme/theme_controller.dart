import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../utils/shared_pref.dart';

class ThemeController extends GetxController {
  Rx<ThemeData> selectedTheme = ThemeData().obs;

  RxString theme = "Dark".obs;

  @override
  void onReady() {
    initTheme();
    selectedTheme.refresh();
    super.onReady();
  }

  initTheme() async {
    var _oldTheme = await SharedPref.getTheme();
    changeTheme(_oldTheme != "" ? _oldTheme : "Light");
  }

  Rx<Color> backgroundApp = Color(0XFFFFFFFF).obs;
  Rx<Color> backgroundCard = Color(0XFFF5F5F5).obs;
  Rx<Color> backgroundAppOther = Color(0XFFEAF8FA).obs;
  Rx<Color> backgroundSuccess = Color(0XFF76c46b).obs;
  Rx<Color> cardGeneral = Color(0XFF58aee8).obs;
  Rx<Color> cardVIP = Color(0XFF70af62).obs;
  Rx<Color> cardVVIP = Color(0XFF302d23).obs;
  Rx<Color> drawer = Color(0XFF0d2b44).obs;
  Rx<Color> drawerProfile = Color(0XFF2b577c).obs;
  Rx<Color> card = Color(0XFF4a50c9).obs;
  Rx<Color> line = Color(0XFFE0E5ED).obs;
  Rx<Color> accent = Color(0XFF0082c9).obs;
  Rx<Color> link = Color(0XFF0082c9).obs;
  Rx<Color> error = Color(0XFFC82820).obs;
  Rx<Color> success = Color(0XFF76c46b).obs;
  Rx<Color> disabled = Color(0XFF999999).obs;

  //Text
  Rx<Color> textTitle = Color(0XFF212121).obs;
  Rx<Color> textSubtitle = Color(0XFF808A82).obs;
  Rx<Color> textHint = Color(0XFFA0AAB8).obs;
  Rx<Color> textLink = Color(0XFF018DC6).obs;
  Rx<Color> textError = Color(0XFFe85358).obs;

  //Button
  Rx<Color> buttonBorderedBorder = Color(0XFFE0E5ED).obs;
  Rx<Color> buttonBorderedText = Color(0XFF212121).obs;
  Rx<Color> buttonBorderedBg = Color(0XFFFFFFFF).obs;

  Rx<Color> buttonWhiteBorder = Color(0XFFD9D9D9).obs;
  Rx<Color> buttonWhiteBorderDisabled = Color(0XFFD9D9D9).obs;
  Rx<Color> buttonWhiteText = Color(0XFF141414).obs;
  Rx<Color> buttonWhiteTextDisabled = Color(0XFFE0E5ED).obs;
  Rx<Color> buttonWhiteBg = Color(0XFFFFFFFF).obs;
  Rx<Color> buttonWhiteBgDisabled = Color(0XFFBABABA).obs;

  Rx<Color> buttonBlackBorder = Color(0XFF141414).obs;
  Rx<Color> buttonBlackBorderDisabled = Color(0XFFD9D9D9).obs;
  Rx<Color> buttonBlackText = Color(0XFFFFFFFF).obs;
  Rx<Color> buttonBlackTextDisabled = Color(0XFFE0E5ED).obs;
  Rx<Color> buttonBlackBg = Color(0XFFF141414).obs;
  Rx<Color> buttonBlackBgDisabled = Color(0XFFBABABA).obs;

  Rx<Color> buttonBlueBorder = Color(0XFF018DC6).obs;
  Rx<Color> buttonBlueBorderDisabled = Color(0XFFBABABA).obs;
  Rx<Color> buttonBlueText = Color(0XFFFFFFFF).obs;
  Rx<Color> buttonBlueTextDisabled = Color(0XFFE0E5ED).obs;
  Rx<Color> buttonBlueBg = Color(0XFF018DC6).obs;
  Rx<Color> buttonBlueBgDisabled = Color(0XFFBABABA).obs;

  Rx<Color> buttonRedBorder = Color(0XFFFDECEC).obs;
  Rx<Color> buttonRedBorderDisabled = Color(0XFFBABABA).obs;
  Rx<Color> buttonRedText = Color(0XFFCB2027).obs;
  Rx<Color> buttonRedTextDisabled = Color(0XFFE0E5ED).obs;
  Rx<Color> buttonRedBg = Color(0XFFFDECEC).obs;
  Rx<Color> buttonRedBgDisabled = Color(0XFFBABABA).obs;

  //InputForm
  Rx<Color> inputFormBorder = Color(0XFFE0E5ED).obs;
  Rx<Color> inputFormBorderError = Color(0XFFEA4848).obs;
  Rx<Color> inputFormBorderFocused = Color(0XFF808A82).obs;
  Rx<Color> inputFormText = Color(0XFF212121).obs;
  Rx<Color> inputFormTextReadonly = Color(0XFF212121).obs;
  Rx<Color> inputFormBg = Color(0XFFFFFFFF).obs;
  Rx<Color> inputFormBgReadonly = Color(0XFFEEEEEE).obs;
  Rx<Color> inputFormIcon = Color(0XFF808A82).obs;

  changeTheme(_newTheme) {
    SharedPref.setTheme(_newTheme);
    theme.value = _newTheme;
    if (theme.value == "Light") {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      );

      backgroundApp.value = Color(0XFFFFFFFF);
      line.value = Color(0XFFE0E5ED);
      accent.value = Color(0XFF53A7EF);
      disabled.value = Color(0XFF999999);

      textTitle.value = Color(0XFF212121);
      textLink.value = Color(0XFF018DC6);

      buttonBorderedBorder.value = Color(0XFFE0E5ED);
      buttonBorderedText.value = Color(0XFF212121);
      buttonBorderedBg.value = Color(0XFFFFFFFF);

      buttonWhiteBorder.value = Color(0XFFD9D9D9);
      buttonWhiteBorderDisabled.value = Color(0XFFD9D9D9);
      buttonWhiteText.value = Color(0XFF141414);
      buttonWhiteTextDisabled.value = Color(0XFFE0E5ED);
      buttonWhiteBg.value = Color(0XFFFFFFFF);
      buttonWhiteBgDisabled.value = Color(0XFFBABABA);

      inputFormBorder.value = Color(0XFFE0E5ED);
      inputFormBorderFocused.value = Color(0XFF808A82);
      inputFormBorderError.value = Color(0XFFEA4848);
      inputFormText.value = Color(0XFF212121);
      inputFormTextReadonly.value = Color(0XFF212121);
      inputFormBg.value = Color(0XFFFFFFFF);
      inputFormBgReadonly.value = Color(0XFFEEEEEE);
      inputFormIcon.value = Color(0XFF808A82);
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Color(0XFF212121),
          statusBarIconBrightness: Brightness.dark,
        ),
      );

      backgroundApp.value = Color(0XFF212121);
      line.value = Color(0XFFCCCCCC);
      accent.value = Color(0XFF54CC58);
      disabled.value = Color(0XFF999999);

      textTitle.value = Color(0XFFFFFFFFF);
      textLink.value = Color(0XFF018DC6);

      buttonBorderedBorder.value = Color(0XFFCCCCCC);
      buttonBorderedText.value = Color(0XFFFFFFFF);
      buttonBorderedBg.value = Color(0XFF212121);

      buttonWhiteBorder.value = Color(0XFFD9D9D9);
      buttonWhiteBorderDisabled.value = Color(0XFFD9D9D9);
      buttonWhiteText.value = Color(0XFF141414);
      buttonWhiteTextDisabled.value = Color(0XFFE0E5ED);
      buttonWhiteBg.value = Color(0XFFFFFFFF);
      buttonWhiteBgDisabled.value = Color(0XFFBABABA);

      inputFormBorder.value = Color(0XFFCCCCCC);
      inputFormBorderFocused.value = Color(0XFF6dad6f);
      inputFormBorderError.value = Color(0XFFEA4848);
      inputFormText.value = Color(0XFFEFEFEF);
      inputFormTextReadonly.value = Color(0XFF212121);
      inputFormBg.value = Color(0XFF212121);
      inputFormBgReadonly.value = Color(0XFFEEEEEE);
      inputFormIcon.value = Color(0XFFEFEFEF);
    }
  }
}
