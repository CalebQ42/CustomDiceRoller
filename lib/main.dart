import 'dart:async';

import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/screens/settings.dart';
import 'package:customdiceroller/screens/frame.dart';
import 'package:customdiceroller/ui/die_edit.dart';
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
      onGenerateTitle: (context) => AppLocalizations.of(context)!.cdr,
      builder: (context, child) => Frame(child: child),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      onGenerateRoute: (settings) {
        if(settings.name == "/settings"){
          return MaterialPageRoute(
            builder: (context){
              return const Settings();
            }
          );
        }
        return MaterialPageRoute(
            builder: (context){
              return const DieEdit();
            }
          );
      },
      initialRoute: "/",
    );
  }
}