import 'package:flutter/material.dart';
import 'package:super_home_work_2/pages/TabBarWidget.dart';
import 'package:super_home_work_2/pages/userInfo/LoginWidget.dart';
import 'package:super_home_work_2/util/SakiColor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '首页',
      theme: ThemeData(
        primarySwatch: SakiThemeColor.kToDark,
        // primaryColor: Colors.red,
      ),
      home: TabBarWidget(),
      // home: LoginWidget(),
    );
  }
}
