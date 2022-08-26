enum MyEnumOrder { LIKE_DESC, CREATE_TIME_DESC }

extension EnumDicExtension on MyEnumOrder {
  String get code {
    switch (this) {
      case MyEnumOrder.LIKE_DESC:
        return "LIKE_DESC";
      case MyEnumOrder.CREATE_TIME_DESC:
        return "CREATE_TIME_DESC";
    }
  }
}