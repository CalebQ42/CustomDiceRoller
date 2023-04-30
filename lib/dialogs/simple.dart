import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/dialogs/complex.dart';
import 'package:customdiceroller/dice/dice.dart';
import 'package:darkstorm_common/bottom.dart';
import 'package:flutter/material.dart';

class SimpleSideDialog{
  final TextEditingController txt;
  final Side s;
  final bool updating;
  final void Function(Side) onClose;

  SimpleSideDialog({
    required this.s,
    required this.onClose,
    this.updating = false,
  }) : txt = TextEditingController(text: s.toString());

  void close(String value, BuildContext context){
    if(value == "") return;
    var prs = int.tryParse(txt.text);
    if(prs == null){
      onClose(Side.simple(txt.text));
    }else{
      onClose(Side.number(prs));
    }
    CDR.of(context).nav.pop();
  }

  void show(BuildContext context) {
    var bot = Bottom(
      child: (c) => Padding(
        padding: const EdgeInsets.all(10),
        child: TextField(
          controller: txt,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          autocorrect: true,
          onSubmitted: (value) =>
            close(value, context),
        ),
      ),
      buttons: (c) => [
        TextButton(
          onPressed: () {
            CDR.of(context).nav.pop();
            ComplexDialog(
              onClose: onClose,
              s: s,
              updating: updating,
            ).show(context);
          },
          child: Text(CDR.of(c).locale.toComplex)
        ),
        const Spacer(),
        TextButton(
          onPressed: () =>
            CDR.of(c).nav.pop(),
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