import 'package:customdiceroller/CDR.dart';
import 'package:customdiceroller/CustVars/Widgets/Label.dart';
import 'package:customdiceroller/UI/Common.dart';

import 'package:flutter/material.dart';

class Dice extends StatelessWidget{
  final CDR cdr;
  Dice(this.cdr);
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