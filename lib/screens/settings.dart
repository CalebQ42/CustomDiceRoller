import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/ui/frame.dart';
import 'package:customdiceroller/ui/updating_switch_tile.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget{

  const Settings({super.key});

  @override
  Widget build(BuildContext context) =>
    FrameContent(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UpdatingSwitchTile(
            value: CDR.of(context).globalDuration == Duration.zero,
            onChanged: (val){
              if(val){
                CDR.of(context).globalDuration = Duration.zero;
              }else{
                CDR.of(context).globalDuration = const Duration(milliseconds: 250);
              }
            },
            title: Text("Disable Animations"),
          )
        ],
      )
    );
}