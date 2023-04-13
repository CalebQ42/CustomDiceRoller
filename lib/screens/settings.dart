import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/ui/frame_content.dart';
import 'package:customdiceroller/ui/updating_switch_tile.dart';
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
            },
            title: Text(cdr.locale.disableAnimations),
          )
        ],
      )
    );
  }
}