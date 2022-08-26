import 'package:flutter/cupertino.dart';
import 'package:super_home_work_2/common/event/Event.dart';
import 'package:super_home_work_2/common/event/ReloadTabWidgetEvent.dart';
import 'package:super_home_work_2/constant/MyEnumApproveStatus.dart';
import 'package:super_home_work_2/constant/RquestUrl.dart';
import 'package:super_home_work_2/constant/StorageKey.dart';
import 'package:super_home_work_2/model/base/RequestInfoModelBase.dart';
import 'package:super_home_work_2/model/base/RequestPageModelBase.dart';
import 'package:super_home_work_2/util/StorageUtil.dart';

class WorkReviewModel extends RequestInfoModelBase {
  WorkReviewModel({
    required BuildContext context,
    required Function setState,
  }) : super(context, setState) {
    super.urlPath = RequestUrl.workView;
  }

  reject(id,rejectMessage) async {
    super.bo["id"] = id;
    super.bo["myEnumApproveStatus"] = MyEnumApproveStatus.REJECTED.code;
    super.bo["rejectMessage"] = rejectMessage;
    await super.request();
  }

  approved(id) async {
    super.bo["id"] = id;
    super.bo["myEnumApproveStatus"] = MyEnumApproveStatus.APPROVED.code;
    await super.request();
  }
}
