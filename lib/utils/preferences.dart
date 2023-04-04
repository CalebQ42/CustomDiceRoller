import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // Misc
  bool disableAnimations() => prefs.getBool("DisableAnimations") ?? false;
  void setDisableAnimations(bool p) => prefs.setBool("DisableAnimations", p);
}