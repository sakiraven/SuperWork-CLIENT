import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:skeletons/skeletons.dart';
import 'package:super_home_work_2/common/event/Event.dart';
import 'package:super_home_work_2/common/event/ResetHomeDataItemEvent.dart';
import 'package:super_home_work_2/common/image/ImageCacheWidget.dart';
import 'package:super_home_work_2/constant/EnumDic.dart';
import 'package:super_home_work_2/constant/MyEnumCommentType.dart';
import 'package:super_home_work_2/constant/MyEnumOrder.dart';
import 'package:super_home_work_2/constant/StorageKey.dart';
import 'package:super_home_work_2/model/base/RequestPageModelBase.dart';
import 'package:super_home_work_2/model/work/WorkHomePageModel.dart';
import 'package:super_home_work_2/model/work/WorkReviewPageModel.dart';
import 'package:super_home_work_2/pages/work/WorkDetailWidget.dart';
import 'package:super_home_work_2/pages/work/WorkPutWidget.dart';
import 'package:super_home_work_2/util/SakiColor.dart';
import 'package:super_home_work_2/util/StorageUtil.dart';

class WorkHomeWidget extends StatefulWidget {
  WorkHomeWidget();

  @override
  WorkHomeState createState() => WorkHomeState();
}

class WorkHomeState extends State<WorkHomeWidget> with TickerProviderStateMixin {
  final List<String> _tabs = <String>["最新", "桀评", "期待"];
  late final TabController _tabController;

  WorkHomeState();

  late WorkHomePageModel newWorkHomePageModel;
  late WorkHomePageModel jieWorkHomePageModel;
  late WorkHomePageModel likeWorkHomePageModel;
  late StreamSubscription stream;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    newWorkHomePageModel = WorkHomePageModel(context: context, setState: setState, myEnumOrder: MyEnumOrder.CREATE_TIME_DESC);
    jieWorkHomePageModel = WorkHomePageModel(context: context, setState: setState, myEnumOrder: MyEnumOrder.CREATE_TIME_DESC, isJieMessage: true);
    likeWorkHomePageModel = WorkHomePageModel(context: context, setState: setState, myEnumOrder: MyEnumOrder.LIKE_DESC, isJieMessage: false);

    stream = eventBus.on<ResetHomeDataItemEvent>().listen((event) {
      print("test?");
      for (int i = 0; i < newWorkHomePageModel.dataList.length; i++) {
        Map value = newWorkHomePageModel.dataList[i];
        if (value["id"] == event.data["id"]) {
          setState(() {
            newWorkHomePageModel.dataList[i] = event.data;
          });
        }
      }

      for (int i = 0; i < jieWorkHomePageModel.dataList.length; i++) {
        Map value = jieWorkHomePageModel.dataList[i];
        if (value["id"] == event.data["id"]) {
          setState(() {
            jieWorkHomePageModel.dataList[i] = event.data;
          });
        }
      }

      for (int i = 0; i < likeWorkHomePageModel.dataList.length; i++) {
        Map value = likeWorkHomePageModel.dataList[i];
        if (value["id"] == event.data["id"]) {
          setState(() {
            likeWorkHomePageModel.dataList[i] = event.data;
          });
        }
      }
    });
  }

  initTabData() async {
    List<String> roleList = List<String>.from(await StorageUtil.getStringListItem(StorageKey.list_roleList));
    bool isAdmin = roleList.contains("admin");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: SakiColor.theme,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WorkPutWidget()),
          );
        },
      ),
      appBar: AppBar(
        title: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black45,
          tabs: _tabs.map((tab) => Text(tab, style: TextStyle(fontSize: 18.0))).toList(),
        ),
      ),
      backgroundColor: SakiColor.form,
      body: TabBarView(
        controller: _tabController,
        children: [homePageManage(newWorkHomePageModel), homePageManage(jieWorkHomePageModel), homePageManage(likeWorkHomePageModel)],
      ),
    );
  }

  Widget homePageManage(WorkHomePageModel workHomePageModel) {
    if (workHomePageModel.firstLoading) {
      return SkeletonListView();
    } else if (workHomePageModel.result == EnumRequestResult.apiError.code) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("网络异常请重试"),
            ElevatedButton(
              onPressed: workHomePageModel.loading
                  ? null
                  : () {
                      workHomePageModel.send();
                    },
              child: const Text("重试"),
            ),
          ],
        ),
      );
    } else if (workHomePageModel.dataList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("还没有人登记地图"),
            ElevatedButton(
              onPressed: workHomePageModel.loading
                  ? null
                  : () {
                      workHomePageModel.send();
                    },
              child: const Text("重试"),
            ),
          ],
        ),
      );
    } else {
      return workHomeList(
        workHomePageModel,
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
      // enableControlFinishRefresh: true,
      // enableControlFinishLoad: true,
      child: ListView.builder(
        itemBuilder: (BuildContext content, int index) {
          return InkWell(
            child: workItemWidget(workHomePageModel.dataList[index]),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WorkDetailWidget(
                          data: workHomePageModel.dataList[index],
                        )),
              )
            },
          );
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
            margin: EdgeInsets.all(
              5,
            ),
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.circular(5.0),
              color: SakiColor.form,
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
