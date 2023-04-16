import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Prefs{
  SharedPreferences prefs;
  FlutterSecureStorage securePrefs;

  Prefs(this.prefs, this.securePrefs);

  // Intro
  bool shownIntro() => prefs.getBool("shownIntro") ?? false;
  void setShownIntro(bool p) => prefs.setBool("shownIntro", p);

  // Theme
  bool darkTheme() => prefs.getBool("darkTheme") ?? false;
  void setDarkTheme(bool p) => prefs.setBool("darkTheme", p);
  bool lightTheme() => prefs.getBool("lightTheme") ?? false;
  void setLightTheme(bool p) => prefs.setBool("lightTheme", p);
  bool amoledDark() => prefs.getBool("amoledDark") ?? false;
  void setAmoledDark(bool p) => prefs.setBool("amoledDark", p);

  // Stupid
  bool stupid() => prefs.getBool("stupid") ?? true;
  void setStupid(bool p) => prefs.setBool("stupid", p);
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

  //Drive
  bool drive() => prefs.getBool("drive") ?? kIsWeb || Platform.isAndroid || Platform.isIOS;
  void setDrive(bool p) => prefs.setBool("drive", p);
  bool driveFirst() => prefs.getBool("driveFirst") ?? true;
  void setDriveFirst(bool p) => prefs.setBool("driveFirst", p);

  // Misc
  bool disableAnimations() => prefs.getBool("disableAnimations") ?? false;
  void setDisableAnimations(bool p) => prefs.setBool("disableAnimations", p);
  bool deleteButton() => prefs.getBool("deleteButton") ?? kIsWeb || !(Platform.isAndroid || Platform.isIOS);
  void setDeleteButton(bool p) => prefs.setBool("deleteButton", p);
  bool swipeDelete() => prefs.getBool("swipeDelete") ?? kIsWeb || Platform.isAndroid || Platform.isIOS;
  void setSwipeDelete(bool p) => prefs.setBool("swipeDelete", p);
  bool individual() => prefs.getBool("individual") ?? false;
  void setIndividual(bool p) => prefs.setBool("individual", p);
  bool allowKeyboard() => prefs.getBool("keyboard") ?? !(kIsWeb || Platform.isAndroid || Platform.isIOS);
  void setAllowKeyboard(bool p) => prefs.setBool("keyboard", p);
}