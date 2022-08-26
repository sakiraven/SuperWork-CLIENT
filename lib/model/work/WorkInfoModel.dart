import 'package:flutter/cupertino.dart';
import 'package:super_home_work_2/common/event/Event.dart';
import 'package:super_home_work_2/common/event/ReloadTabWidgetEvent.dart';
import 'package:super_home_work_2/constant/MyEnumApproveStatus.dart';
import 'package:super_home_work_2/constant/RquestUrl.dart';
import 'package:super_home_work_2/constant/StorageKey.dart';
import 'package:super_home_work_2/model/base/RequestInfoModelBase.dart';
import 'package:super_home_work_2/model/base/RequestPageModelBase.dart';
import 'package:super_home_work_2/util/StorageUtil.dart';

class WorkInfoModel extends RequestInfoModelBase {
  WorkInfoModel({
    required BuildContext context,
    required Function setState,
  }) : super(context, setState) {
    super.urlPath = RequestUrl.workInfo;
  }

  send(courseId,mineMessage) async {
    super.bo["courseId"] = courseId;
    super.bo["mineMessage"] = mineMessage;
    await super.request();
  }
}
