enum Env {
  PROD,
  DEV,
}

class Config {
  static Env currentEnv = Env.DEV;
  static String userInfoId = "";
}
