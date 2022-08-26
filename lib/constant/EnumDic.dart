enum EnumDic { newWork, jieWork, hotWork }
extension EnumDicExtension on EnumDic {
  String get code {
    switch (this) {
      case EnumDic.newWork:
        return "newWork";
      case EnumDic.jieWork:
        return "jieWork";
      case EnumDic.hotWork:
        return "hotWork";
    }
  }

  String get name {
    switch (this) {
      case EnumDic.newWork:
        return "最新";
      case EnumDic.jieWork:
        return "桀评";
      case EnumDic.hotWork:
        return "最热";
    }
  }

}