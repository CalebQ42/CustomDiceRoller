import 'package:customdiceroller/screens/frame.dart';
import 'package:flutter/material.dart';

class DiceCalculator extends StatelessWidget{

  DiceCalculator({super.key});

  final TextEditingController displayCont = TextEditingController();

  @override
  Widget build(BuildContext context) =>
    FrameContent(
      child: Column(
        children: [
          const Spacer(),
          TextField(
            readOnly: true,
            showCursor: true,
            controller: displayCont,
          ),
          CalcKeypad(
            displayCont: displayCont,
          ),
          const Spacer()
        ],
      )
    );
}

class CalcKeypad extends StatelessWidget{

  final TextEditingController displayCont;

  const CalcKeypad({super.key, required this.displayCont});

  @override
  Widget build(BuildContext context) =>
    SizedBox(
      width: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            child: Text("9"),
            onPressed: () =>
              displayCont.text += 9.toString(),
          )
        ],
      ),
    );
}