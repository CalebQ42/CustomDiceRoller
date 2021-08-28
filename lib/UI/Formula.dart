import 'package:customdiceroller/CDR.dart';
import 'package:customdiceroller/CustVars/Widgets/Label.dart';
import 'package:customdiceroller/UI/Common.dart';
import 'package:customdiceroller/Dice/DiceFormula.dart';

import 'package:flutter/material.dart';

class Formula extends StatelessWidget{
  final CDR cdr;
  Formula(this.cdr);
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new MyAppBar(
        title: new Label("Dice Formula")
      ).build(context),
      drawer: new MyNavDrawer(context),
      body: new FormulaView(cdr)
    );
  }
}

class FormulaView extends StatelessWidget{
  final TextEditingController display = new TextEditingController();
  final CDR cdr;
  FormulaView(this.cdr);
  Widget build(BuildContext context){
    display.addListener((){
      display.selection = display.value.selection;
    });
    return new Column(
      children: <Widget>[
        new Spacer(flex:1),
        new Expanded(
          flex:1, 
          child: new Ink(
            color: Theme.of(context).cardColor.withAlpha(100),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new Align(
                    alignment: Alignment.centerRight,
                    child: new Padding(
                      padding: new EdgeInsets.only(left:40.0),
                      child: TextField(
                        controller: display,
                        readOnly: true,
                        maxLines: 1,
                        showCursor: true,
                        autofocus: true,
                        style: Theme.of(context).textTheme.headline4,
                        toolbarOptions: ToolbarOptions(
                          copy: true, paste: true, selectAll: true, cut: true
                        ),
                      )
                      // child: new SelectableField(
                      //   style: Theme.of(context).textTheme.title,
                      //   cursorColor: Theme.of(context).textSelectionColor,
                      //   controller: display,
                      // ),
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
    var cursorPos = display.selection;
    if(cursorPos.baseOffset==-1){
      display.text += text;
    }else{
      display.text = display.text.substring(0,cursorPos.baseOffset)+text+display.text.substring(cursorPos.extentOffset);
    }
    if (cursorPos.start > display.text.length) {
      cursorPos = new TextSelection.fromPosition(
          new TextPosition(offset: display.text.length));
    }else if(cursorPos.start!=-1){
      if(cursorPos.isCollapsed){
        cursorPos = cursorPos.copyWith(
          baseOffset: cursorPos.baseOffset+1,
          extentOffset: cursorPos.extentOffset+1
        );
      }else{
        cursorPos = cursorPos.copyWith(
          baseOffset: cursorPos.baseOffset+1,
          extentOffset: cursorPos.baseOffset+1
        );
      }
    }else if(cursorPos.start==-1){
      cursorPos = cursorPos.copyWith(
        baseOffset: 1,
        extentOffset: 1
      );
    }
    display.selection = cursorPos;
  }
  void delete(){
    var cursorPos = display.selection;
    if(cursorPos.baseOffset==-1)
      display.text = display.text.substring(0,display.text.length-1);
    else if(!cursorPos.isCollapsed)
      display.text = display.text.substring(0,cursorPos.baseOffset)+display.text.substring(cursorPos.extentOffset);
    else if(cursorPos.baseOffset != 0)
      display.text = display.text.substring(0,cursorPos.baseOffset-1)+display.text.substring(cursorPos.extentOffset);
    if (cursorPos.start > display.text.length) {
      cursorPos = new TextSelection.fromPosition(
          new TextPosition(offset: display.text.length));
    }else if(cursorPos.start!=-1){
      if(cursorPos.isCollapsed&&cursorPos.start !=0){
        cursorPos = cursorPos.copyWith(
          baseOffset: cursorPos.baseOffset-1,
          extentOffset: cursorPos.extentOffset-1
        );
      }else{
        cursorPos = cursorPos.copyWith(
          baseOffset: cursorPos.baseOffset,
          extentOffset: cursorPos.baseOffset
        );
      }
    }
    display.selection = cursorPos;
  }
  void clear(){
    display.clear();
  }
}

class Keypad extends StatelessWidget{
  final FormulaView formulaView;
  final CDR cdr;
  Keypad(this.formulaView,this.cdr);
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
                    (){formulaView.clear();}
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
                          (){formulaView.addToDisplay("1");}
                        ),
                        new KeypadButton(1,"4",
                          (){formulaView.addToDisplay("4");}
                        ),
                        new KeypadButton(1,"7",
                          (){formulaView.addToDisplay("7");}
                        ),
                      ],
                    )
                  ),
                  new Expanded(
                    flex:1,
                    child: new Column(
                      children: <Widget>[
                        new KeypadButton(1,"2",
                          (){formulaView.addToDisplay("2");}
                        ),
                        new KeypadButton(1,"5",
                          (){formulaView.addToDisplay("5");}
                        ),
                        new KeypadButton(1,"8",
                          (){formulaView.addToDisplay("8");}
                        ),
                      ],
                    )
                  ),
                  new Expanded(
                    flex:1,
                    child: new Column(
                      children: <Widget>[
                        new KeypadButton(1,"3",
                          (){formulaView.addToDisplay("3");}
                        ),
                        new KeypadButton(1,"6",
                          (){formulaView.addToDisplay("6");}
                        ),
                        new KeypadButton(1,"9",
                          (){formulaView.addToDisplay("9");}
                        ),
                      ],
                    )
                  ),
                  new Expanded(
                    flex:1,
                    child: new Column(
                      children: <Widget>[
                        new KeypadButton(1,"+",
                          (){formulaView.addToDisplay("+");}
                        ),
                        new KeypadButton(1,"-",
                          (){formulaView.addToDisplay("-");}
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
                    (){formulaView.addToDisplay("0");}
                  ),
                  new KeypadButton(1,"D",
                    (){formulaView.addToDisplay("D");}
                  )
                ],
              )
            ),
            Expanded(
              flex: 1,
              child: new InkResponse(
                highlightShape: BoxShape.rectangle,
                splashFactory: Theme.of(context).splashFactory,
                containedInkWell: true,
                onTap: (){
                  var hi = DiceFormula.solve(formulaView.display.text,cdr);
                  hi.showResultDialog(context,cdr,"oops");
                },
                child: new Ink(
                  color: Theme.of(context).accentColor.withOpacity(.5),
                  child: new Center(
                    child: new Text("Roll")
                  )
                )
              )
            )
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
        highlightShape: BoxShape.rectangle,
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