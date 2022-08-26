enum MyEnumApproveStatus {
  NOT_START,
  APPROVED,
  REJECTED,
}

extension EnumDicExtension on MyEnumApproveStatus {
  String get code {
    switch (this) {
      case MyEnumApproveStatus.NOT_START:
        return "NOT_START";
      case MyEnumApproveStatus.APPROVED:
        return "APPROVED";
      case MyEnumApproveStatus.REJECTED:
        return "REJECTED";
    }
  }
}




