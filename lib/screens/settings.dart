import 'dart:io';

import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/ui/frame_content.dart';
import 'package:customdiceroller/ui/updating_switch_tile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
            onChanged: (val) async{
              if(!val){
                cdr.prefs.setDriveFirst(true);
                cdr.prefs.setDrive(val);
                await cdr.driver?.gsi?.signOut();
                cdr.driver = null;
                return;
              }
              
              //TODO: pop-up and enable;
            },
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
          if(kIsWeb || Platform.isAndroid || Platform.isIOS) SwitchListTile(
            value: cdr.prefs.firebase(),
            onChanged: (val){
              //TODO: popup about re-starting the app.
            },
            title: Text(cdr.locale.firebase),
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
}