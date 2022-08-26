import 'package:flutter/material.dart';
import 'package:super_home_work_2/constant/Config.dart';
import 'package:super_home_work_2/pages/TabBarWidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Config.currentEnv = Env.PROD;
    return MaterialApp(
      title: '首页',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TabBarWidget(),
    );
  }
}
