import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Prefs{
  SharedPreferences prefs;
  FlutterSecureStorage securePrefs;

  Prefs(this.prefs, this.securePrefs);

  // Theme
  bool darkTheme() => prefs.getBool("darkTheme") ?? false;
  void setDarkTheme(bool p) => prefs.setBool("darkTheme", p);
  bool lightTheme() => prefs.getBool("lightTheme") ?? false;
  void setLightTheme(bool p) => prefs.setBool("lightTheme", p);
  bool amoledDark() => prefs.getBool("amoledDark") ?? false;
  void setAmoledDark(bool p) => prefs.setBool("amoledDark", p);

  // Stupid
  Future<String> stupidUuid() async {
    var id = await securePrefs.read(key: "uuid");
    if(id == null){
      id = const Uuid().v4();
      await securePrefs.write(key: "uuid", value: id);
    }
    return id;
  }
  bool log() => prefs.getBool("stupidLog") ?? true;
  void setLog(bool p) => prefs.setBool("stupidLog", p);
  bool crash() => prefs.getBool("stupidCrash") ?? true;
  void setCrash(bool p) => prefs.setBool("stupidCrash", p);
  Future<String?> username() => securePrefs.read(key: "stupidUsername");
  Future<void> setUsername(String u) => securePrefs.write(key: "stupidUsername", value: u);
  Future<String?> password() => securePrefs.read(key: "stupidPassword");
  Future<void> setPassword(String p) => securePrefs.write(key: "stupidPassword", value: p);

  // Misc
  bool disableAnimations() => prefs.getBool("disableAnimations") ?? false;
  void setDisableAnimations(bool p) => prefs.setBool("disableAnimations", p);
  bool deleteButton() => prefs.getBool("deleteButton") ?? kIsWeb;
  void setDeleteButton(bool p) => prefs.setBool("deleteButton", p);
  bool swipeDelete() => prefs.getBool("swipeDelete") ?? true;
  void setSwipeDelete(bool p) => prefs.setBool("swipeDelete", p);
}