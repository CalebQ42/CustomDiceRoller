import 'dart:io';

import 'package:customdiceroller/cdr.dart';
import 'package:darkstorm_common/bottom.dart';
import 'package:darkstorm_common/frame_content.dart';
import 'package:darkstorm_common/updating_switch_tile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stupid/stupid.dart';

class Settings extends StatefulWidget{

  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    var cdr = CDR.of(context);
    return FrameContent(
      child: ListView(
        children: [
          if(kIsWeb || Platform.isAndroid || Platform.isIOS) SwitchListTile(
            value: cdr.prefs.drive(),
            onChanged: setDrive,
            title: Text(cdr.locale.drive),
          ),
          const Divider(),
          SwitchListTile(
            value: cdr.prefs.lightTheme(),
            onChanged: (val){
              if(val) cdr.prefs.setDarkTheme(false);
              cdr.prefs.setLightTheme(val);
              setState((){});
              cdr.topLevelUpdate!();
            },
            title: Text(cdr.locale.lightTheme),
          ),
          const Divider(),
          SwitchListTile(
            value: cdr.prefs.darkTheme(),
            onChanged: (val){
              if(val) cdr.prefs.setLightTheme(false);
              cdr.prefs.setDarkTheme(val);
              setState((){});
              cdr.topLevelUpdate!();
            },
            title: Text(cdr.locale.darkTheme),
          ),
          const Divider(),
          SwitchListTile(
            value: cdr.prefs.stupid(),
            onChanged: (val) async{
              cdr.prefs.setStupid(val);
              if(!val){
                cdr.stupid = null;
              }else{
                try{
                  String? apiKey;
                  var dot = DotEnv();
                  await dot.load(fileName: ".stupid");
                  apiKey = dot.maybeGet("STUPID_KEY");
                  if(apiKey != null){
                    cdr.stupid = Stupid(
                      baseUrl: Uri.parse("https://api.darkstorm.tech"),
                      deviceId: await cdr.prefs.stupidUuid(),
                      apiKey: apiKey,
                    );
                    if(cdr.prefs.log()){
                      await cdr.stupid!.log();
                    }
                    if(cdr.prefs.crash()){
                      FlutterError.onError = (err) {
                        cdr.stupid!.crash(Crash(
                          error: err.exceptionAsString(),
                          stack: err.stack?.toString() ?? "Not given",
                          version: cdr.packageInfo.version
                        ),);
                        FlutterError.presentError(err);
                      };
                    }
                  }
                }finally{}
              }
              setState((){});
            },
            title: Text(cdr.locale.stupid),
          ),
          const Divider(),
          UpdatingSwitchTile(
            value: cdr.prefs.crash(),
            onChanged: cdr.stupid != null ? (val) {
              cdr.prefs.setCrash(val);
              if(val && !kDebugMode){
                FlutterError.onError = (err) {
                  cdr.stupid!.crash(Crash(
                    error: err.exceptionAsString(),
                    stack: err.stack.toString(),
                    version: cdr.packageInfo.version
                  ));
                  FlutterError.presentError(err);
                };
              }else{
                FlutterError.onError = FlutterError.presentError;
              }
             } : null,
            title: Text(cdr.locale.stupidCrash),
          ),
          const Divider(),
          UpdatingSwitchTile(
            value: cdr.prefs.log(),
            onChanged: (val) =>
              cdr.prefs.setLog(val),
            title: Text(cdr.locale.stupidLog),
          ),
          const Divider(),
          UpdatingSwitchTile(
            title: Text(cdr.locale.calculatorKeyboard),
            subtitle: Text(cdr.locale.keyboardWarning),
            value: cdr.prefs.allowKeyboard(),
            onChanged: (p) =>
              cdr.prefs.setAllowKeyboard(p),
          ),
          const Divider(),
          UpdatingSwitchTile(
            value: cdr.prefs.individual(),
            onChanged: (val) =>
              cdr.prefs.setIndividual(val),
            title: Text(cdr.locale.individualPref),
          ),
          const Divider(),
          SwitchListTile(
            value: cdr.prefs.swipeDelete(),
            onChanged: (val){
              cdr.prefs.setSwipeDelete(val);
              if(!val && !cdr.prefs.deleteButton()){
                cdr.prefs.setDeleteButton(true);
              }
              setState((){});
            },
            title: Text(cdr.locale.swipeDelete),
          ),
          const Divider(),
          SwitchListTile(
            value: cdr.prefs.deleteButton(),
            onChanged: (val){
              cdr.prefs.setDeleteButton(val);
              if(!val && !cdr.prefs.swipeDelete()){
                cdr.prefs.setSwipeDelete(true);
              }
              setState((){});
            },
            title: Text(cdr.locale.deleteButtonPref),
          ),
          const Divider(),
          UpdatingSwitchTile(
            value: cdr.prefs.disableAnimations(),
            onChanged: (val){
              if(val){
                cdr.globalDuration = Duration.zero;
              }else{
                cdr.globalDuration = const Duration(milliseconds: 250);
              }
              cdr.prefs.setDisableAnimations(val);
              cdr.topLevelUpdate!();
            },
            title: Text(cdr.locale.disableAnimations),
          )
        ],
      )
    );
  }

  Future<void> setDrive(bool val) async{
    var cdr = CDR.of(context);
    if(!val){
      cdr.prefs.setDriveFirst(true);
      cdr.prefs.setDrive(val);
      await cdr.driver?.gsi?.signOut();
      cdr.driver = null;
      setState((){});
      return;
    }
    Bottom(
      dismissible: false,
      children: (c) =>
        [
          const CircularProgressIndicator(),
          Container(height: 10,),
          Text(cdr.locale.loadingDrive)
        ]
    ).show(context);
    cdr.prefs.setDrive(true);
    cdr.initializeDrive().then(
      (value) {
        cdr.prefs.setDrive(value);
        setState(() {});
        cdr.nav.pop();
        if(!val){
          cdr.prefs.setDriveFirst(true);
          Bottom(
            children: (c) =>[
              Text(cdr.locale.driveSettingError),
            ],
            buttons: (c) =>[
              TextButton(
                child: Text(cdr.locale.retry),
                onPressed: () => setDrive(true),
              )
            ],
          ).show(context);
        }
      }
    );
  }
}