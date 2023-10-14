import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/dialogs/history.dart';
import 'package:customdiceroller/dice/dice.dart';
import 'package:customdiceroller/dice/formula.dart';
import 'package:darkstorm_common/bottom.dart';
import 'package:darkstorm_common/frame_content.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class DiceCalculator extends StatefulWidget{

  const DiceCalculator({super.key});

  @override
  State<DiceCalculator> createState() => _DiceCalculatorState();
}

class _DiceCalculatorState extends State<DiceCalculator> {
  String prevText = "";
  TextEditingController? displayCont;
  ScrollController displayScrollCont = ScrollController();

  void solve(){
    DiceFormula.solve(displayCont!.text, CDR.of(context)).showResults(context);
    CDR.of(context).prefs.addToHistory(displayCont!.text);
  }

  @override
  Widget build(BuildContext context) {
    var cdr = CDR.of(context);
    displayCont ??= TextEditingController()
      ..addListener(() {
        var curTxt = displayCont!.text;
        var curSel = displayCont!.selection;
        if(prevText.length < curTxt.length){
          if(curSel.baseOffset > 0 && curTxt.substring(curSel.baseOffset-1, curSel.baseOffset) == "{"){
            var bef = curSel.textBefore(curTxt);
            displayCont!.text = "$bef}${curSel.textAfter(curTxt)}";
            displayCont!.selection = TextSelection.collapsed(offset: bef.length);
          }
        }
        prevText = displayCont!.text;
      });
    var scrol = MediaQuery.sizeOf(context).height <= 325;
    return TextFieldTapRegion(
      child: FrameContent(
        fab: FloatingActionButton(
          onPressed: () => solve(),
          child: const Icon(Icons.casino),
        ),
        child: Center(
          child: SizedBox(
            width: 500,
            child: ListView(
              shrinkWrap: !scrol,
              children: [
                SizedBox(
                  height: 65,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10)
                    ),
                    isFocused: true,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            scrollController: displayScrollCont,
                            style: Theme.of(context).textTheme.headlineSmall,
                            autofocus: true,
                            readOnly: !cdr.prefs.allowKeyboard(),
                            showCursor: true,
                            controller: displayCont,
                            enableSuggestions: false,
                            autocorrect: false,
                            minLines: 1,
                            maxLines: 1,
                            decoration: null,
                            onSubmitted: (value) => solve(),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp("[0-9]|${CDR.of(context).locale.dieNotation}|\\+|-|{(.*?)}|({|})")),
                            ],
                          )
                        ),
                        InkResponse(
                          child: const SizedBox.square(
                            dimension: 65,
                            child: Center(child: Icon(Icons.backspace))
                          ),
                          onTap: (){
                            var sel = displayCont!.selection;
                            var bef = sel.textBefore(displayCont!.text);
                            var end = sel.textAfter(displayCont!.text);
                            var begBracket = RegExp("{").allMatches(bef).length;
                            var endBracket = RegExp("}").allMatches(bef).length;
                            if(begBracket > endBracket){
                              sel = sel.copyWith(baseOffset: bef.lastIndexOf("{"));
                              bef = sel.textBefore(displayCont!.text);
                            }
                            begBracket = RegExp("{").allMatches(end).length;
                            endBracket = RegExp("}").allMatches(end).length;
                            if(endBracket > begBracket){
                              sel = sel.copyWith(extentOffset: sel.extentOffset + end.indexOf("}") + 1);
                              end = sel.textAfter(displayCont!.text);
                            }
                            int selLoc = sel.baseOffset;
                            String outTxt = displayCont!.text;
                            if(!sel.isCollapsed){
                              outTxt = bef + end;
                              selLoc = bef.length;
                            }else if(bef != ""){
                              outTxt = bef.substring(0, bef.length-1) + end;
                              selLoc = bef.length-1;
                            }
                            var matches = RegExp("[0-9]|${CDR.of(context).locale.dieNotation}|\\+|-|{(.*?)}|({|})").allMatches(outTxt);
                            outTxt = "";
                            int prevEnd = 0;
                            for(var m in matches){
                              var txt = m.input.substring(m.start, m.end);
                              if(txt != "{" && txt != "}"){
                                outTxt += txt;
                                if(selLoc > prevEnd && selLoc <= m.start) selLoc = outTxt.length-1;
                                prevEnd = m.end;
                              }
                            }
                            if(selLoc > outTxt.length) selLoc = outTxt.length;
                            displayCont?.text = outTxt;
                            displayCont?.selection = TextSelection.collapsed(offset: selLoc);
                          },
                        )
                      ]
                    )
                  ),
                ),
                numPad(cdr, scrol),
              ],
            )
          )
        )
      )
    );
  }

  void addToDisplay(String value){
    var sel = displayCont!.selection;
    displayCont?.text = sel.textBefore(displayCont!.text) + value + sel.textAfter(displayCont!.text);
    if(displayCont!.text == value){
      displayCont?.selection = TextSelection.collapsed(offset: value.length);
    }else{
      displayCont?.selection = TextSelection.collapsed(offset: sel.baseOffset+value.length);
    }
    displayScrollCont.animateTo(
      displayScrollCont.position.maxScrollExtent * (displayCont!.selection.baseOffset / displayCont!.text.length) + 20,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear
    );
  }

  Widget numPad(CDR cdr, bool scrol){
    var children = [
      NumBar(
        addToDisplay: addToDisplay,
        values: const ["1", "2", "3", "+"]
      ),
      NumBar(
        addToDisplay: addToDisplay,
        values: const ["4", "5", "6", "-"]
      ),
      NumBar(
        addToDisplay: addToDisplay,
        values: ["7", "8", "9", cdr.locale.dieNotation]
      ),
      SizedBox(
        height: 65,
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 65,
                child: InkResponse(
                  containedInkWell: true,
                  highlightShape: BoxShape.rectangle,
                  onTap: () => HistoryDialog(setDisplay: (s) => displayCont!.text = s).show(context),
                  child: const Center(
                    child: Icon(Icons.history)
                  )
                )
              )
            ),
            Expanded(
              child: NumButton(
                addToDisplay: addToDisplay,
                value: "0"
              )
            ),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 65,
                child: InkResponse(
                  containedInkWell: true,
                  highlightShape: BoxShape.rectangle,
                  onTap: () =>
                    Bottom(
                      padding: false,
                      children: (c) =>
                        List.generate(
                          cdr.db.dies.countSync(),
                          (index) {
                            var dieName = cdr.db.dies.where().offset(index).findFirstSync()!.title;
                            return InkResponse(
                              containedInkWell: true,
                              highlightShape: BoxShape.rectangle,
                              onTap: () {
                                addToDisplay("{$dieName}");
                                cdr.nav.pop();
                              },
                              child: ConstrainedBox(
                                constraints: const BoxConstraints.expand(height: 50),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Text(
                                    dieName,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  )
                                )
                              )
                            );
                          }
                        ),
                      buttons: (c) => [
                        TextButton(
                          onPressed: () => cdr.nav.pop(),
                          child: Text(cdr.locale.cancel),
                        )
                      ],
                    ).show(context),
                  child: Center(
                    child: Text(
                      CDR.of(context).locale.addDie,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    )
                  )
                )
              )
            ),
          ],
        ),
      )
    ];
    return Column(children: children);
    // return ListView(children: children);
  }
}

class NumButton extends StatelessWidget{
  final void Function(String) addToDisplay;
  final String value;

  const NumButton({super.key, required this.addToDisplay, required this.value});

  @override
  Widget build(BuildContext context) =>
    SizedBox(
      height: 65,
      child: InkResponse(
        containedInkWell: true,
        highlightShape: BoxShape.rectangle,
        onTap: () =>
          addToDisplay(value),
        child: Center(
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          )
        )
      )
    );
}

class NumBar extends StatelessWidget{
  final void Function(String) addToDisplay;
  final List<String> values;

  const NumBar({super.key, required this.addToDisplay, required this.values});

  @override
  Widget build(BuildContext context) =>
    SizedBox(
      height: 65,
      child: Row(
        children: List.generate(
          values.length,
          (index) => Expanded(
            child: NumButton(
              addToDisplay: addToDisplay,
              value: values[index]
            )
          )
        ),
      )
    );
}