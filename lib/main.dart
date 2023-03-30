import 'dart:async';

import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/screens/calculator.dart';
import 'package:customdiceroller/screens/settings.dart';
import 'package:customdiceroller/screens/frame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() =>
  runZonedGuarded(
    () {
      CDR.initialize().then(
        (value) => runApp(
          CDRHolder(
            value,
            child: const MainUI()
          )
        )
      );
    },
    (error, stack) {
      if(kDebugMode){
        print(error);
        print(stack);
      }
    }
  );

class MainUI extends StatefulWidget{
  
  const MainUI({super.key});

  @override
  State<StatefulWidget> createState() => MainUIState();
}

class MainUIState extends State<MainUI>{
  @override
  Widget build(BuildContext context){
    var cdr = CDR.of(context);
    cdr.postInit(context);
    return MaterialApp(
      navigatorKey: cdr.navKey,
      theme: ThemeData.light().copyWith(primaryColor: Colors.purple),
      darkTheme: ThemeData.dark().copyWith(primaryColor: Colors.purple),
      navigatorObservers: [
        cdr.observatory
      ],
      onGenerateTitle: (context) => AppLocalizations.of(context)!.cdr,
      builder: (context, child) => Frame(key: cdr.frameKey, child: child ?? const Text("uh oh")),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      onGenerateRoute: (settings) {
        Widget? widy;
        RouteSettings? newSettings;
        switch(settings.name){
        case "/settings":
          widy = const Settings();
          break;
        case "/calculator":
          widy = DiceCalculator();
          break;
        case "/intro":
          widy = DiceCalculator();
          break;
        case "/dieList":
          //TODO
        case "/groupList":
          //TODO
        default:
          //TODO: Allow for setting default screen
          widy = DiceCalculator();
          newSettings = const RouteSettings(name: "/calculator");
        }
        return PageRouteBuilder(
          settings: newSettings ?? settings,
          pageBuilder: (context, animation, secondaryAnimation) {
            return widy!;
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: animation,
              child: child,
            ),
        );
      },
      initialRoute: "/",
    );
  }
}