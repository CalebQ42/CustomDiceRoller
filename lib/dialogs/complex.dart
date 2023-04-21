import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/dice/dice.dart';
import 'package:customdiceroller/ui/bottom.dart';
import 'package:flutter/material.dart';

class ComplexDialog extends StatelessWidget{
  final Side s;
  final bool updating;
  final void Function(Side) onClose;
  final GlobalKey<AnimatedListState> listKey = GlobalKey();

  final List<UniqueKey> partKeys;

  ComplexDialog({
    super.key,
    required this.s,
    required this.onClose,
    this.updating = false
  }) : partKeys = List.generate(s.parts.length, (index) => UniqueKey()){
    s.parts = s.parts.toList();
  }

  @override
  Widget build(BuildContext context) =>
    AnimatedSize(
      duration: CDR.of(context).globalDuration,
      alignment: Alignment.topCenter,
      child: AnimatedList(
        key: listKey,
        shrinkWrap: true,
        primary: false,
        initialItemCount: s.parts.length,
        itemBuilder: (c, i, anim) =>
          ComplexPart(
            key: partKeys[i],
            init: s.parts[i],
            onNameChange: (n) => s.parts[i].name = n,
            onValueChange: (v) => s.parts[i].value = v,
            onDelete: () {
              s.parts.removeAt(i);
              listKey.currentState?.removeItem(
                i,
                (context, animation) => SizeTransition(sizeFactor: anim),
                duration: CDR.of(context).globalDuration
              );
            }
          ),
      )
    );

  void show(BuildContext context) =>
    Bottom(
      child: (c) => this,
      scroll: false,
      buttons: (c) => [
        TextButton(
          onPressed: () {
            s.parts.add(SidePart());
            partKeys.add(UniqueKey());
            listKey.currentState?.insertItem(
              s.parts.length-1,
              duration: CDR.of(context).globalDuration
            );
          },
          child: Text(CDR.of(c).locale.addPart),
        ),
        const Spacer(),
        TextButton(
          onPressed: () =>
            CDR.of(c).nav?.pop(),
          child: Text(CDR.of(c).locale.cancel)
        ),
        TextButton(
          onPressed: () => onClose(s),
          child: Text(updating ? CDR.of(c).locale.update : CDR.of(context).locale.add)
        ),
      ],
    ).show(context);
}

class ComplexPart extends StatefulWidget{
  final void Function(String) onNameChange;
  final void Function(int) onValueChange;
  final void Function() onDelete;
  final SidePart init;

  const ComplexPart({
    super.key,
    required this.init,
    required this.onNameChange,
    required this.onValueChange,
    required this.onDelete
  });

  @override
  State<StatefulWidget> createState() => _PartState();
}

class _PartState extends State<ComplexPart>{
  bool isNum = false;
  int value = 0;

  TextEditingController? cont;

  @override
  void initState() {
    isNum = widget.init.name == "";
    value = widget.init.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cont ??= TextEditingController(text: widget.init.nameOrValue())
      ..addListener(() {
        int? prs;
        if(cont!.text != "") prs = int.tryParse(cont!.text);
        if(prs == null){
          widget.onNameChange(cont!.text);
          if(isNum){
            widget.onValueChange(1);
            setState(() {
              value = 1;
              isNum = false;
            });
          }
        }else{
          widget.onValueChange(prs);
          if(!isNum){
            widget.onNameChange("");
            setState((){
              isNum = true;
            });
          }
        }
      });
    return InputDecorator(
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
              height: 45,
              child: ListWheelScrollView.useDelegate(
                itemExtent: 20,
                controller: FixedExtentScrollController(initialItem: value+99),
                physics: FixedExtentScrollPhysics(),
                overAndUnderCenterOpacity: .5,
                onSelectedItemChanged: (v) => widget.onValueChange(v-99),
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
    );
  }
}