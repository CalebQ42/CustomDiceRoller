import 'package:customdiceroller/dice/dice.dart';
import 'package:customdiceroller/screens/frame.dart';
import 'package:customdiceroller/utils/observatory.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:isar/isar.dart';


class CDR{

  final SharedPreferences prefs;
  final FlutterSecureStorage securePrefs = const FlutterSecureStorage();
  final GlobalKey<NavigatorState> navKey = GlobalKey();
  final GlobalKey<FrameState> frameKey = GlobalKey();
  final Isar db;
  late Observatory observatory = Observatory(this, frameKey);
  late AppLocalizations locale;
  Duration globalDuration = const Duration(milliseconds: 300);

  bool initilized = false;

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

  Future<void> postInit(BuildContext context) async{
    locale = AppLocalizations.of(context)!;
    await Future.delayed(const Duration(seconds: 3)); // TODO: Add actual loading here.
    initilized = true;
  }

  static CDR of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<CDRHolder>()!.cdr;
}

class CDRHolder extends InheritedWidget{
  final CDR cdr;

  const CDRHolder(this.cdr, {super.key, required super.child});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
  
}