import 'dart:io';

import 'package:customdiceroller/cdr.dart';
import 'package:darkstorm_common/intro.dart';
import 'package:darkstorm_common/updating_switch_tile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Intro{
  Intro();

  List<IntroPage Function(BuildContext)> pages() => [
    intro0,
    intro1,
    intro2,
  ];

  IntroPage intro0(BuildContext context) =>
    IntroPage(
      title: Text(AppLocalizations.of(context)!.introWelcomeTitle),
      subtext: Text(AppLocalizations.of(context)!.introWelcomeSub),
    );
  
  IntroPage intro1(BuildContext context) {
    var pageKey = GlobalKey<IntroPageState>();
    var cdr = CDR.of(context);
    return IntroPage(
      key: pageKey,
      title: Text(AppLocalizations.of(context)!.introStupidTitle),
      subtext: Text(AppLocalizations.of(context)!.introStupidSub),
      items: [
        UpdatingSwitchTile(
          title: Text(AppLocalizations.of(context)!.stupid),
          value: cdr.prefs.stupid(),
          onChanged:(p) {
            cdr.prefs.setStupid(p);
            pageKey.currentState?.update();
          },
        ),
        const Divider(),
        UpdatingSwitchTile(
          title: Text(AppLocalizations.of(context)!.stupidLog),
          value: cdr.prefs.log(),
          onChanged: cdr.prefs.stupid() ? (p) => cdr.prefs.setLog(p) : null,
        ),
        const Divider(),
        UpdatingSwitchTile(
          title: Text(AppLocalizations.of(context)!.stupidCrash),
          value: cdr.prefs.crash(),
          onChanged: cdr.prefs.stupid() ? (p) => cdr.prefs.setCrash(p) : null,
        ),
      ],
    );
  }

  IntroPage intro2(BuildContext context) {
    var pageKey = GlobalKey<IntroPageState>();
    var cdr = CDR.of(context);
    return IntroPage(
      key: pageKey,
      title: Text(AppLocalizations.of(context)!.introOtherTitle),
      items: [
        UpdatingSwitchTile(
          title: Text(AppLocalizations.of(context)!.drive),
          subtitle: !(kIsWeb || Platform.isAndroid || Platform.isIOS) ? Text(AppLocalizations.of(context)!.notAvailablePlatform) : null,
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
            pageKey.currentState?.update();
            cdr.topLevelUpdate!();
          },
          title: Text(AppLocalizations.of(context)!.lightTheme),
        ),
        const Divider(),
        SwitchListTile(
          value: cdr.prefs.darkTheme(),
          onChanged: (val){
            if(val) cdr.prefs.setLightTheme(false);
            cdr.prefs.setDarkTheme(val);
            pageKey.currentState?.update();
            cdr.topLevelUpdate!();
          },
          title: Text(AppLocalizations.of(context)!.darkTheme),
        ),
        const Divider(),
        UpdatingSwitchTile(
          title: Text(AppLocalizations.of(context)!.swipeDelete),
          value: cdr.prefs.swipeDelete(),
          onChanged: (p) =>
            cdr.prefs.setSwipeDelete(p),
        ),
        const Divider(),
        UpdatingSwitchTile(
          title: Text(AppLocalizations.of(context)!.deleteButtonPref),
          value: cdr.prefs.deleteButton(),
          onChanged: (p) =>
            cdr.prefs.setDeleteButton(p),
        ),
        const Divider(),
        UpdatingSwitchTile(
          title: Text(AppLocalizations.of(context)!.calculatorKeyboard),
          subtitle: Text(AppLocalizations.of(context)!.keyboardWarning),
          value: cdr.prefs.allowKeyboard(),
          onChanged: (p) =>
            cdr.prefs.setAllowKeyboard(p),
        ),
        const Divider(),
        UpdatingSwitchTile(
          title: Text(AppLocalizations.of(context)!.individualPref),
          value: cdr.prefs.individual(),
          onChanged: (p) =>
            cdr.prefs.setIndividual(p),
        ),
      ],
    );
  }
}