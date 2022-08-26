import 'package:dio/dio.dart';

class DioUtil{
  Function reload;
  DioUtil(this.reload);
  getDio(){
    Dio dio = Dio();
    // 添加error拦截器
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) {
      print('请求接口：${options.uri}');
      return handler.next(options);
    }, onResponse: (response, handler) {
      handler.next(response);
    }, onError: (DioError e, handler) {
      // TextDialog.showTextDialog('网络连接错误，请重试！',reload);
      return handler.next(e);
    }));
    return dio;
  }
}
