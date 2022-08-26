import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:super_home_work_2/common/dialog/CommonNotice.dart';
import 'package:super_home_work_2/model/base/RequestPageModelBase.dart';
import 'package:super_home_work_2/model/work/WorkInfoModel.dart';
import 'package:super_home_work_2/util/SakiColor.dart';

class WorkPutWidget extends StatefulWidget {
  WorkPutWidget({
    Key? key,
  }) : super(key: key);

  @override
  _WorkPutWidgetState createState() => _WorkPutWidgetState();
}

class _WorkPutWidgetState extends State<WorkPutWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _workInfoModel = WorkInfoModel(context: context, setState: setState);
  }

  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _courseController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  late WorkInfoModel _workInfoModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("发布"),
        centerTitle: false,
      ),
      body: page(),
    );
  }

  Widget page() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "asset/image/logo/logo.png",
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: ChatBubble(
                      clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 10),
                      backGroundColor: SakiColor.bubble,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        child: RichText(
                          text: TextSpan(text: "", style: TextStyle(color: Colors.black, height: 1.7), children: [
                            TextSpan(text: "1. 请填写"),
                            TextSpan(
                              text: "关卡ID",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: "和"),
                            TextSpan(
                              text: "留言",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                                text: "。\n"
                                    "2. 系统自动获取关卡信息，每张地图耗时"),
                            TextSpan(
                              text: "1分钟",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                                text: "，同时提交地图越多所需要时间越长。\n"
                                    "3. 等待管理员审核留言是否符合规范，留言请使用"),
                            TextSpan(
                              text: "文明用语",
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: "，感谢配合。")
                          ]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      // autocorrect: true,
                      maxLength: 9,
                      decoration: const InputDecoration(
                        labelText: "关卡ID",
                        hintText: "请输入关卡ID",
                        // helperText: "早季承诺不会侵犯您的隐私、推送垃圾信息",
                      ),
                      validator: (psd) {
                        if (psd == null) {
                          return "请输入九位关卡id 例如: 3W403373G";
                        } else if (psd.trim().length != 9) {
                          return "请输入九位关卡id 例如: 3W403373G";
                        }
                      },
                      controller: _courseController,
                      inputFormatters: [
                        // FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLines: 2,
                      minLines: 1,
                      maxLength: 30,
                      decoration: const InputDecoration(
                        labelText: "留言",
                        hintText: "留言",
                        // helperText: "早季承诺不会侵犯您的隐私、推送垃圾信息",
                      ),
                      validator: (psd) {
                        if (psd == null) {
                          return "必须要填写5字以上的留言";
                        } else if (psd.trim().length < 5) {
                          return "必须要填写5字以上的留言";
                        }
                      },
                      controller: _messageController,
                      // inputFormatters: [
                      // FilteringTextInputFormatter.digitsOnly,
                      // ],
                      // keyboardType: TextInputType.,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('提交审核'),
                  ],
                ),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  await _workInfoModel.send(_courseController.text, _messageController.text);

                  if (_workInfoModel.result == EnumRequestResult.success.code) {
                    Navigator.of(context).pop();
                    CommonNotice.show(context, "提交成功,可以在我的关卡中查看");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
