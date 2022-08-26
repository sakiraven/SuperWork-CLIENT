import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:super_home_work_2/model/userInfo/LoginModel.dart';
import 'package:super_home_work_2/util/SakiColor.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _phone_vc = TextEditingController();
  final TextEditingController _code_vc = TextEditingController();
  late LoginModel _loginModel;

  @override
  void initState() {
    super.initState();
    _loginModel = LoginModel(context: context, setState: setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("登录"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
          child: Center(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "asset/image/logo/logo.png",
                        width: 50,
                        height: 50,
                      ),
                      SizedBox(
                        width: 20,
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
                                  maxWidth: MediaQuery.of(context).size.width * 0.55,
                                ),
                                child: Text(
                                  "请记住自己的登陆码，丢失后将无法找回。可以注册多账号但是还请不要恶意注册。",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
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
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          // autocorrect: true,
                          // maxLength: 12,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: "登录码",
                            hintText: "请输入登录码",
                            helperText: "尽可能复杂一些不要使用简单数字避免被其他人猜到。",
                          ),
                          validator: (psd) {
                            if (psd == null || psd.length == 0) {
                              return "登录码为必填项";
                            }
                            return null;
                          },
                          controller: _phone_vc,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            await _loginModel.masterLogin(_phone_vc.text);
                          },
                          child: Text("登录"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
