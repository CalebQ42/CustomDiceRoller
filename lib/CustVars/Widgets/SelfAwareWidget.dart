import 'package:flutter/material.dart';

abstract class SelfAwareWidget extends StatefulWidget{
  SelfAwareState _state;

  State<StatefulWidget> createState(){
    _state = new SelfAwareState();
    return _state;
  }
  void stateChanged(){
    if(_state!=null)
      _state.setState((){});
  }
  Widget build();
}

class SelfAwareState extends State<SelfAwareWidget>{
  @override
  Widget build(BuildContext context) {
    return this.widget.build();
  }
}