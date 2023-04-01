import 'dart:async';

import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/screens/calculator.dart';
import 'package:customdiceroller/screens/loading.dart';
import 'package:customdiceroller/screens/settings.dart';
import 'package:customdiceroller/ui/frame.dart';
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
    cdr.topLevelUpdate = () => setState(() {});
    const snackTheme = SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
    );
    const inputTheme = InputDecorationTheme(
      border: OutlineInputBorder(),
    );
    var bottomSheetTheme = BottomSheetThemeData(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      clipBehavior: Clip.antiAlias,
      constraints: BoxConstraints.loose(const Size.fromWidth(600)),
    );
    var fabTheme = const FloatingActionButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25))
      )
    );
    return MaterialApp(
      navigatorKey: cdr.navKey,
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.purple,
        snackBarTheme: snackTheme,
        inputDecorationTheme: inputTheme,
        bottomSheetTheme: bottomSheetTheme,
        floatingActionButtonTheme: fabTheme
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.purple,
        snackBarTheme: snackTheme,
        inputDecorationTheme: inputTheme,
        bottomSheetTheme: bottomSheetTheme,
        floatingActionButtonTheme: fabTheme
      ),
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
        if(!cdr.initilized){
          widy = LoadingScreen(startingRoute: newSettings ?? settings, cdr: cdr);
          newSettings = const RouteSettings(name: "/loading");
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