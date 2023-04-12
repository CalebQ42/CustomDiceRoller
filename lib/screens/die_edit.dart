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
  bool nameConflict = false;
  bool noName = false;

  @override
  Widget build(BuildContext context) {
    var cdr = CDR.of(context);
    nameController ??= TextEditingController(text: widget.d.title)
        ..addListener(() async {
          if(nameController!.text == ""){
            setState(() => noName = true);
            return;
          }else if(noName){
            setState(() => noName = false);
          }
          var d = await cdr.db.dies.getByTitle(nameController!.text);
          if(d != null && d.id != widget.d.id){
            setState(() => nameConflict = true);
          }else{
            if(nameConflict) setState(() => nameConflict = false);
            widget.d.title = nameController!.text;
            widget.d.save(cdr: cdr);
          }
        });
    return FrameContent(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
            decoration: InputDecoration(
              labelText: "Die Name",
              errorText: noName ? cdr.locale.mustName : nameConflict ? cdr.locale.dieUniqueName : null
            ),
            textCapitalization: TextCapitalization.words,
            controller: nameController,
          )
          )
        ],
      )
    );
  }
}