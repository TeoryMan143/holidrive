import 'package:firebase_database/firebase_database.dart';

class DatabaseRepository {
  static final _dbInst = FirebaseDatabase.instance;

  static Future<void> setData(String path, Map<String, dynamic> data) async {
    await _dbInst.ref(path).set(data);
  }

  static void getDataUpdate(
    String path,
    void Function(DatabaseEvent event) onChange,
  ) {
    _dbInst.ref(path).onValue.listen(onChange);
  }

  static Future<void> deleteData(String path) async {
    await _dbInst.ref(path).remove();
  }
}
