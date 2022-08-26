import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_home_work_2/constant/MyEnumOrder.dart';
import 'package:super_home_work_2/constant/RquestUrl.dart';
import 'dart:convert' as convert;

import 'package:super_home_work_2/model/base/RequestPageModelBase.dart';

class WorkHomePageModel extends RequestPageModelBase {
  late MyEnumOrder myEnumOrder;
  late bool? isJieMessage;

  WorkHomePageModel({
    required BuildContext context,
    required Function setState,
    required MyEnumOrder myEnumOrder,
    bool? isJieMessage,
  }) : super(EnumPageType.pageSize, setState,context) {
    super.urlPath = RequestUrl.workHomePage;
    super.page = 1;
    this.myEnumOrder = myEnumOrder;
    this.isJieMessage = isJieMessage;
    this.send();
  }

  @override
  void remakeBO() {
    super.bo["page"] = super.page;
    super.bo["myEnumOrder"] = this.myEnumOrder.code;
    super.bo["isJieMessage"] = this.isJieMessage;
  }

  send() async {
    await super.request();
  }
}
