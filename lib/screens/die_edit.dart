import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/dialogs/complex.dart';
import 'package:customdiceroller/dialogs/simple.dart';
import 'package:customdiceroller/dice/dice.dart';
import 'package:darkstorm_common/frame_content.dart';
import 'package:darkstorm_common/speed_dial.dart';
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
  GlobalKey<SpeedDialState> speedDialKey = GlobalKey();
  GlobalKey<AnimatedListState> listKey = GlobalKey();
  TextEditingController stuff = TextEditingController();
  ScrollController listCont = ScrollController();

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
      fab: SpeedDial(
        key: speedDialKey,
        children: [
          SpeedDialIcons(
            onPressed: () =>
              SimpleSideDialog(
                hints: widget.d.hints,
                onClose: (s){
                  widget.d.sides.add(s);
                  listKey.currentState?.insertItem(widget.d.sides.length-1);
                  widget.d.save(cdr: cdr);
                  listCont.animateTo(
                    listCont.position.maxScrollExtent + 90,
                    duration: cdr.globalDuration,
                    curve: Curves.easeIn
                  );
                },
              ).show(context),
            label: cdr.locale.simple,
            child: const Icon(Icons.add_box_rounded),
          ),
          SpeedDialIcons(
            onPressed: () =>
              ComplexDialog(
                hints: widget.d.hints,
                onClose: (s){
                  widget.d.sides.add(s);
                  listKey.currentState?.insertItem(widget.d.sides.length-1);
                  widget.d.save(cdr: cdr);
                  listCont.animateTo(
                    listCont.position.maxScrollExtent + 90,
                    duration: cdr.globalDuration,
                    curve: Curves.easeIn
                  );
                },
              ).show(context),
            label: cdr.locale.complex,
            child: const Icon(Icons.library_add_rounded),
          )
        ]
      ),
      speedDialKey: speedDialKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              autofocus: widget.d.title == cdr.locale.newDie,
              decoration: InputDecoration(
                labelText: cdr.locale.dieName,
                errorText: noName ? cdr.locale.mustName : invalidCharacter ? cdr.locale.dieInvalidCharacter : nameConflict ? cdr.locale.dieUniqueName : null
              ),
              style: Theme.of(context).textTheme.titleLarge,
              textCapitalization: TextCapitalization.words,
              controller: nameController,
            )
          ),
          Expanded(
            child: AnimatedList(
              key: listKey,
              controller: listCont,
              initialItemCount: widget.d.sides.length + 1,
              itemBuilder:(context, index, animation) =>
                index != widget.d.sides.length ? Dismissible(
                  key: ValueKey<Side>(widget.d.sides[index]),
                  direction: cdr.prefs.swipeDelete() ? DismissDirection.horizontal : DismissDirection.none,
                  child: sideCard(context, index),
                  onDismissed: (_){
                    //TODO: Undo
                    widget.d.sides.removeAt(index);
                    widget.d.save(cdr: cdr);
                    listKey.currentState?.removeItem(index, (context, animation) =>
                      SizeTransition(sizeFactor: animation));
                  },
                ) : Container(height: 70)
            )
          ),
        ],
      )
    );
  }

  Widget sideCard(BuildContext context, int index) =>
    Card(
      child: InkResponse(
        containedInkWell: true,
        highlightShape: BoxShape.rectangle,
        onTap: () {
          if(widget.d.sides[index].isSimple()){
            SimpleSideDialog(
              s: widget.d.sides[index],
              hints: widget.d.hints,
              onClose: (s){
                widget.d.sides[index] = s;
                widget.d.save(context: context);
                listKey.currentState?.setState(() {});
              },
              updating: true,
            ).show(context);
          }else{
            ComplexDialog(
              s: widget.d.sides[index],
              hints: widget.d.hints,
              onClose: (s){
                widget.d.sides[index] = s;
                widget.d.save(context: context);
                listKey.currentState?.setState(() {});
              },
              updating: true,
            ).show(context);
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  widget.d.sides[index].editDisplayString(),
                  style: Theme.of(context).textTheme.headlineSmall
                )
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
      )
    );
}