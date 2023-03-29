import 'package:flutter/material.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CDR{
  SharedPreferences prefs;
  SecureSharedPref securePrefs;

  CDR({required this.prefs, required this.securePrefs});

  static Future<CDR> initialize() async{
    WidgetsFlutterBinding.ensureInitialized();
    var prefs = await SharedPreferences.getInstance();
    var securePrefs = await SecureSharedPref.getInstance();
    return CDR(
      prefs: prefs,
      securePrefs: securePrefs
    );
  }

  static CDR of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<CDRHolder>()!.cdr;
}

class CDRHolder extends InheritedWidget{
  final CDR cdr;

  const CDRHolder(this.cdr, {super.key, required super.child});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  
}