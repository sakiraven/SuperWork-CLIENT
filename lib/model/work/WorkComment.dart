import 'package:flutter/cupertino.dart';
import 'package:super_home_work_2/common/dialog/CommonNotice.dart';
import 'package:super_home_work_2/constant/MyEnumCommentType.dart';
import 'package:super_home_work_2/constant/RquestUrl.dart';
import 'package:super_home_work_2/model/base/RequestInfoModelBase.dart';
import 'package:super_home_work_2/model/base/RequestPageModelBase.dart';

class WorkCommentModel extends RequestInfoModelBase {
  WorkCommentModel({
    required BuildContext context,
    required Function setState,
  }) : super(context, setState) {
    super.urlPath = RequestUrl.workComment;
  }

  user(id,MyEnumCommentType myEnumCommentType,reload) async {
    super.bo["myEnumCommentType"] = myEnumCommentType.code;
    super.bo["id"] = id;

    await super.request();

    if (super.result == EnumRequestResult.success.code) {
      reload();
    } else {
      CommonNotice.show(context, "评价失败");
    }
  }

  jie(id,MyEnumCommentType myEnumCommentType,jieMessage,reload) async {
    super.bo["myEnumCommentType"] = myEnumCommentType.code;
    super.bo["id"] = id;
    super.bo["jieMessage"] = jieMessage;

    await super.request();

    if (super.result == EnumRequestResult.success.code) {
      reload();
    } else {
      CommonNotice.show(context, "评价失败");
    }
  }
}
