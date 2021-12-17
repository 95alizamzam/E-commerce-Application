import 'package:shared_preferences/shared_preferences.dart';

class sharedPrefrences {
  static SharedPreferences? prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  void setStringData({
    required String key,
    required String value,
  }) {
    prefs!.setString(key, value);
  }

  void setIntData({
    required String key,
    required int value,
  }) {
    prefs!.setInt(key, value);
  }

  void setBoolData({
    required String key,
    required bool value,
  }) {
    prefs!.setBool(key, value);
  }

  static dynamic getData({
    required String key,
    required String dataType,
  }) {
    switch (dataType) {
      case "String":
        {
          return prefs!.getString(key);
        }
      case "Int":
        {
          return prefs!.getInt(key);
        }
      case "Bool":
        {
          return prefs!.getBool(key);
        }
      default:
    }
  }

  static Future<void> deleteFields({required String Key}) async {
    await prefs!.remove(Key);
  }

  static Future<void> clearData() async {
    prefs!.clear();
  }
}
