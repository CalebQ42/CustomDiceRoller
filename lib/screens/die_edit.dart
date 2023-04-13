import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/dialogs/simple.dart';
import 'package:customdiceroller/dice/dice.dart';
import 'package:customdiceroller/ui/frame_content.dart';
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
  bool invalidCharacter = false;
  GlobalKey<FrameSpeedDialState> fabKey = GlobalKey();
  GlobalKey<AnimatedListState> listKey = GlobalKey();
  TextEditingController stuff = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var cdr = CDR.of(context);
    widget.d.sides = widget.d.sides.toList();
    nameController ??= TextEditingController(text: widget.d.title)
        ..addListener(() async {
          if(nameController!.text == ""){
            setState(() => noName = true);
            return;
          }else if(noName){
            setState(() => noName = false);
          }
          if(nameController!.text.contains("{") || nameController!.text.contains("}")){
            setState(() => invalidCharacter = true);
            return;
          }else if(invalidCharacter){
            setState(() => invalidCharacter = false);
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
      fab: FrameSpeedDial(
        key: fabKey,
        children: [
          SpeedDialIcons(
            onPressed: () =>
              SimpleSideDialog(
                s: Side(),
                onClose: (s){
                  widget.d.sides.add(s);
                  listKey.currentState?.insertItem(widget.d.sides.length-1);
                  widget.d.save(cdr: cdr);
                },
              ).show(context),
            label: cdr.locale.simple,
            child: const Icon(Icons.add_box_rounded),
          ),
          SpeedDialIcons(
            onPressed: () => print("Complex"),
            label: cdr.locale.complex,
            child: const Icon(Icons.library_add_rounded),
          )
        ]
      ),
      fabKey: fabKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                autofocus: widget.d.title == cdr.locale.newDie,
                decoration: InputDecoration(
                  labelText: cdr.locale.dieName,
                  errorText: noName ? cdr.locale.mustName : invalidCharacter ? cdr.locale.dieInvalidCharacter : nameConflict ? cdr.locale.dieUniqueName : null
                ),
                textCapitalization: TextCapitalization.words,
                controller: nameController,
              )
            ),
            AnimatedList(
              key: listKey,
              shrinkWrap: true,
              initialItemCount: widget.d.sides.length,
              itemBuilder:(context, index, animation) =>
                Dismissible(
                  key: ValueKey<Side>(widget.d.sides[index]),
                  direction: cdr.prefs.swipeDelete() ? DismissDirection.horizontal : DismissDirection.none,
                  child: sideCard(context, index),
                  onDismissed: (_){
                    widget.d.sides.removeAt(index);
                    widget.d.save(cdr: cdr);
                    listKey.currentState?.removeItem(index, (context, animation) =>
                      SizeTransition(sizeFactor: animation));
                  },
                )
            )
          ],
        )
      )
    );
  }

  Widget sideCard(BuildContext context, int index) =>
    Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          InkResponse(
            containedInkWell: true,
            highlightShape: BoxShape.rectangle,
            onTap: () =>
              SimpleSideDialog(
                s: widget.d.sides[index],
                onClose: (s){
                  widget.d.sides[index] = s;
                  widget.d.save(context: context);
                }
              ).show(context),
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: Icon(Icons.edit)
            )
          ),
          Container(width: 10),
          Expanded(
            child: Text(
              widget.d.sides[index].toString(),
              style: Theme.of(context).textTheme.headlineSmall
            )
          ),
          if(CDR.of(context).prefs.deleteButton()) InkResponse(
            containedInkWell: true,
            highlightShape: BoxShape.rectangle,
            onTap: (){
              widget.d.sides.removeAt(index);
              widget.d.save(context: context);
              listKey.currentState?.removeItem(index, (context, animation) =>
                SizeTransition(sizeFactor: animation));
            },
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: Icon(Icons.delete_forever)
            )
          ),
        ]
      )
    );
}