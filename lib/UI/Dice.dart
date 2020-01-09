import 'package:customdiceroller/CDR.dart';
import 'package:customdiceroller/CustVars/Widgets/Label.dart';
import 'package:customdiceroller/UI/Common.dart';
import 'package:customdiceroller/UI/DieEdit.dart';

import 'package:flutter/material.dart';

class Dice extends StatelessWidget{
  final CDR cdr;
  Dice(this.cdr);
  Widget build(BuildContext context) {
    print(cdr.getDies("").length);
    return new Scaffold(
      appBar: new MyAppBar(
        title: new Label("Dice")
      ).build(context),
      drawer: new MyNavDrawer(context),
      body: new ListView.builder(
        padding: EdgeInsets.all(5),
        itemCount: cdr.getDies("").length,
        itemBuilder: (BuildContext bc, int i){
          return Padding(
            padding: EdgeInsets.all(3),
            child: Card(
              child: InkResponse(
                highlightShape: BoxShape.rectangle,
                containedInkWell: true,
                splashFactory: Theme.of(context).splashFactory,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(child: Text(cdr.getDies("")[i].getName(),style: Theme.of(context).textTheme.title,),),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return DieEdit(cdr, cdr.getDies("")[i]);
                  }));
                },
              )
            )
          );
        },
      )
    );
  }
}