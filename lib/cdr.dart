import 'dart:io';

import 'package:customdiceroller/dice/dice.dart';
import 'package:customdiceroller/screens/loading.dart';
import 'package:darkstorm_common/driver.dart';
import 'package:customdiceroller/utils/preferences.dart';
import 'package:darkstorm_common/top_inherit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:isar/isar.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:stupid/stupid.dart';
import 'package:xdg_directories/xdg_directories.dart';


class CDR with TopResources{
  final Prefs prefs;
  final Isar db;

  late AppLocalizations locale;

  void Function()? topLevelUpdate;
  Driver? driver;
  bool initilized = false;
  Stupid? stupid;
  PackageInfo packageInfo;

  CDR({
    required this.prefs,
    required this.db,
    required this.packageInfo,
    Duration globalDuration = const Duration(milliseconds: 250)
  }){
    this.globalDuration = globalDuration;
  }

  static Future<CDR> initialize() async{
    WidgetsFlutterBinding.ensureInitialized();
    var prefs = Prefs(await SharedPreferences.getInstance(), const FlutterSecureStorage());
    Directory dir;
    if(Platform.isLinux){
      dir = Directory("${dataHome.path}/CDR");
    }else{
      dir = await getApplicationDocumentsDirectory();
    }
    dir.createSync(recursive: true);
    return CDR(
      prefs: prefs,
      db: await Isar.open(
        [DieSchema],
        directory: dir.path
      ),
      packageInfo: await PackageInfo.fromPlatform(),
    );
  }

  Future<void> postInit(BuildContext context, LoadingScreenState loading) async{
    locale = AppLocalizations.of(context)!;
    if(prefs.stupid()){
      try{
        String? apiKey;
        var dot = DotEnv();
        await dot.load(fileName: ".stupid");
        apiKey = dot.maybeGet("STUPID_KEY");
        if(apiKey != null){
          stupid = Stupid(
            baseUrl: Uri.parse("https://api.darkstorm.tech"),
            deviceId: await prefs.stupidUuid(),
            apiKey: apiKey,
          );
          if(prefs.log()){
            await stupid!.log();
          }
          if(prefs.crash()){
            FlutterError.onError = (err) {
              stupid!.crash(Crash(
                error: err.exceptionAsString(),
                stack: err.stack?.toString() ?? "Not given",
                version: packageInfo.version
              ),);
              FlutterError.presentError(err);
            };
          }
        }
      }finally{}
    }
    if(prefs.drive()){
      loading.loadingText = locale.loadingDrive;
      if(!await initializeDrive()) loading.driveFail = true;
    }
    initilized = true;
  }

  Future<bool> initializeDrive([bool reset = false]) async{
    if(driver != null && reset){
      await driver?.gsi?.signOut();
      driver = null;
    }
    if(driver == null){
      driver = Driver(
        drive.DriveApi.driveAppdataScope,
        (e, stack) => stupid?.crash(
          Crash(
            error: e.toString(),
            stack: stack.toString(),
            version: packageInfo.version
          )
        )
      );
      if(!await driver!.setWD("dies")) return false;
    }
    if(!await driver!.ready()) return false;
    return syncSaves();
  }

  Future<bool> syncSaves() async{
    if(!prefs.drive() || driver == null || !await driver!.ready()) return false;
    var fils = await driver!.listFiles("");
    if(fils == null) return false;
    var dies = await db.dies.where().findAll();
    for(var f in fils){
      if(f.name == null || f.id == null) continue;
      var match = await db.dies.getByUuid(f.name!);
      if(match == null){
        if(!await Die.importFromCloud(f.id!, this)) return false;
      }else{
        if(!await match.cloudLoad(f.id!, this)) return false;
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

  static CDR of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<TopInherit>()!.resources as CDR;
}