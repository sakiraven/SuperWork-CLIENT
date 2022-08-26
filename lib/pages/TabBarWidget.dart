import 'dart:async';

import 'package:flutter/material.dart';
import 'package:super_home_work_2/common/event/Event.dart';
import 'package:super_home_work_2/common/event/LoginPushEvent.dart';
import 'package:super_home_work_2/common/event/ReloadTabWidgetEvent.dart';
import 'package:super_home_work_2/constant/StorageKey.dart';
import 'package:super_home_work_2/pages/userInfo/LoginWidget.dart';
import 'package:super_home_work_2/pages/work/WorkHomeWidget.dart';
import 'package:super_home_work_2/pages/work/WorkMineWidget.dart';
import 'package:super_home_work_2/pages/work/WorkReviewWidget.dart';
import 'package:super_home_work_2/util/StorageUtil.dart';

class TabBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MainPageWidget();
  }
}

class MainPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainPageState();
  }
}

class MainPageState extends State<MainPageWidget> {
  int _tabIndex = 0;
  var tabImages;
  bool loading = false;
  List<BottomNavigationBarItem> iconTabList = [];

  /*
   * 存放三个页面，跟fragmentList一样
   */
  List<Widget> _pageList = [];
  late StreamSubscription reloadTabWidgetEventStream;
  late StreamSubscription loginPushEventStream;

  @override
  void initState() {
    super.initState();

    reloadTabWidgetEventStream = eventBus.on<ReloadTabWidgetEvent>().listen((event) {
      initData();
    });

    loginPushEventStream = eventBus.on<LoginPushEvent>().listen((event) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const LoginWidget();
      })).then((value){
        if(value){
          if(event.loginSuccess!=null){
            event.loginSuccess!();
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
                      event.request();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          ).then((val) {
          });
        }
      });
    });

    //初始化数据
    initData();
  }

  /*
   * 根据选择获得对应的normal或是press的icon
   */
  Image getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }

  /*
   * 根据image路径获取图片
   */
  Image getTabImage(path) {
    return new Image.asset(path, width: 24.0, height: 24.0);
  }

  void initData() async {
    setState(() {
      loading = true;
    });
    List<String> roleList = List<String>.from(await StorageUtil.getStringListItem(StorageKey.list_roleList));
    bool isAdmin = roleList.contains("admin");
    if (isAdmin) {
      setState(() {
        tabImages = [
          [
            getTabImage('asset/image/tabBar/home-unselected.png'),
            getTabImage('asset/image/tabBar/home-unselected.png'),
          ],
          [
            getTabImage('asset/image/tabBar/mine-unselected.png'),
            getTabImage('asset/image/tabBar/mine-unselected.png'),
          ],
          [
            getTabImage('asset/image/tabBar/review-unselected.png'),
            getTabImage('asset/image/tabBar/review-unselected.png'),
          ],
        ];

        _pageList = [
          WorkHomeWidget(),
          WorkMineWidget(),
          WorkReviewWidget(),
        ];
        iconTabList = [
          BottomNavigationBarItem(icon: getTabIcon(0), label: "班级关卡"),
          BottomNavigationBarItem(icon: getTabIcon(1), label: "我的关卡"),
          BottomNavigationBarItem(icon: getTabIcon(2), label: "审查"),
        ];
      });
    } else {
      setState(() {
        tabImages = [
          [
            getTabImage('asset/image/tabBar/home-unselected.png'),
            getTabImage('asset/image/tabBar/home-unselected.png'),
          ],
          [
            getTabImage('asset/image/tabBar/mine-unselected.png'),
            getTabImage('asset/image/tabBar/mine-unselected.png'),
          ],
        ];

        _pageList = [
          WorkHomeWidget(),
          WorkMineWidget(),
        ];
        iconTabList = [
          BottomNavigationBarItem(icon: getTabIcon(0), label: "班级关卡"),
          BottomNavigationBarItem(icon: getTabIcon(1), label: "我的关卡"),
        ];
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tabIndex,
        children: _pageList,
      ),
      bottomNavigationBar: loading
          ? Container()
          : BottomNavigationBar(
              items: iconTabList,
              type: BottomNavigationBarType.fixed,
              //默认选中首页
              currentIndex: _tabIndex,
              iconSize: 24.0,
              //点击事件
              onTap: (index) {
                setState(() {
                  _tabIndex = index;
                  print(_tabIndex);
                });
              },
              fixedColor: Color(0xFF000000),
            ),
    );
  }
}
