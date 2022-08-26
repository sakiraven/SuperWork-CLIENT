import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:super_home_work_2/constant/StorageKey.dart';
import 'package:super_home_work_2/util/StorageUtil.dart';

class MessageDB {
  // static _instance，_instance会在编译期被初始化，保证了只被创建一次
  static final MessageDB _instance = MessageDB._internal();

  //提供了一个工厂方法来获取该类的实例
  factory MessageDB() {
    return _instance;
  }

  // 通过私有方法_internal()隐藏了构造方法，防止被误创建
  MessageDB._internal() {
    // 初始化
    init();
  }

  // MessageDB._internal(); // 不需要初始化

  void init() {
    print("这里初始化");
  }

  /// init db
  late Future<Database> database;

  initDB() async {
    try {
      int userInfoId = await StorageUtil.getIntItem("StorageKey.int_userInfoId");
      String uid = "default";
      if (userInfoId != null) {
        uid = "$userInfoId";
      }
      database = openDatabase(
        // Set the path to the database.
        // 需要升级可以直接修改数据库名称
        join(await getDatabasesPath(), 'message_database_v2_$uid.db'),
        // When the database is first created, create a table to store dogs.
        onCreate: (db, version) {
          // Run the CREATE TABLE statement on the database.
          try {
            Batch batch = db.batch();
            _createTable().forEach((element) {
              batch.execute(element);
            });
            batch.commit();
          } catch (err) {
            throw (err);
          }
        },
        onUpgrade: (Database db, int oldVersion, int newVersion) {
          try {
            Batch batch = db.batch();
            _createTable().forEach((element) {
              batch.execute(element);
            });
            batch.commit();
          } catch (err) {
            throw (err);
          }
        },
        // Set the version. This executes the onCreate function and provides a
        // path to perform database upgrades and downgrades.
        version: 1,
      );
    } catch (err) {
      throw (err);
    }
  }

  /// close db
  closeDB() async {
    await database
      ..close();
  }

  /// create table
  List<String> _createTable() {
    return [
    ];
  }
}
