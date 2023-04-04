import 'package:customdiceroller/dice/dice.dart';
import 'package:customdiceroller/ui/frame.dart';
import 'package:customdiceroller/utils/observatory.dart';
import 'package:customdiceroller/utils/preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:isar/isar.dart';


class CDR{

  final Prefs prefs;
  final Isar db;

  late Observatory observatory = Observatory(this);
  late AppLocalizations locale;

  void Function()? topLevelUpdate;
  Duration globalDuration;
  bool initilized = false;

  final GlobalKey<NavigatorState> _navKey = GlobalKey();
  final GlobalKey<FrameState> _frameKey = GlobalKey();
  
  GlobalKey<NavigatorState> get navigatorKey => _navKey;
  GlobalKey<FrameState> get frameKey => _frameKey;

  NavigatorState? get nav => _navKey.currentState;
  FrameState? get frame => _frameKey.currentState;

  CDR({
    required this.prefs,
    required this.db,
    this.globalDuration = const Duration(milliseconds: 250)
  });

  static Future<CDR> initialize() async{
    WidgetsFlutterBinding.ensureInitialized();
    var prefs = Prefs(await SharedPreferences.getInstance(), const FlutterSecureStorage());
    return CDR(
      prefs: prefs,
      db: await Isar.open([
        DiceGroupSchema,
        DieSchema
      ]),
      globalDuration: prefs.disableAnimations() ? Duration.zero : const Duration(milliseconds: 300),
    );
  }

  Future<void> postInit(BuildContext context) async{
    locale = AppLocalizations.of(context)!;
    // TODO: Add actual loading here.
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