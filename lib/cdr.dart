import 'dart:io';

import 'package:customdiceroller/dice/dice.dart';
import 'package:customdiceroller/firebase_options.dart';
import 'package:customdiceroller/screens/loading.dart';
import 'package:customdiceroller/ui/frame.dart';
import 'package:customdiceroller/utils/driver/driver.dart';
import 'package:customdiceroller/utils/observatory.dart';
import 'package:customdiceroller/utils/preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:isar/isar.dart';
import 'package:googleapis/drive/v3.dart' as drive;


class CDR{
  final Prefs prefs;
  final Isar db;

  late Observatory observatory = Observatory(this);
  late AppLocalizations locale;

  void Function()? topLevelUpdate;
  Duration globalDuration;
  Driver? driver;
  bool initilized = false;
  bool firebaseAvailable = false;

  final GlobalKey<NavigatorState> _navKey = GlobalKey();
  final GlobalKey<FrameState> _frameKey = GlobalKey();
  
  GlobalKey<NavigatorState> get navigatorKey => _navKey;
  GlobalKey<FrameState> get frameKey => _frameKey;

  NavigatorState? get nav => _navKey.currentState;
  FrameState? get frame => _frameKey.currentState;

  bool get isMobile {
    if(kIsWeb){
      return false;
    }
    return Platform.isAndroid || Platform.isIOS;
  }

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
        DieSchema
      ]),
      globalDuration: prefs.disableAnimations() ? Duration.zero : const Duration(milliseconds: 300),
    );
  }

  Future<void> postInit(BuildContext context, LoadingScreenState loading) async{
    locale = AppLocalizations.of(context)!;
    if(prefs.firebase()){
      try{
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform
        );
        firebaseAvailable = true;
        if(!kDebugMode && prefs.crashlytics()){
          FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
          FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
        }else{
          FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
        }
      }finally{}
    }
    if(prefs.drive()){
      loading.loadingText = locale.loadingDrive;
      var ok = await initializeDrive();
      if(ok){
        ok = await syncSaves();
      }
      if(!ok) loading.driveFail();
    }
    initilized = true;
  }

  Future<bool> initializeDrive(){
    driver ??= Driver(
      drive.DriveApi.driveAppdataScope,
      firebaseAvailable && prefs.crashlytics()
    );
    return driver!.ready();
  }

  Future<bool> syncSaves() async{
    if(!prefs.drive() || driver == null || !await driver!.ready()) return false;
    var fils = await driver!.listFiles("");
    if(fils == null) return false;
    var dies = await db.dies.where().findAll();
    for(var f in fils){
      if(f.name == null || f.driveId == null) continue;
      var match = await db.dies.getByUuid(f.name!);
      if(match == null){
        if(!await Die.importFromCloud(f.driveId!, this)) return false;
      }else{
        if(!await match.cloudLoad(f.driveId!, this)) return false;
        dies.removeWhere((element) => element.uuid == match.uuid);
      }
    }
    for(var u in dies){
      if(prefs.driveFirst()){
        if(!await u.cloudSave(this)) return false;
        prefs.setDriveFirst(false);
      }else{
        await db.dies.delete(u.id);
      }
    }
    return true;
  }

  static CDR of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<CDRHolder>()!.cdr;
}

class CDRHolder extends InheritedWidget{
  final CDR cdr;

  const CDRHolder(this.cdr, {super.key, required super.child});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}