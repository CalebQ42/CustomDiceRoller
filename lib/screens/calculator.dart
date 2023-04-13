import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/dice/formula.dart';
import 'package:customdiceroller/ui/frame_content.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class DiceCalculator extends StatefulWidget{

  const DiceCalculator({super.key});

  @override
  State<DiceCalculator> createState() => _DiceCalculatorState();
}

class _DiceCalculatorState extends State<DiceCalculator> {
  String prevText = "";
  TextEditingController? displayCont;
  ScrollController displayScrollCont = ScrollController();

  @override
  Widget build(BuildContext context) {
    var cdr = CDR.of(context);
    displayCont ??= TextEditingController()
      ..addListener(() {
        if(prevText.length > displayCont!.text.length){
          // var del = prevText.substring(displayCont!.selection.start, displayCont!.selection.start + (prevText.length - displayCont!.text.length));
          // print(del);
          //TODO: detect if broken custom dice
        }
        prevText = displayCont!.text;
      });
    return TextFieldTapRegion(
      child: FrameContent(
        fab: FloatingActionButton(
          onPressed: () =>
            DiceFormula.solve(displayCont!.text, CDR.of(context)).showResults(context), //TODO: show rusults in a UI
          child: const Icon(Icons.casino),
        ),
        child: SizedBox(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Spacer(),
              InputDecorator(
                decoration: const InputDecoration(),
                isFocused: true,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        scrollController: displayScrollCont,
                        style: Theme.of(context).textTheme.headlineSmall,
                        autofocus: true,
                        readOnly: CDR.of(context).isMobile,
                        showCursor: true,
                        controller: displayCont,
                        enableSuggestions: false,
                        autocorrect: false,
                        minLines: 1,
                        maxLines: 1,
                        decoration: null,
                        onSubmitted: (value) =>
                          DiceFormula.solve(displayCont!.text, CDR.of(context)).showResults(context),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("([0-9]|${CDR.of(context).locale.dieNotation}|\\+|-)")),
                        ],
                      )
                    ),
                    IconButton(
                      icon: const Icon(Icons.backspace),
                      onPressed: (){
                        var sel = displayCont!.selection;
                        var bef = sel.textBefore(displayCont!.text);
                        if(!sel.isCollapsed){
                          displayCont?.text = bef + sel.textAfter(displayCont!.text);
                          displayCont?.selection = TextSelection.collapsed(offset: bef.length);
                        }else if(bef != ""){
                          displayCont?.text = bef.substring(0, bef.length-1);
                          displayCont?.selection = TextSelection.collapsed(offset: bef.length-1);
                        }
                        //TODO: detect if broken custom dice
                      },
                    )
                  ]
                )
              ),
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
              Row(
                children: [
                  Expanded(
                    child: NumButton(
                      addToDisplay: addToDisplay,
                      value: "0"
                    )
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 65,
                      child: InkResponse(
                        containedInkWell: true,
                        highlightShape: BoxShape.rectangle,
                        onTap: () => print("TODO"), // TODO: select a die
                        child: Center(
                          child: Text(
                            CDR.of(context).locale.addDie,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall,
                          )
                        )
                      )
                    )
                  )
                ],
              ),
              Spacer()
              // CalcKeypad(
              //   addToDisplay: addToDisplay,
              // )
            ],
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
      displayCont?.selection = TextSelection.collapsed(offset: sel.baseOffset+1);
    }
    displayScrollCont.animateTo(
      displayScrollCont.position.maxScrollExtent * (displayCont!.selection.baseOffset / displayCont!.text.length) + 20,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear
    );
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
    Row(
      children: List.generate(
        values.length,
        (index) => Expanded(
          child: NumButton(
            addToDisplay: addToDisplay,
            value: values[index]
          )
        )
      ),
    );
}