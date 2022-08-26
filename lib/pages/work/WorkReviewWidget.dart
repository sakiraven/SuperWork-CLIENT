import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:skeletons/skeletons.dart';
import 'package:super_home_work_2/common/dialog/CommonNotice.dart';
import 'package:super_home_work_2/common/event/Event.dart';
import 'package:super_home_work_2/common/event/ReloadTabWidgetEvent.dart';
import 'package:super_home_work_2/common/image/ImageCacheWidget.dart';
import 'package:super_home_work_2/constant/EnumDic.dart';
import 'package:super_home_work_2/constant/MyEnumCommentType.dart';
import 'package:super_home_work_2/constant/MyEnumOrder.dart';
import 'package:super_home_work_2/constant/StorageKey.dart';
import 'package:super_home_work_2/model/base/RequestPageModelBase.dart';
import 'package:super_home_work_2/model/work/WorkHomePageModel.dart';
import 'package:super_home_work_2/model/work/WorkReviewModel.dart';
import 'package:super_home_work_2/model/work/WorkReviewPageModel.dart';
import 'package:super_home_work_2/pages/work/WorkDetailWidget.dart';
import 'package:super_home_work_2/pages/work/WorkPutWidget.dart';
import 'package:super_home_work_2/util/SakiColor.dart';
import 'package:super_home_work_2/util/StorageUtil.dart';

class WorkReviewWidget extends StatefulWidget {
  WorkReviewWidget();

  @override
  WorkReviewState createState() => WorkReviewState();
}

class WorkReviewState extends State<WorkReviewWidget> with TickerProviderStateMixin {
  late WorkReviewPageModel _workReviewPageModel;
  late WorkReviewModel _workReviewModel;

  @override
  void initState() {
    _workReviewPageModel = WorkReviewPageModel(context: context, setState: setState);
    _workReviewModel = WorkReviewModel(context: context, setState: setState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("审查"),
        centerTitle: true,
      ),
      backgroundColor: SakiColor.form,
      body: homePageManage(),
    );
  }

  Widget homePageManage() {
    if (_workReviewPageModel.firstLoading) {
      return SkeletonListView();
    } else if (_workReviewPageModel.result == EnumRequestResult.apiError.code) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("网络异常请重试"),
            ElevatedButton(
              onPressed: _workReviewPageModel.loading
                  ? null
                  : () {
                      _workReviewPageModel.send();
                    },
              child: const Text("重试"),
            ),
          ],
        ),
      );
    } else if (_workReviewPageModel.dataList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("还没有人登记地图"),
            ElevatedButton(
              onPressed: _workReviewPageModel.loading
                  ? null
                  : () {
                      _workReviewPageModel.send();
                    },
              child: const Text("重试"),
            ),
          ],
        ),
      );
    } else {
      return workHomeList(
        _workReviewPageModel,
      );
    }
  }

  Widget reviewPageManage(WorkReviewPageModel reviewPageModel) {
    if (reviewPageModel.firstLoading) {
      return SkeletonListView();
    } else if (reviewPageModel.result == EnumRequestResult.apiError.code) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("网络异常请重试"),
            ElevatedButton(
              onPressed: reviewPageModel.loading
                  ? null
                  : () {
                      reviewPageModel.send();
                    },
              child: const Text("重试"),
            ),
          ],
        ),
      );
    } else if (reviewPageModel.dataList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("还没有人登记地图"),
            ElevatedButton(
              onPressed: reviewPageModel.loading
                  ? null
                  : () {
                      reviewPageModel.page =  1;
                      reviewPageModel.send();
                    },
              child: const Text("重试"),
            ),
          ],
        ),
      );
    } else {
      return workHomeList(
        reviewPageModel,
      );
    }
  }

  Widget workHomeList(RequestPageModelBase workHomePageModel) {
    EasyRefreshController _controller = EasyRefreshController();
    return EasyRefresh(
      controller: _controller,
      header: MaterialHeader(),
      footer: MaterialFooter(),
      child: ListView.builder(
        itemBuilder: (BuildContext content, int index) {
          return workItemWidget(workHomePageModel.dataList[index]);
        },
        itemCount: workHomePageModel.dataList.length,
      ),
      onRefresh: () async {
        workHomePageModel.refresh();
      },
      onLoad: () async {
        workHomePageModel.nextPage();
      },
    );
  }

  Widget workItemWidget(Map data) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.circular(5.0),
        // border: Border.all(color: Colors.grey),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 100,
            padding: EdgeInsets.only(
              right: 5,
            ),
            child: Row(
              children: [
                ImageCacheWidget.get(
                  path: data["thumbnailPath"],
                  width: 150,
                  height: 100,
                  radius: 5,
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        data["title"],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          data["isJieMessage"]
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: new BorderRadius.circular(5.0),
                                    color: Colors.red,
                                  ),
                                  padding: EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
                                  child: Text(
                                    "已评",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    borderRadius: new BorderRadius.circular(5.0),
                                    color: Colors.black12,
                                  ),
                                  padding: EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
                                  child: Text(
                                    "未评",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                          Spacer(),
                          Text(
                            "${data["createTimeLabel"]}",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 85,
            padding: EdgeInsets.only(
              right: 5,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageCacheWidget.get(
                  path: data["facePath"],
                  width: 85,
                  height: 85,
                  radius: 5,
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChatBubble(
                        clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top: 20),
                        backGroundColor: SakiColor.bubble,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          child: Text(
                            "${data["mineMessage"]}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _workReviewModel.approved(
                      data["id"],
                    );
                    if (_workReviewModel.result == EnumRequestResult.success.code) {
                      CommonNotice.show(context, "通过成功");
                      _workReviewPageModel.dataList.removeWhere((element) => element["id"] == data["id"]);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  child: Text("通过"),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    final TextEditingController vc = TextEditingController();
                    showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: Text('温馨提示'),
                            content: Card(
                              elevation: 0.0,
                              child: Column(
                                children: <Widget>[
                                  Text('请输入拒绝原因。'),
                                  CupertinoTextField(
                                    controller: vc,
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('取消'),
                              ),
                              CupertinoDialogAction(
                                onPressed: () async {
                                  await _workReviewModel.reject(
                                    data["id"],
                                    vc.text,
                                  );
                                  if (_workReviewModel.result == EnumRequestResult.success.code) {
                                    Navigator.pop(context);
                                    CommonNotice.show(context, "拒绝成功");
                                    _workReviewPageModel.dataList.removeWhere((element) => element["id"] == data["id"]);
                                  }
                                },
                                child: Text('确定'),
                              ),
                            ],
                          );
                        });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: Text("拒绝"),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
