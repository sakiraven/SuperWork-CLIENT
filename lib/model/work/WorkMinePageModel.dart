import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_home_work_2/constant/MyEnumOrder.dart';
import 'package:super_home_work_2/constant/RquestUrl.dart';
import 'dart:convert' as convert;

import 'package:super_home_work_2/model/base/RequestPageModelBase.dart';

class WorkMinePageModel extends RequestPageModelBase {
  WorkMinePageModel({
    required BuildContext context,
    required Function setState,
    bool? isJieMessage,
  }) : super(EnumPageType.pageSize, setState,context) {
    super.urlPath = RequestUrl.workMinePage;
    super.page = 1;
    send();
  }

  @override
  void remakeBO() {
    super.bo["page"] = super.page;
  }

  send() async {
    await super.request();
  }
}
