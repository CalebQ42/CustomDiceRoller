import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/dice/dice.dart';
import 'package:customdiceroller/ui/bottom.dart';
import 'package:flutter/material.dart';

class SimpleSideDialog extends StatelessWidget{
  
  final TextEditingController txt = TextEditingController();
  final Side s;
  final void Function(Side) onClose;

  SimpleSideDialog({super.key, required this.s, required this.onClose});
  
  @override
  Widget build(BuildContext context) =>
    Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: txt,
      ),
    );

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
          onPressed: txt.text != "" ? () {
            var prs = int.tryParse(txt.text);
            if(prs == null){
              onClose(Side.simple(txt.text));
            }else{
              onClose(Side.number(prs));
            }
            CDR.of(c).nav?.pop();
          } : null,
          child: Text(CDR.of(c).locale.add)
        ),
      ],
    );
    txt.addListener(() => bot.updateButtons());
    bot.show(context);
  }
}