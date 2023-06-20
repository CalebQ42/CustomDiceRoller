import 'dart:async';
import 'dart:math';

import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/dice/dice.dart';
import 'package:customdiceroller/screens/calculator.dart';
import 'package:customdiceroller/screens/dice_list.dart';
import 'package:customdiceroller/screens/die_edit.dart';
import 'package:customdiceroller/screens/intro_pages.dart';
import 'package:customdiceroller/screens/loading.dart';
import 'package:customdiceroller/screens/settings.dart';
import 'package:darkstorm_common/frame.dart';
import 'package:darkstorm_common/intro.dart';
import 'package:darkstorm_common/nav.dart';
import 'package:darkstorm_common/top_inherit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stupid/stupid.dart';

CDR? cdr;

void main() =>
  runZonedGuarded(
    () {
      CDR.initialize().then(
        (value) {
          cdr = value;
          runApp(
            TopInherit(
              resources: value,
              child: const MainUI()
            )
          );
        }
      );
    },
    (error, stack) {
      if(kDebugMode){
        print(error);
        print(stack);
      }
      if(cdr!.prefs.crash()){
        cdr?.stupid?.crash(Crash(
          error: error.toString(),
          stack: stack.toString(),
        ));
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
    return MaterialApp(
      themeAnimationDuration: cdr.globalDuration,
      navigatorKey: cdr.navKey,
      theme: ThemeData.light().copyWith(
        colorScheme: const ColorScheme.light(
          primary: Colors.purple,
          secondary: Colors.orangeAccent
        ),
        primaryColor: Colors.purple,
        snackBarTheme: snackTheme,
        inputDecorationTheme: inputTheme,
        bottomSheetTheme: bottomSheetTheme,
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          shadow: Colors.white,
          primary: Colors.purple,
          secondary: Colors.orangeAccent
        ),
        primaryColor: Colors.purple,
        snackBarTheme: snackTheme,
        inputDecorationTheme: inputTheme,
        bottomSheetTheme: bottomSheetTheme,
      ),
      themeMode:
        cdr.prefs.darkTheme() ?
          ThemeMode.dark :
        cdr.prefs.lightTheme() ?
          ThemeMode.light :
        ThemeMode.system,
      navigatorObservers: [
        cdr.observatory
      ],
      onGenerateTitle: (context) => AppLocalizations.of(context)!.cdr,
      builder: (context, child) =>
        Frame(
          key: cdr.frameKey,
          beveled: false,
          appName: AppLocalizations.of(context)!.cdr,
          navItems: [
            Nav(
              icon: const Icon(Icons.calculate),
              name: AppLocalizations.of(context)!.calculator,
              routeName: "/calculator"
            ),
            Nav(
              icon: Transform.rotate(
                angle: pi * 1/4,
                child: const Icon(Icons.casino)
              ),
              name: AppLocalizations.of(context)!.dice,
              routeName: "/dieList"
            ),
          ],
          bottomNavItems: [
            Nav(
              icon: const Icon(Icons.settings),
              name: AppLocalizations.of(context)!.settings,
              routeName: "/settings",
              lastItem: true,
            )
          ],
          hideBar: (routeName) => routeName == "/loading" || routeName == "/intro",
          child: child ?? const Text("This is borken"),
        ),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      onGenerateRoute: (settings) {
        Widget? widy;
        RouteSettings? newSettings;
        if(!cdr.prefs.shownIntro()){
          widy = IntroScreen(
            pages: Intro().pages(),
            onDone: (){
              cdr.prefs.setShownIntro(true);
              cdr.nav.pushNamedAndRemoveUntil(settings.name ?? "/", (route) => false);
            },
          );
          newSettings = const RouteSettings(name: "/intro");
        }else{
          if(!cdr.initilized){
            widy = LoadingScreen(startingRoute: newSettings ?? settings, cdr: cdr);
            newSettings = const RouteSettings(name: "/loading");
          }else if((settings.name?.startsWith("/die/") ?? false) && settings.name!.length > 5){
            Die? d;
            if(settings.arguments == null){
              d = cdr.db.dies.getByUuidSync(settings.name!.substring(5));
            }else{
              d = settings.arguments as Die?;
            }
            if(d != null){
              widy = DieEdit(d);
            }
          }else{
            switch(settings.name){
            case "/settings":
              widy = const Settings();
              break;
            case "/calculator":
              widy = const DiceCalculator();
              break;
            case "/dieList":
              widy = const DieList();
              break;
            }
          }
          if(widy == null){
            //TODO: Allow settings default screen
            widy = const DiceCalculator();
            newSettings = const RouteSettings(name: "/calculator");
          }
        }
        return PageRouteBuilder(
          settings: newSettings ?? settings,
          pageBuilder: (context, animation, secondaryAnimation) {
            return widy!;
          },
          maintainState: false,
          transitionDuration: cdr.globalDuration,
          reverseTransitionDuration: cdr.globalDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero
              ).animate(animation),
              child: child,
            ),
        );
      },
      initialRoute: "/",
    );
  }
}