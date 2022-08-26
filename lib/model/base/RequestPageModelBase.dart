import 'dart:convert' as convert;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:super_home_work_2/constant/RquestUrl.dart';
import 'package:super_home_work_2/constant/StorageKey.dart';
import 'package:super_home_work_2/pages/userInfo/LoginWidget.dart';
import 'package:super_home_work_2/util/DioUtil.dart';
import 'package:super_home_work_2/util/StorageUtil.dart';

enum EnumPageType {
  id,
  pageSize,
  timeStamp,
  spliceLocalDataForId,
}

enum EnumRequestResult {
  init,
  success,
  apiError,
  param,
  auth,
  notLogin,
  pageEnd,
  phoneVerifyCodeMaxRequest,
  imgVerifyCodeExpire,
  phoneVerifyCodeIntervalLength,
  photoVerifyCodeExpire,
}

extension EnumRequestResultExtension on EnumRequestResult {
  String get code {
    switch (this) {
      case EnumRequestResult.init:
        return "0";
      case EnumRequestResult.success:
        return "200";
      case EnumRequestResult.apiError:
        return "301";
      case EnumRequestResult.param:
        return "400";
      case EnumRequestResult.auth:
        return "403";
      case EnumRequestResult.notLogin:
        return "401";
      case EnumRequestResult.pageEnd:
        return "404002";
      case EnumRequestResult.phoneVerifyCodeMaxRequest:
        return "50010";
      case EnumRequestResult.imgVerifyCodeExpire:
        return "50009";
      case EnumRequestResult.phoneVerifyCodeIntervalLength:
        return "50011";
      case EnumRequestResult.photoVerifyCodeExpire:
        return "50012";
    }
  }

  String get message {
    switch (this) {
      case EnumRequestResult.phoneVerifyCodeMaxRequest:
        return "短信验证码每日只能发送10次";
      case EnumRequestResult.imgVerifyCodeExpire:
        return "图形验证码错误或已过期,请重试";
      case EnumRequestResult.phoneVerifyCodeIntervalLength:
        return "短信验证码已发送,请1分钟后尝试";
      case EnumRequestResult.photoVerifyCodeExpire:
        return "短信验证码错误或已过期,请重新输入";
      default:
        return "其他错误";
    }
  }
}

class RequestPageModelBase {
  String baseUrl = RequestUrl.baseUrl;
  String urlPath = "";

  // 用于分页
  int lastId = 0;

  // 用于分页
  int lastTimeStamp = 0;

  // 用于分页
  int page = 1;

  // 数据集
  List<Map> dataList = [];

  // 数据集
  Map data = {};

  // 存在行数据
  int rowCount = 0;

  // 请求结果
  String result = EnumRequestResult.init.code;

  // 第一次请求后的加载节点
  Function firstRequestAfterLoadChild = () {};

  // 加载状态
  bool loading = false;

  // 初次加载
  bool firstLoading = true;

  // 分页类型
  EnumPageType pageType = EnumPageType.id;

  // 在网络数据请求到pageend时，开关打开，变为查询本地数据
  bool isQueryLocal = false;

  Map<String, dynamic> bo = Map();

  Function setState = () {};

  late BuildContext context;
  Function? loginSuccess;

  RequestPageModelBase(EnumPageType pageType, Function setState, BuildContext context, {Function? loginSuccess}) {
    this.pageType = pageType;
    this.setState = setState;
    this.context = context;
    this.loginSuccess = loginSuccess;
  }

  remakeBO() {}

  pageHandle() {
    if (result == EnumRequestResult.success.code) {
      switch (pageType) {
        case EnumPageType.id:
          lastId = dataList.last["id"];
          break;
        case EnumPageType.pageSize:
          page += 1;
          break;
        case EnumPageType.timeStamp:
          lastTimeStamp = dataList.last["timestamp"];
          break;
      }
    } else if (result == EnumRequestResult.notLogin.code) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const LoginWidget();
      })).then((value) {
        if (value!=null&&value) {
          if (loginSuccess != null) {
            loginSuccess!();
          }

          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('提示'),
                content: const SingleChildScrollView(
                  child: Center(
                    child: Text("登录成功"),
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                    child: const Text('确定'),
                    onPressed: () {
                      // 重新调用
                      request();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          ).then((val) {});
        }
      });
    }

    bool noMore = false;
    if (result == EnumRequestResult.pageEnd.code) {
      noMore = true;
    } else if (lastTimeStamp == 0 && lastId == 0 && page == 1 && dataList.length < 10) {
      noMore = true;
    }
    setState(() {
      // easyRefreshController.finishLoad(success: true, noMore: noMore);
    });
  }

  spliceLocalDataHandle(Response? response) async {
    if (EnumPageType.spliceLocalDataForId == pageType) {
      if (result == EnumRequestResult.pageEnd.code) {
        isQueryLocal = true;
        await this.request();
      } else {
        if (response == null) {
          return;
        }
        List lastQueryIdList = response.data["data"]["list"].map((e) => e["id"]).toList();
        String lastQueryIdListString = convert.jsonEncode(lastQueryIdList);
        await StorageUtil.setStringItem(StorageKey.string_lastQueryIdList, lastQueryIdListString);
        if (response.data["data"]["list"].length < 20) {
          this.result = EnumRequestResult.pageEnd.code;
          await this.spliceLocalDataHandle(null);
        }
      }
    }
  }

  errorReload() {
    loading = false;
    request();
  }

  refresh({Map<String, dynamic>? initBO}) async {
    setState(() {
      bo = {};
      lastId = 0;
      lastTimeStamp = 0;
      page = 1;
      dataList = [];
      data = {};
      result = EnumRequestResult.init.code;
      firstLoading = true;
      if (initBO != null) {
        bo = initBO;
      }
    });
    await request();
  }

  nextPage() async {
    await request();
  }

  request() async {
    if (loading) {
      return;
    }
    print(isQueryLocal);
    if (isQueryLocal) {
      await localRequest();
    } else {
      await netRequest();
    }
  }

  localRequest() async {
    page += 1;
    // 加载子节点
    if (firstLoading == true) {
      firstRequestAfterLoadChild();
      setState(() {
        firstLoading = false;
      });
    }
    setState(() {
      loading = false;
    });
  }

  netRequest() async {
    setState(() {
      loading = true;
    });
    await remakeBO();
    DioUtil dioUtil = DioUtil(errorReload);
    Dio dio = dioUtil.getDio();
    String token = await StorageUtil.getStringItem(StorageKey.token);
    Map<String, String> header = {"satoken": token, "Content-Type": "application/json"};
    Response? response;
    response = await dio
        .get(
      baseUrl + urlPath,
      queryParameters: bo,
      options: Options(headers: header),
    )
        .then(
      (response) async {
        await netRequestSuccess(response);
      },
      onError: (exception) async {
        await netRequestError();
      },
    );
  }

  netRequestError() async {
    if (firstLoading == true) {
      firstRequestAfterLoadChild();
      setState(() {
        firstLoading = false;
      });
    }
    // 分页处理
    pageHandle();
    setState(() {
      loading = false;
      result = EnumRequestResult.apiError.code;
    });
  }

  netRequestSuccess(Response? response) async {
    setState(() {
      result = response == null ? EnumRequestResult.apiError.code : response.data["result"];
      data = response!.data["data"];
    });
    // 加载数据
    if (result == EnumRequestResult.success.code) {
      try {
        setState(() {
          for (var data in response!.data["data"]["list"]) {
            dataList.add(data);
          }
        });
      } catch (e) {
        print("加载list失败$e");
      }
    }
    setState(() {
      rowCount = (dataList.length / 2).round();
    });
    // 加载子节点
    if (firstLoading == true) {
      firstRequestAfterLoadChild();
      setState(() {
        firstLoading = false;
      });
    }
    // 分页处理
    pageHandle();
    setState(() {
      loading = false;
    });
    // 拼接分页处理
    await spliceLocalDataHandle(response);
  }
}
