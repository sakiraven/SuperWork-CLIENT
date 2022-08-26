import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:skeletons/skeletons.dart';
import 'package:super_home_work_2/common/event/Event.dart';
import 'package:super_home_work_2/common/event/ReloadTabWidgetEvent.dart';
import 'package:super_home_work_2/common/image/ImageCacheWidget.dart';
import 'package:super_home_work_2/constant/EnumDic.dart';
import 'package:super_home_work_2/constant/MyEnumApproveStatus.dart';
import 'package:super_home_work_2/constant/MyEnumCommentType.dart';
import 'package:super_home_work_2/constant/MyEnumOrder.dart';
import 'package:super_home_work_2/constant/StorageKey.dart';
import 'package:super_home_work_2/model/base/RequestPageModelBase.dart';
import 'package:super_home_work_2/model/userInfo/LoginOutModel.dart';
import 'package:super_home_work_2/model/work/WorkHomePageModel.dart';
import 'package:super_home_work_2/model/work/WorkMinePageModel.dart';
import 'package:super_home_work_2/pages/work/WorkDetailWidget.dart';
import 'package:super_home_work_2/pages/work/WorkPutWidget.dart';
import 'package:super_home_work_2/util/SakiColor.dart';
import 'package:super_home_work_2/util/StorageUtil.dart';

class WorkMineWidget extends StatefulWidget {
  WorkMineWidget();

  @override
  WorkMineState createState() => WorkMineState();
}

class WorkMineState extends State<WorkMineWidget> with TickerProviderStateMixin {
  WorkMineState();

  late WorkMinePageModel _workMinePageModel;
  late LoginOutModel _loginOutModel;

  @override
  void initState() {
    _workMinePageModel = WorkMinePageModel(context: context, setState: setState);
    _loginOutModel = LoginOutModel(context: context, setState: setState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("历史发布"),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 15),
            child: ElevatedButton(
              onPressed: () {
                _loginOutModel.send(() {
                  _workMinePageModel.send();
                  StorageUtil.setStringListItem(StorageKey.list_roleList, []);
                  eventBus.fire(ReloadTabWidgetEvent());
                });
              },
              child: Text("注销"),
            ),
          ),
        ],
      ),
      backgroundColor: SakiColor.form,
      body: pageManage(),
    );
  }

  Widget pageManage() {
    if (_workMinePageModel.firstLoading) {
      return SkeletonListView();
    } else if (_workMinePageModel.result == EnumRequestResult.apiError.code) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("网络异常请重试"),
            ElevatedButton(
              onPressed: _workMinePageModel.loading
                  ? null
                  : () {
                      _workMinePageModel.send();
                    },
              child: const Text("重试"),
            ),
          ],
        ),
      );
    } else if (_workMinePageModel.result == EnumRequestResult.notLogin.code) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("请先登陆"),
            ElevatedButton(
              onPressed: _workMinePageModel.loading
                  ? null
                  : () {
                      _workMinePageModel.send();
                    },
              child: const Text("登陆"),
            ),
          ],
        ),
      );
    } else if (_workMinePageModel.dataList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("你还未登记过地图"),
            ElevatedButton(
              onPressed: _workMinePageModel.loading
                  ? null
                  : () {
                      _workMinePageModel.send();
                    },
              child: const Text("重试"),
            ),
          ],
        ),
      );
    } else {
      return workHomeList();
    }
  }

  Widget workHomeList() {
    EasyRefreshController _controller = EasyRefreshController();
    return EasyRefresh(
      controller: _controller,
      header: MaterialHeader(),
      footer: MaterialFooter(),
      // enableControlFinishRefresh: true,
      // enableControlFinishLoad: true,
      child: ListView.builder(
        itemBuilder: (BuildContext content, int index) {
          return InkWell(
            child: router(_workMinePageModel.dataList[index]),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WorkDetailWidget(data: _workMinePageModel.dataList[index],)),
              )
            },
          );
        },
        itemCount: _workMinePageModel.dataList.length,
      ),
      onRefresh: () async {
        _workMinePageModel.refresh();
      },
      onLoad: () async {
        _workMinePageModel.nextPage();
      },
    );
  }

  Widget router(Map data) {
    Widget? routeWidget;
    print(data["approveStatus"]);
    if (data["approveStatus"] == MyEnumApproveStatus.REJECTED.code) {
      routeWidget = rejectQueryingData(data);
    } else if (!data["isInit"]) {
      routeWidget = notStartedQueryingData(data);
    } else {
      routeWidget = workItemWidget(data);
    }
    return routeWidget;
  }

  Widget rejectQueryingData(Map data) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.circular(5.0),
        // border: Border.all(color: Colors.grey),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "关卡ID：${data["courseId"]}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Spacer(),
              Text(
                data["createTimeLabel"],
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text("审核已拒绝：${data["rejectMessage"]}"),
        ],
      ),
    );
  }

  Widget notStartedQueryingData(Map data) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.circular(5.0),
        // border: Border.all(color: Colors.grey),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("关卡ID：${data["courseId"]}"),
              Spacer(),
              Text(
                data["createTimeLabel"],
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text("服务端暂未开始获取数据 请稍后查看"),
        ],
      ),
    );
  }

  Widget workItemWidget(data) {
    Widget? reviewWidget;
    Widget? commentWidget;

    if (data["isJieMessage"]) {
      commentWidget = Container(
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(5.0),
          color: Colors.red,
        ),
        padding: EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
        child: Text(
          "已评",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    } else {
      commentWidget = Container(
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(5.0),
          color: Colors.black12,
        ),
        padding: EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
        child: Text(
          "未评",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }
    if (data["approveStatus"] == MyEnumApproveStatus.NOT_START.code) {
      reviewWidget = Container(
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(5.0),
          color: Colors.grey,
        ),
        padding: EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
        child: Text(
          "未开始审核",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    } else if (data["approveStatus"] == MyEnumApproveStatus.APPROVED.code) {
      reviewWidget = Container(
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(5.0),
          color: Colors.green,
        ),
        padding: EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
        child: Text(
          "审核通过",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    } else if (data["approveStatus"] == MyEnumApproveStatus.REJECTED.code) {
      reviewWidget = Container(
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(5.0),
          color: Colors.red,
        ),
        padding: EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
        child: Text(
          "审核拒绝",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    }

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
                          commentWidget,
                          SizedBox(
                            width: 10,
                          ),
                          reviewWidget!,
                          Spacer(),
                          Text(
                            data["createTimeLabel"],
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
          SizedBox(
            height: 10,
          ),
          Container(
            height: 30,
            padding: EdgeInsets.all(5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset("asset/image/common/like.png"),
                    SizedBox(
                      width: 5,
                    ),
                    Text(data["likeNumsLabel"]),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    Image.asset("asset/image/common/ordinary.png"),
                    SizedBox(
                      width: 5,
                    ),
                    Text(data["ordinaryNumsLabel"]),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    Image.asset("asset/image/common/not_like.png"),
                    SizedBox(
                      width: 5,
                    ),
                    Text(data["notLikeNumsLabel"]),
                  ],
                ),
                Spacer(),
                getJieComment(data)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getJieComment(Map data) {
    Widget? jieMessageTypeWidget = null;

    if (data["isJieMessage"]) {
      if (data["jieMessageType"] == MyEnumCommentType.LIKE.code) {
        jieMessageTypeWidget = Image.asset("asset/image/common/like.png");
      } else if (data["jieMessageType"] == MyEnumCommentType.NOT_LIKE.code) {
        jieMessageTypeWidget = Image.asset("asset/image/common/not_like.png");
      } else if (data["jieMessageType"] == MyEnumCommentType.ORDINARY.code) {
        jieMessageTypeWidget = Image.asset("asset/image/common/ordinary.png");
      }
    }

    return data["isJieMessage"]
        ? Row(
      children: [
        Image.asset("asset/image/common/face_jie.png"),
        SizedBox(
          width: 5,
        ),
        jieMessageTypeWidget != null ? jieMessageTypeWidget : Container(),
      ],
    )
        : Container(
      width: 40,
    );
  }
}
