import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/dice/dice.dart';
import 'package:customdiceroller/ui/bottom.dart';
import 'package:flutter/material.dart';

class SimpleSideDialog extends StatelessWidget{
  
  final TextEditingController txt;
  final Side s;
  final bool updating;
  final void Function(Side) onClose;

  SimpleSideDialog({
    super.key,
    required this.s,
    required this.onClose,
    this.updating = false,
  }) : txt = TextEditingController(text: s.toString());
  
  @override
  Widget build(BuildContext context) =>
    Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: txt,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        autocorrect: true,
        onSubmitted: (value) =>
          close(value, context),
      ),
    );

  void close(String value, BuildContext context){
    if(value == "") return;
    var prs = int.tryParse(txt.text);
    if(prs == null){
      onClose(Side.simple(txt.text));
    }else{
      onClose(Side.number(prs));
    }
    CDR.of(context).nav?.pop();
  }

  void show(BuildContext context) {
    var bot = Bottom(
      child: (c) => this,
      buttons: (c) => [
        TextButton(
          onPressed: () =>
            CDR.of(c).nav?.pop(),
          child: Text(CDR.of(c).locale.cancel)
        ),
        TextButton(
          onPressed: txt.text != "" ? () =>
            close(txt.text, c): null,
          child: Text(updating ? CDR.of(c).locale.update : CDR.of(context).locale.add)
        ),
      ],
    );
    txt.addListener(() => bot.updateButtons());
    bot.show(context);
  }
}