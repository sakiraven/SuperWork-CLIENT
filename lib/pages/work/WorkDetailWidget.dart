import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:super_home_work_2/common/event/Event.dart';
import 'package:super_home_work_2/common/event/ResetHomeDataItemEvent.dart';
import 'package:super_home_work_2/common/image/ImageCacheWidget.dart';
import 'package:super_home_work_2/constant/MyEnumCommentType.dart';
import 'package:super_home_work_2/constant/StorageKey.dart';
import 'package:super_home_work_2/model/work/WorkComment.dart';
import 'package:super_home_work_2/util/SakiColor.dart';
import 'package:super_home_work_2/util/StorageUtil.dart';

class WorkDetailWidget extends StatefulWidget {
  Map data;

  WorkDetailWidget({
    Key? key,
    required Map this.data,
  }) : super(key: key);

  @override
  _WorkDetailWidgetState createState() => _WorkDetailWidgetState();
}

class _WorkDetailWidgetState extends State<WorkDetailWidget> {
  late WorkCommentModel _workCommentModel;
  late bool isJie;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _workCommentModel = WorkCommentModel(context: context, setState: setState);
    initRole();
  }

  initRole() async {
    List<String> roleList = List<String>.from(await StorageUtil.getStringListItem(StorageKey.list_roleList));
    isJie = roleList.contains("jie");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("关卡详情"),
        centerTitle: false,
      ),
      body: _pageManage(),
    );
  }

  Widget _pageManage() {
    // if (photoCoserPhoStampSendPagePreviewModel.loading) {
    //   return CardListSkeleton(
    //     style: SkeletonStyle(
    //       isShowAvatar: false,
    //       isCircleAvatar: true,
    //       barCount: 4,
    //     ),
    //   );
    // } else if (photoCoserPhoStampSendPagePreviewModel.result != EnumRequestResult.success.code) {
    //   return Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Text("加载异常或没有登录"),
    //         ElevatedButton(
    //             onPressed: () {
    //               photoCoserPhoStampSendPagePreviewModel.send(widget.photoCoserPhoId, widget.coserPhoUserInfoId);
    //             },
    //             child: const Text("重试"))
    //       ],
    //     ),
    //   );
    // } else {
    return _pageBody();
    // }
  }

  Widget _pageBody() {
    List<Widget> tagNameWidgetList = [];
    int limit = widget.data["tagNameList"].length > 4 ? 4 : widget.data["tagNameList"].length;
    for (int i = 0; i < limit; i++) {
      tagNameWidgetList.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "asset/image/common/label.png",
            width: 30,
            height: 30,
          ),
          Text(widget.data["tagNameList"][i]),
        ],
      ));
    }
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.circular(5.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            widget.data["title"],
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.circular(5.0),
              color: SakiColor.bubble,
            ),
            child: Column(
              children: [
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      SelectableText(
                        "关卡ID：${widget.data["courseId"]}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: SakiColor.courseId,
                          fontSize: 16,
                        ),
                      ),
                      Spacer(),
                      Text(
                        widget.data["createTimeLabel"],
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 100,
                  padding: EdgeInsets.only(
                    right: 5,
                  ),
                  child: Row(
                    children: [
                      ImageCacheWidget.get(
                        path: widget.data["thumbnailPath"],
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
                            Row(
                              children: [
                                Image.asset(
                                  "asset/image/common/like.png",
                                  width: 35,
                                  height: 35,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(widget.data["likeNumsLabel"]),
                                SizedBox(
                                  width: 15,
                                ),
                                Image.asset(
                                  "asset/image/common/ordinary.png",
                                  width: 35,
                                  height: 35,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(widget.data["ordinaryNumsLabel"]),
                                SizedBox(
                                  width: 15,
                                ),
                                Image.asset(
                                  "asset/image/common/not_like.png",
                                  width: 40,
                                  height: 40,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(widget.data["notLikeNumsLabel"]),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Wrap(
                                    spacing: 5,
                                    children: tagNameWidgetList,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
          ImageCacheWidget.get(
            path: widget.data["entirePath"],
            // fit: BoxFit.fitHeight,
            height: 100,
            radius: 5,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(right: 10, left: 10, bottom: 15),
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.circular(5.0),
              color: SakiColor.form,
            ),
            child: Column(
              children: [
                Container(
                  height: 85,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ImageCacheWidget.get(
                        path: widget.data["facePath"],
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
                                  widget.data["mineMessage"],
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
                widget.data["isJieMessage"]
                    ? Container(
                        height: 85,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ChatBubble(
                                    clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
                                    alignment: Alignment.topRight,
                                    margin: EdgeInsets.only(top: 20),
                                    backGroundColor: SakiColor.bubble,
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                                      ),
                                      child: Text(
                                        widget.data["jieMessage"],
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
                            SizedBox(
                              width: 5,
                            ),
                            Image.asset(
                              "asset/image/common/face_jie.png",
                              width: 85,
                              height: 85,
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Spacer(),
          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(onSurface: Colors.black12),
                onPressed: widget.data["mineMessageType"] != null && widget.data["mineMessageType"] != "" && widget.data["mineMessageType"] != MyEnumCommentType.LIKE.code
                    ? null
                    : () {
                        comment(MyEnumCommentType.LIKE);
                      },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "asset/image/common/like.png",
                      width: 35,
                      height: 35,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("喜欢"),
                  ],
                ),
              ),
              Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(onSurface: Colors.black12),
                onPressed: widget.data["mineMessageType"] != null && widget.data["mineMessageType"] != "" && widget.data["mineMessageType"] != MyEnumCommentType.ORDINARY.code
                    ? null
                    : () {
                        comment(MyEnumCommentType.ORDINARY);
                      },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "asset/image/common/ordinary.png",
                      width: 40,
                      height: 40,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("普通"),
                  ],
                ),
              ),
              Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(onSurface: Colors.black12),
                onPressed: widget.data["mineMessageType"] != null && widget.data["mineMessageType"] != "" && widget.data["mineMessageType"] != MyEnumCommentType.NOT_LIKE.code
                    ? null
                    : () {
                        comment(MyEnumCommentType.NOT_LIKE);
                      },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "asset/image/common/not_like.png",
                      width: 40,
                      height: 40,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("不喜欢"),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  void comment(MyEnumCommentType myEnumCommentType) async {
    if (widget.data["mineMessageType"] == myEnumCommentType.code) {
      return;
    }

    if (isJie) {
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
                    Text('必填: 请输入留言。'),
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
                    if (vc.text == null || vc.text.length == 0) {
                      return;
                    }
                    _workCommentModel.jie(widget.data["id"], myEnumCommentType, vc.text, () {
                      setState(() {
                        widget.data["mineMessageType"] = myEnumCommentType.code;
                        widget.data["jieMessageType"] = myEnumCommentType.code;
                        widget.data["isJieMessage"] = true;
                        widget.data["jieMessage"] = vc.text;
                      });
                      eventBus.fire(ResetHomeDataItemEvent(widget.data));
                      Navigator.pop(context);
                    });
                  },
                  child: Text('确定'),
                ),
              ],
            );
          });
    } else {
      _workCommentModel.user(widget.data["id"], myEnumCommentType, () {
        setState(() {
          widget.data["mineMessageType"] = myEnumCommentType.code;
          eventBus.fire(ResetHomeDataItemEvent(widget.data));
        });
      });
    }
  }
}
