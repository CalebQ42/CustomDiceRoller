import 'package:customdiceroller/CDR.dart';
import 'package:customdiceroller/CustVars/Widgets/Label.dart';
import 'package:customdiceroller/UI/Common.dart';
import 'package:flutter/material.dart';

class Dice extends StatelessWidget{
  final CDR cdr;
  final BuildContext context;
  Dice(this.cdr, this.context);
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new MyAppBar(
        title: new Label("Dice")
      ).build(context) as PreferredSizeWidget,
      drawer: new MyNavDrawer(context),
      body: new Center(
        child: new Label("Dice"),
      )
    );
  }

}