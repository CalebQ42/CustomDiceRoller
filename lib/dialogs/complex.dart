import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/dice/dice.dart';
import 'package:darkstorm_common/bottom.dart';
import 'package:flutter/material.dart';

class ComplexDialog{
  final Side s;
  final bool updating;
  final void Function(Side) onClose;

  final List<UniqueKey> partKeys;

  ComplexDialog({
    Side? s,
    required this.onClose,
    this.updating = false
  }) :
    s = s == null ? Side() : Side.copy(s),
    partKeys = List.generate(s != null ? s.parts.length : 0, (index) => UniqueKey());

  void show(BuildContext context) {
    Bottom? bot;
    bot = Bottom(
      itemBuilderCount: s.parts.length,
      itemBuilder: (c, i, anim) =>
        SizeTransition(
          axisAlignment: -1.0,
          sizeFactor: anim,
          child: ComplexPart(
            key: partKeys[i],
            s: s.parts[i],
            onDelete: () {
              s.parts.removeAt(i);
              bot?.listKey.currentState?.removeItem(
                i,
                (context, animation) => SizeTransition(sizeFactor: anim),
                duration: CDR.of(context).globalDuration
              );
            }
          )
        ),
      buttons: (c) => [
        TextButton(
          onPressed: () {
            s.parts.add(SidePart(value: 0));
            partKeys.add(UniqueKey());
            bot?.listKey.currentState?.insertItem(
              s.parts.length-1,
              duration: CDR.of(context).globalDuration
            );
          },
          child: Text(CDR.of(c).locale.addPart),
        ),
        TextButton(
          onPressed: () =>
            CDR.of(c).nav.pop(),
          child: Text(CDR.of(c).locale.cancel)
        ),
        TextButton(
          onPressed: () {
            s.parts.removeWhere((p) => p.name == "" && (p.value == 0));
            CDR.of(context).nav.pop();
            onClose(s);
          },
          child: Text(updating ? CDR.of(c).locale.update : CDR.of(context).locale.add)
        ),
      ],
    );
    bot.show(context);
  }
}

class ComplexPart extends StatefulWidget{
  final SidePart s;
  final void Function() onDelete;

  const ComplexPart({
    super.key,
    required this.s,
    required this.onDelete
  });

  @override
  State<StatefulWidget> createState() => _PartState();
}

class _PartState extends State<ComplexPart>{
  bool isNum = false;

  TextEditingController? cont;

  @override
  void initState() {
    isNum = widget.s.name == "" && widget.s.value != 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cont ??= TextEditingController(text: (){
      if(widget.s.name != "" || widget.s.value != 0) return widget.s.nameOrValue();
      widget.s.value = 1;
      return "";
    }())
      ..addListener(() {
        int? prs;
        if(cont!.text != "") prs = int.tryParse(cont!.text);
        if(prs == null){
          widget.s.name = cont!.text;
          if(isNum){
            widget.s.value = 1;
            setState(() {
              isNum = false;
            });
          }
        }else{
          widget.s.value = prs;
          if(!isNum){
            widget.s.name = "";
            setState((){
              isNum = true;
            });
          }
        }
      });
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InputDecorator(
        decoration: const InputDecoration(),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: widget.onDelete,
            ),
            Expanded(
              child: TextField(
                decoration: null,
                controller: cont,
                textCapitalization: TextCapitalization.words,
              ),
            ),
            AnimatedSwitcher(
              duration: CDR.of(context).globalDuration,
              child: isNum ? null : SizedBox(
                width: 50,
                height: 40,
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 20,
                  controller: FixedExtentScrollController(initialItem: widget.s.value+99),
                  physics: const FixedExtentScrollPhysics(),
                  overAndUnderCenterOpacity: .5,
                  onSelectedItemChanged: (v) => widget.s.value = v-99,
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: 199,
                    builder: (context, i) =>
                      Center(child: Text((i-99).toString()))
                  ),
                ),
              ),
              transitionBuilder: (child, anim) =>
                ClipRect(
                  child: SizeTransition(
                    axis: Axis.horizontal,
                    sizeFactor: anim,
                    child: child
                  )
                ),
              )
          ],
        ),
      )
    );
  }
}