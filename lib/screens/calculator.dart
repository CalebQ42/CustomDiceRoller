import 'package:customdiceroller/ui/frame.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              numButton("1", context),
              numButton("2", context),
              numButton("3", context)
            ],
          ),
          Row(
            children: [
              numButton("4", context),
              numButton("5", context),
              numButton("6", context)
            ],
          ),
          Row(
            children: [
              numButton("7", context),
              numButton("8", context),
              numButton("9", context)
            ],
          ),
          Row(
            children: [
              numButton("0", context),
              Expanded(
                child: TextButton(
                  onPressed: () =>
                    displayCont.text += AppLocalizations.of(context)!.dieNotation,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(AppLocalizations.of(context)!.dieNotation,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                )
              )
            ],
          )
        ],
      ),
    );

  Widget numButton(String value, BuildContext context) =>
    Expanded(
      child: TextButton(
        onPressed: () =>
          displayCont.text += value,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(value,
            style: Theme.of(context).textTheme.headlineSmall,
          )
        )
      )
    );
}