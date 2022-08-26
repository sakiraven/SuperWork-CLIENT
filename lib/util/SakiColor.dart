import 'package:flutter/material.dart';

class SakiColor {
  // 微信昵称颜色
  static Color wechatNick = HexColor("#4B6392");

  // 评论主题颜色
  static Color commentTheme = HexColor("#008ACF");

  // 主题绿
  static Color themeGreen = HexColor("#93B88B");

  // 表单颜色
  static Color form = HexColor("#F2F2F7");

  // 气泡
  static Color bubble = HexColor("#F8E6BC");

  // 关卡id
  static Color courseId = HexColor("#6B4B4C");

  // 悬浮按钮颜色
  static Color floatButton = HexColor("#F8E6BC");

  // 主题色
  static Color theme = HexColor("#2E9AA4");
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class SakiThemeColor{
  static const MaterialColor kToDark = const MaterialColor(
    0xff008f98, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0xe6008f98),//10%
      100: const Color(0xcc008f98),//20%
      200: const Color(0xb3008f98),//30%
      300: const Color(0x99008f98),//40%
      400: const Color(0x80008f98),//50%
      500: const Color(0xFFFFFFFF),//60%
      600: const Color(0x4d008f98),//70%
      700: const Color(0x33008f98),//80%
      800: const Color(0x1a008f98),//90%
      900: const Color(0x8f98),//100%
    },
  );
}
