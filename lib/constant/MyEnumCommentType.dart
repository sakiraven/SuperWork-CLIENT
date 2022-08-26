enum MyEnumCommentType {
  LIKE,
  NOT_LIKE,
  ORDINARY,
}

extension EnumDicExtension on MyEnumCommentType {
  String get code {
    switch (this) {
      case MyEnumCommentType.LIKE:
        return "LIKE";
      case MyEnumCommentType.NOT_LIKE:
        return "NOT_LIKE";
      case MyEnumCommentType.ORDINARY:
        return "ORDINARY";
    }
  }
}
