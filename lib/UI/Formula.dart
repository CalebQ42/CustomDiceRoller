import 'package:customdiceroller/CDR.dart';
import 'package:customdiceroller/CustVars/Widgets/Label.dart';
import 'package:customdiceroller/UI/Common.dart';
import 'package:flutter/material.dart';

class Formula extends StatelessWidget{
  final CDR cdr;
  final BuildContext context;
  Formula(this.cdr, this.context);
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new MyAppBar(
        title: new Label("Dice Formula")
      ).build(context) as PreferredSizeWidget,
      drawer: new MyNavDrawer(context),
      body: new Center(
        child: new Label("Formula"),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Transform.rotate(
          angle: 45.0,
          child: const Icon(Icons.casino)
        ),
        onPressed: null
      ),
    );
  }

}