import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CDR{
  final SharedPreferences prefs;
  final FlutterSecureStorage securePrefs = const FlutterSecureStorage();

  CDR({required this.prefs});

  static Future<CDR> initialize() async{
    WidgetsFlutterBinding.ensureInitialized();
    return CDR(
      prefs: await SharedPreferences.getInstance()
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