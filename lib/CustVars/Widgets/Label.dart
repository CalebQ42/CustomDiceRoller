import 'package:flutter/material.dart';

class Label extends StatefulWidget{
  String text;
  TextStyle style;
  Label(this.text,{this.style});
  void setText(String text){
    this.text = text;
  }
  String getText()=>text;
  @override
  State<StatefulWidget> createState() => new _LabelState(text,style:style);
}

class _LabelState extends State<Label>{
  String text;
  TextStyle style;
  _LabelState(this.text,{this.style});
  @override
  Widget build(BuildContext context)=> new Text(text,style:style);

  @override
  void didUpdateWidget(Label oldWidget) {
    if(oldWidget.text != widget.text){
      setState((){
        this.text = widget.text;
      });
    }
    super.didUpdateWidget(oldWidget);
  }
}

//new Text("yo",Key:,TextStyle,TextAlign,TextDirection,bool,TextOveflow,double,int)