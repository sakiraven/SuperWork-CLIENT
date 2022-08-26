import 'package:flutter/cupertino.dart';
import 'package:super_home_work_2/common/dialog/CommonNotice.dart';
import 'package:super_home_work_2/constant/RquestUrl.dart';
import 'package:super_home_work_2/model/base/RequestInfoModelBase.dart';
import 'package:super_home_work_2/model/base/RequestPageModelBase.dart';

class LoginOutModel extends RequestInfoModelBase {
  LoginOutModel({
    required BuildContext context,
    required Function setState,
  }) : super(context, setState) {
    super.urlPath = RequestUrl.userInfoLoginOut;
  }

  send(Function reload) async {
    await super.request();

    if (super.result == EnumRequestResult.success.code) {
      reload();
    } else {
      CommonNotice.show(context, "注销失败");
    }
  }
}
