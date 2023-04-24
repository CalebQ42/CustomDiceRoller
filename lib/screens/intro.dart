import 'dart:io';

import 'package:customdiceroller/cdr.dart';
import 'package:darkstorm_common/frame_content.dart';
import 'package:darkstorm_common/updating_switch_tile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IntroScreen extends StatefulWidget{
  
  const IntroScreen({super.key});
  
  @override
  State<StatefulWidget> createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen>{
  Intro? intro;
  int screen = 0;

  @override
  Widget build(BuildContext context){
    var cdr = CDR.of(context);
    intro ??= Intro(AppLocalizations.of(context)!, cdr);
    return FrameContent(
      fab: FloatingActionButton(
        onPressed: (){
          if(screen < 2){
            setState(() => screen++);
          }else{
            cdr.prefs.setShownIntro(true);
            cdr.nav.pushNamedAndRemoveUntil("/", (route) => false);
          }
        },
        child: const Icon(Icons.arrow_forward),
      ),
      child: WillPopScope(
        onWillPop: () async{
          if(screen != 0){
            setState(() => screen -= 1);
          }
          return false;
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedSwitcher(
              duration: cdr.globalDuration,
              child: SizedBox(
                key: ValueKey(screen),
                width: 600,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: intro!.at(context,() => setState((){}), screen)
                  )
                )
              ),
            ),
            if(screen != 0) Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () =>
                    setState(() => screen--),
                ),
              ),
            )
          ]
        )
      ),
    );
  }
}

class Intro{
  AppLocalizations locale;
  CDR cdr;

  Intro(this.locale, this.cdr);

  Widget at(BuildContext context, void Function() setState, int i) {
    switch(i){
      case 0: return intro0(context);
      case 1: return intro1(context, setState);
      default: return intro2(context, setState);
    }
  }

  Widget intro0(BuildContext context) =>
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          locale.introWelcomeTitle,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Container(height: 10,),
        Text(
          locale.introWelcomeSub,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        )
      ],
    );
  
  Widget intro1(BuildContext context, void Function() setState) =>
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          locale.introStupidTitle,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Container(height: 10,),
        Text(
          locale.introStupidSub,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Container(height: 20),
        UpdatingSwitchTile(
          title: Text(locale.stupid),
          value: cdr.prefs.stupid(),
          onChanged:(p) {
            cdr.prefs.setStupid(p);
            setState();
          },
        ),
        const Divider(),
        UpdatingSwitchTile(
          title: Text(locale.stupidLog),
          value: cdr.prefs.log(),
          onChanged: cdr.prefs.stupid() ? (p) => cdr.prefs.setLog(p) : null,
        ),
        const Divider(),
        UpdatingSwitchTile(
          title: Text(locale.stupidCrash),
          value: cdr.prefs.crash(),
          onChanged: cdr.prefs.stupid() ? (p) => cdr.prefs.setCrash(p) : null,
        ),
      ],
    );

  Widget intro2(BuildContext context, void Function() setState) =>
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          locale.introOtherTitle,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Container(height: 20),
        UpdatingSwitchTile(
          title: Text(locale.drive),
          subtitle: !(kIsWeb || Platform.isAndroid || Platform.isIOS) ? Text(locale.notAvailablePlatform) : null,
          value: cdr.prefs.drive(),
          onChanged: (kIsWeb || Platform.isAndroid || Platform.isIOS) ? (p) =>
            cdr.prefs.setDrive(p) : null,
        ),
        const Divider(),
        SwitchListTile(
          value: cdr.prefs.lightTheme(),
          onChanged: (val){
            if(val) cdr.prefs.setDarkTheme(false);
            cdr.prefs.setLightTheme(val);
            setState();
            cdr.topLevelUpdate!();
          },
          title: Text(locale.lightTheme),
        ),
        const Divider(),
        SwitchListTile(
          value: cdr.prefs.darkTheme(),
          onChanged: (val){
            if(val) cdr.prefs.setLightTheme(false);
            cdr.prefs.setDarkTheme(val);
            setState();
            cdr.topLevelUpdate!();
          },
          title: Text(locale.darkTheme),
        ),
        const Divider(),
        UpdatingSwitchTile(
          title: Text(locale.swipeDelete),
          value: cdr.prefs.swipeDelete(),
          onChanged: (p) =>
            cdr.prefs.setSwipeDelete(p),
        ),
        const Divider(),
        UpdatingSwitchTile(
          title: Text(locale.deleteButtonPref),
          value: cdr.prefs.deleteButton(),
          onChanged: (p) =>
            cdr.prefs.setDeleteButton(p),
        ),
        const Divider(),
        UpdatingSwitchTile(
          title: Text(locale.calculatorKeyboard),
          subtitle: Text(locale.keyboardWarning),
          value: cdr.prefs.allowKeyboard(),
          onChanged: (p) =>
            cdr.prefs.setAllowKeyboard(p),
        ),
        const Divider(),
        UpdatingSwitchTile(
          title: Text(locale.individualPref),
          value: cdr.prefs.individual(),
          onChanged: (p) =>
            cdr.prefs.setIndividual(p),
        ),
      ],
    );
}