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
  final List<String> hints;

  SimpleSideDialog({
    Side? s,
    required this.onClose,
    required this.hints,
    this.updating = false,
  }) : s = s ?? Side(), txt = TextEditingController(text: (s ?? Side()).toString());

  void close(BuildContext context){
    var val = txt.text.trim();
    if(val.isEmpty){
      onClose(Side());
    }else{
      var prs = int.tryParse(val);
      if(prs == null){
        onClose(Side.simple(val));
      }else{
        onClose(Side.number(prs));
      }
    }
    CDR.of(context).nav.pop();
  }

  void show(BuildContext context) {
    var bot = Bottom(
      child: (c) => TextField(
          controller: txt,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          autofillHints: hints,
          onSubmitted: (value) =>
            close(c),
        ),
      buttons: (c) => [
        TextButton(
          onPressed: () {
            CDR.of(context).nav.pop();
            ComplexDialog(
              onClose: onClose,
              hints: hints,
              s: s,
              updating: updating,
            ).show(context);
          },
          child: Text(CDR.of(c).locale.toComplex)
        ),
        TextButton(
          onPressed: () =>
            CDR.of(c).nav.pop(),
          child: Text(CDR.of(c).locale.cancel)
        ),
        TextButton(
          onPressed: () =>
            close(c),
          child: Text(updating ? CDR.of(c).locale.update : CDR.of(context).locale.add)
        ),
      ],
    );
    txt.addListener(() => bot.updateButtons());
    bot.show(context);
  }
}