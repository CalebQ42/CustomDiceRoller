import 'package:customdiceroller/dice/dice.dart';
import 'package:customdiceroller/screens/frame.dart';
import 'package:customdiceroller/utils/observatory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:isar/isar.dart';


class CDR{

  final SharedPreferences prefs;
  final FlutterSecureStorage securePrefs = const FlutterSecureStorage();
  final GlobalKey<NavigatorState> navKey = GlobalKey();
  final GlobalKey<FrameState> frameKey = GlobalKey();
  late Observatory observatory;
  Duration globalDuration = const Duration(milliseconds: 300);

  final Isar db;

  CDR({required this.prefs, required this.db});

  static Future<CDR> initialize() async{
    WidgetsFlutterBinding.ensureInitialized();
    return CDR(
      prefs: await SharedPreferences.getInstance(),
      db: await Isar.open([
        DiceGroupSchema,
        DieSchema
      ])
    );
  }

  void postInit(BuildContext context){
    observatory = Observatory(this, frameKey);
  }

  static CDR of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<CDRHolder>()!.cdr;
}

class CDRHolder extends InheritedWidget{
  final CDR cdr;

  const CDRHolder(this.cdr, {super.key, required super.child});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
  
}