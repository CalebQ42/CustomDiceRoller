import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/dice/dice.dart';
import 'package:customdiceroller/ui/frame.dart';
import 'package:flutter/material.dart';

class DieEdit extends StatefulWidget{

  final Die d;

  const DieEdit(this.d, {super.key});

  @override
  State<DieEdit> createState() => _DieEditState();
}

class _DieEditState extends State<DieEdit> {
  TextEditingController? nameController;

  @override
  Widget build(BuildContext context) {
    var cdr = CDR.of(context);
    nameController ??= TextEditingController(text: widget.d.title)
        ..addListener(() {
          widget.d.title = nameController!.text;
          widget.d.save(cdr: cdr);
        });
    return FrameContent(
      child: Column(
        children: [
          TextField(
            textCapitalization: TextCapitalization.words,
            controller: nameController,
          )
        ],
      )
    );
  }
}