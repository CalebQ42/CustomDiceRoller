import 'package:customdiceroller/CDR.dart';
import 'package:customdiceroller/CustVars/Widgets/Label.dart';
import 'package:customdiceroller/UI/Common.dart';
import 'package:customdiceroller/Dice/DiceFormula.dart';
import 'package:flutter/material.dart';

import 'package:customdiceroller/CustVars/selectableText.dart';

class Formula extends StatelessWidget{
  final CDR cdr;
  final BuildContext context;
  Formula(this.cdr, this.context);
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new MyAppBar(
        title: new Label("Dice Formula")
      ).build(context) as PreferredSizeWidget,
      drawer: new MyNavDrawer(context),
      body: new FormulaView(cdr)
    );
  }
}

class FormulaView extends StatefulWidget{
  final CDR cdr;
  FormulaView(this.cdr);
  State<FormulaView> createState() => new FormulaState(cdr);
}

class FormulaState extends State<FormulaView>{
  var display = new TextEditingController();
  final CDR cdr;
  FormulaState(this.cdr);
  Widget build(BuildContext context){
    return new Column(
      children: <Widget>[
        new Spacer(flex:1),
        new Expanded(
          flex:1, 
          child:/* new Ink(
            color: Theme.of(context).cardColor.withAlpha(150),
            child: */new Row(
              children: <Widget>[
                new Expanded(
                  child: new Align(
                    alignment: Alignment.centerRight,
                    child: new SelectableText(
                      style: Theme.of(context).textTheme.subhead,
                      focusNode: new FocusNode(),
                      cursorColor: Theme.of(context).textSelectionColor,
                      controller: display,
                      textAlign: TextAlign.end,
                    )
                  )
                ),
                new InkResponse(
                  child: new Center(
                    child: new Padding(
                      padding: EdgeInsets.all(10.0),
                      child: const Icon(Icons.backspace)
                    )
                  ),
                  onTap: (){delete();}
                )
              ],
            ),
          ),
        new Keypad(this,cdr),
        new Spacer(flex:1)
      ],
    );
  }
  void changeDisplay(String newText){
    display.text = newText;
  }
  void addToDisplay(String text){
    if(display.selection.baseOffset==-1){
      display.text += text;
    }else{
      display.text = display.text.substring(0,display.selection.baseOffset)+text+display.text.substring(display.selection.extentOffset);
    }
    display.selection = display.value.selection;
  }
  void delete(){
    display.text.substring(0,display.text.length-1);
  }
  void clear(){
    display.clear();
  }
}

class Keypad extends StatelessWidget{
  final FormulaState formulaState;
  final CDR cdr;
  Keypad(this.formulaState,this.cdr);
  Widget build(BuildContext context){
    return Expanded(
      flex:5,
      child: Ink(
        color: Theme.of(context).cardColor,
        child: new Column(
          children: <Widget>[
            new Expanded(
              flex:1,
              child: new Row(
                children: <Widget>[
                  new KeypadButton(1,"Add Die",
                    (){print("Add Die");}
                  ),
                  new KeypadButton(1,"Add Group",
                    (){print("Add Group");}
                  ),
                  new KeypadButton(1,"Clear",
                    (){formulaState.clear();}
                  )
                ],
              )
            ),
            new Expanded(
              flex:4,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    flex:1,
                    child: new Column(
                      children: <Widget>[
                        new KeypadButton(1,"1",
                          (){formulaState.addToDisplay("1");}
                        ),
                        new KeypadButton(1,"4",
                          (){formulaState.addToDisplay("4");}
                        ),
                        new KeypadButton(1,"7",
                          (){formulaState.addToDisplay("7");}
                        ),
                      ],
                    )
                  ),
                  new Expanded(
                    flex:1,
                    child: new Column(
                      children: <Widget>[
                        new KeypadButton(1,"2",
                          (){formulaState.addToDisplay("2");}
                        ),
                        new KeypadButton(1,"5",
                          (){formulaState.addToDisplay("5");}
                        ),
                        new KeypadButton(1,"8",
                          (){formulaState.addToDisplay("8");}
                        ),
                      ],
                    )
                  ),
                  new Expanded(
                    flex:1,
                    child: new Column(
                      children: <Widget>[
                        new KeypadButton(1,"3",
                          (){formulaState.addToDisplay("3");}
                        ),
                        new KeypadButton(1,"6",
                          (){formulaState.addToDisplay("6");}
                        ),
                        new KeypadButton(1,"9",
                          (){formulaState.addToDisplay("9");}
                        ),
                      ],
                    )
                  ),
                  new Expanded(
                    flex:1,
                    child: new Column(
                      children: <Widget>[
                        new KeypadButton(1,"+",
                          (){formulaState.addToDisplay("+");}
                        ),
                        new KeypadButton(1,"-",
                          (){formulaState.addToDisplay("-");}
                        ),
                      ],
                    )
                  )
                ],
              )
            ),
            new Expanded(
              flex:1,
              child: new Row(
                children: <Widget>[
                  new KeypadButton(1,"0",
                    (){formulaState.addToDisplay("0");}
                  ),
                  new KeypadButton(1,"D",
                    (){formulaState.addToDisplay("D");}
                  )
                ],
              )
            ),
            new KeypadButton(1,"Roll",(){
              print("Hello");
              var hi = DiceFormula.solve(formulaState.display.text,cdr);
              hi.showResultDialog(context,cdr,"oops");
            })
          ],
        ),
      )
    );
  }
}

class KeypadButton extends StatelessWidget{
  final int flex;
  final String text;
  final VoidCallback onClick;
  KeypadButton(this.flex, this.text, this.onClick);
  Widget build(BuildContext context){
    return Expanded(
      flex: flex,
      child: new InkResponse(
        splashFactory: Theme.of(context).splashFactory,
        containedInkWell: true,
        onTap: onClick,
        child: new Center(
          child: new Text(text)
        )
      )
    );
  }
}