import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:isar/isar.dart';


class CDR{
  final SharedPreferences prefs;
  final FlutterSecureStorage securePrefs = const FlutterSecureStorage();
  late AppLocalizations local;

  CDR({required this.prefs});

  static Future<CDR> initialize() async{
    WidgetsFlutterBinding.ensureInitialized();
    // var db = await Isar.open([]);
    return CDR(
      prefs: await SharedPreferences.getInstance(),
    );
  }

  void postInit(BuildContext context){
    // local = AppLocalizations.of(context)!;
  }

  static CDR of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<CDRHolder>()!.cdr;
}

class CDRHolder extends InheritedWidget{
  final CDR cdr;

  const CDRHolder(this.cdr, {super.key, required super.child});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  
}