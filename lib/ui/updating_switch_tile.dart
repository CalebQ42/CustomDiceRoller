import 'package:flutter/material.dart';


class UpdatingSwitchTile extends StatefulWidget{

  final bool value;
  final void Function(bool) onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? title;

  const UpdatingSwitchTile({required this.value, required this.onChanged, this.title, this.contentPadding, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => UpdatingSwitchTileState();
}

class UpdatingSwitchTileState extends State<UpdatingSwitchTile>{

  late bool value;

  @override
  void initState(){
    super.initState();
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) =>
    SwitchListTile(
      value: value,
      title: widget.title,
      contentPadding: widget.contentPadding,
      onChanged: (b){
        widget.onChanged(b);
        setState(() => value = b);
      }
    );
}

class UpdatingSwitch extends StatefulWidget{
  
  final bool value;
  final Function(bool) onChanged;

  const UpdatingSwitch({required this.value, required this.onChanged, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => UpdatingSwitchState();
}

class UpdatingSwitchState extends State<UpdatingSwitch>{

  late bool value;

  @override
  void initState(){
    super.initState();
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) =>
    Switch(
      value: value,
      onChanged: (b){
        widget.onChanged(b);
        setState(() => value = b);
      }
    );
}