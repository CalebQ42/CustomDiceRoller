import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/dice/formula.dart';
import 'package:customdiceroller/ui/frame_content.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class DiceCalculator extends StatefulWidget{

  const DiceCalculator({super.key});

  @override
  State<DiceCalculator> createState() => _DiceCalculatorState();
}

class _DiceCalculatorState extends State<DiceCalculator> {
  String prevText = "";
  TextEditingController? displayCont;

  @override
  Widget build(BuildContext context) {
    displayCont ??= TextEditingController()
      ..addListener(() {
        if(prevText.length > displayCont!.text.length){
          var del = prevText.substring(displayCont!.selection.start, displayCont!.selection.start + (prevText.length - displayCont!.text.length));
          print(del);
          //TODO: Detect if custom die was deleted and delete the whole thing.
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
        child: Column(
          children: [
            const Spacer(),
            SizedBox(
              width: 500,
              child: TextField(
                autofocus: true,
                readOnly: CDR.of(context).isMobile,
                showCursor: true,
                controller: displayCont,
                enableSuggestions: false,
                autocorrect: false,
                maxLines: 1,
                onSubmitted: (value) =>
                  DiceFormula.solve(displayCont!.text, CDR.of(context)).showResults(context),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("([0-9]|${CDR.of(context).locale.dieNotation}|\\+|-)")),
                ],
              )
            ),
            CalcKeypad(
              addToDisplay: addToDisplay,
            ),
            const Spacer()
          ],
        )
      )
    );
  }

  void addToDisplay(String value){
    var sel = displayCont!.selection;
    displayCont?.text = sel.textBefore(displayCont!.text) + value + sel.textAfter(displayCont!.text);
    displayCont?.selection = sel.copyWith(baseOffset: sel.baseOffset+1, extentOffset: sel.extentOffset+1-(sel.end-sel.start));
  }
}

class CalcKeypad extends StatelessWidget{
  final void Function(String) addToDisplay;

  const CalcKeypad({super.key, required this.addToDisplay});

  @override
  Widget build(BuildContext context) =>
    SizedBox(
      width: 400,
      height: 400,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      numButton("1", context),
                      numButton("2", context),
                      numButton("3", context)
                    ],
                  )
                ),
                Expanded(
                  child: Row(
                    children: [
                      numButton("4", context),
                      numButton("5", context),
                      numButton("6", context)
                    ],
                  )
                ),
                Expanded(
                  child: Row(
                    children: [
                      numButton("7", context),
                      numButton("8", context),
                      numButton("9", context)
                    ],
                  )
                ),
                Expanded(
                  child: Row(
                    children: [
                      numButton("0", context),
                      numButton(AppLocalizations.of(context)!.dieNotation, context)
                    ],
                  )
                )
              ],
            )
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                numButton("+", context),
                numButton("-", context)
              ],
            ),
          )
        ]
      )
    );

  Widget numButton(String value, BuildContext context) =>
    Expanded(
      child: TextButton(
        onPressed: () =>
          addToDisplay(value),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(value,
            style: Theme.of(context).textTheme.headlineSmall,
          )
        )
      )
    );
}