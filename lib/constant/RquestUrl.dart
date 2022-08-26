import 'package:super_home_work_2/constant/Config.dart';

class RequestUrl {
  static String baseUrl = "https://home.sakikun.com:2189/superwork/";
  static String workHomePage = "work/home/page";
  static String workReviewPage = "work/review/page";
  static String workMinePage = "work/mine/page";
  static String workComment = "work/comment";
  static String workView = "work/review";
  static String workInfo = "work/info";
  static String systemImage = "system/image?path=";
  static String userInfoLogin = "userInfo/login";
  static String userInfoLoginOut = "userInfo/logout";

  static String getBaseUrlByEnv() {
    if (Config.currentEnv == Env.DEV) {
      return "http://192.168.50.99:2191/";
      // return "http://192.168.0.176:2191/";
    } else if (Config.currentEnv == Env.PROD) {
      return "https://home.sakikun.com:2189/superwork/";
    } else {
      return "";
    }
  }
}
