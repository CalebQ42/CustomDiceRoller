import 'package:customdiceroller/CDR.dart';
import 'package:customdiceroller/CustVars/Widgets/Label.dart';
import 'package:customdiceroller/UI/Common.dart';

import 'package:flutter/material.dart';

class Groups extends StatelessWidget{
  final CDR cdr;
  Groups(this.cdr);
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new MyAppBar(
        title: new Label("Groups")
      ).build(context),
      drawer: new MyNavDrawer(context),
      body: new Center(
        child: new Label("Groups"),
      )
    );
  }
}