import 'package:flutter/cupertino.dart';
import 'package:super_home_work_2/common/event/Event.dart';
import 'package:super_home_work_2/common/event/ReloadTabWidgetEvent.dart';
import 'package:super_home_work_2/constant/RquestUrl.dart';
import 'package:super_home_work_2/constant/StorageKey.dart';
import 'package:super_home_work_2/model/base/RequestInfoModelBase.dart';
import 'package:super_home_work_2/model/base/RequestPageModelBase.dart';
import 'package:super_home_work_2/util/StorageUtil.dart';

class LoginModel extends RequestInfoModelBase {
  LoginModel({
    required BuildContext context,
    required Function setState,
  }) : super(context, setState) {
    super.urlPath = RequestUrl.userInfoLogin;
  }

  qqLogin(wechatId) async {
    String loginType = "login_qq";

    super.bo["loginType"] = loginType;
    super.bo["qqId"] = wechatId;
    await super.request();

    if (super.result == EnumRequestResult.success.code) {
      StorageUtil.setStringItem(StorageKey.token, super.data["token"]);

      Navigator.pop(context, true);
    }
  }

  masterLogin(masterId) async {
    String loginType = "login_master";

    super.bo["loginType"] = loginType;
    super.bo["masterId"] = masterId;
    await super.request();

    if (super.result == EnumRequestResult.success.code) {
      StorageUtil.setStringItem(StorageKey.token, super.data["token"]);
      StorageUtil.setStringItem(StorageKey.bigint_userInfoId, super.data["userInfoId"].toString());
      List<String> roleList =List<String>.from(super.data["roleList"]) ;
      StorageUtil.setStringListItem(StorageKey.list_roleList, roleList);
      eventBus.fire(ReloadTabWidgetEvent());
      Navigator.pop(context, true);
    }
  }
}
