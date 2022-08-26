import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:super_home_work_2/common/dialog/CommonNotice.dart';
import 'package:super_home_work_2/common/event/Event.dart';
import 'package:super_home_work_2/common/event/LoginPushEvent.dart';
import 'package:super_home_work_2/constant/RquestUrl.dart';
import 'package:super_home_work_2/constant/StorageKey.dart';
import 'package:super_home_work_2/model/base/RequestPageModelBase.dart';
import 'package:super_home_work_2/pages/userInfo/LoginWidget.dart';
import 'package:super_home_work_2/util/DioUtil.dart';
import 'package:super_home_work_2/util/SakiColor.dart';
import 'package:super_home_work_2/util/StorageUtil.dart';

class RequestInfoModelBase {
  String baseUrl = RequestUrl.baseUrl;
  String urlPath = "";

  // 请求结果
  String result = EnumRequestResult.init.code;

  // 消息
  String msg = "";

  // 加载状态
  bool loading = false;

  // 初次加载
  bool firstLoading = true;

  Map bo = {};

  Map data = {};

  late Function setState;

  late BuildContext context;

  Function? loginSuccess;

  RequestInfoModelBase(BuildContext context, Function setState,{Function? loginSuccess}) {
    this.setState = setState;
    this.context = context;
    this.loginSuccess = loginSuccess;
  }

  void remakeBO() {}

  errorReload() {
    setState((){
      loading = false;
    });
    request();
  }

  request({Function? successCallback}) async {
    if (loading) {
      return;
    }
    _loadingDialog();
    setState((){
      loading = true;
    });
    remakeBO();
    DioUtil dioUtil = DioUtil(errorReload);
    Dio dio = dioUtil.getDio();
    String token = await StorageUtil.getStringItem(StorageKey.token);
    Map<String, String> header = {
      "satoken":token,
      "Content-Type":"application/json"
    };
    Response? response;
    try {
      response = await dio.post(
        baseUrl + urlPath,
        data: jsonEncode(bo),
        options: Options(headers: header),
      );
    } catch (e) {
      print(e);
    }
    result =
    response == null ? EnumRequestResult.apiError.code : response.data["result"];
    Navigator.pop(context);
    if(response!=null){
      msg = response.data["msg"];
      if(setState == null ){
        data = response.data["data"]==null?{}:response.data["data"];
      } else {
        setState(() {
          if(response!=null){
            data = response.data["data"]==null?{}:response.data["data"];
          }
        });
      }
    }
    if(result == EnumRequestResult.success.code){
      if(successCallback!=null){
        successCallback();
      }
    } else if(result == EnumRequestResult.notLogin.code){
      eventBus.fire(LoginPushEvent(loginSuccess,request));
    }else{
      CommonNotice.show(context, this.msg);
    }

    setState((){
      firstLoading = false;
      loading = false;
    });
  }

  Future<bool?> _loadingDialog() {
    var progressWidget = StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return WillPopScope(
        child: AlertDialog(
          title: Text(
            "请稍后...",
          ),
          content: Container(
            width: 50,
            height: 50,
            alignment: Alignment.topCenter,
            child: SpinKitWave(
              color: SakiColor.theme,
              size: 50.0,
            ),
          ),
        ),
        onWillPop: () async => false,
      );
    });

    return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return progressWidget;
      },
    );
  }
}