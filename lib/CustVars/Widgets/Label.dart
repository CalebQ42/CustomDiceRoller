import 'package:customdiceroller/CustVars/Widgets/SelfAwareWidget.dart';
import 'package:flutter/material.dart';

class Label extends SelfAwareWidget{
  String text;

  Label(this.text);

  void setText(String text){
    this.text = text;
    stateChanged();
  }
  Widget build() => new Text(text);
}

//new Text("yo",Key:,TextStyle,TextAlign,TextDirection,bool,TextOveflow,double,int)