import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<List<String>?> getSearchList(String key) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  static Future setSearchList(String key, List<String> list) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, list);
  }
}
