import 'package:flutter/material.dart';

class Label extends StatefulWidget{
  final String text;
  final TextStyle style;
  Label(this.text,{this.style});
  @override
  State<StatefulWidget> createState() => new _LabelState(text,style:style);
}

class _LabelState extends State<Label>{
  String text;
  TextStyle style;
  _LabelState(this.text,{this.style});
  void setText(String txt){
    setState((){
      this.text = txt;
    });
  }
  @override
  Widget build(BuildContext context)=> new Text(text,style:style);
}

//new Text("yo",Key:,TextStyle,TextAlign,TextDirection,bool,TextOveflow,double,int)