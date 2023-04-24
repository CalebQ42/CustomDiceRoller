import 'dart:math';

import 'package:customdiceroller/cdr.dart';
import 'package:darkstorm_common/bottom.dart';
import 'package:flutter/material.dart';

class HistoryDialog extends StatefulWidget{

  final void Function(String) setDisplay;

  const HistoryDialog({super.key, required this.setDisplay});

  @override
  State<HistoryDialog> createState() => _HistoryDialogState();

  void show(BuildContext context) =>
    Bottom(
      child: (c) => this,
      // scroll: false,
      padding: false,
    ).show(context);
}

class _HistoryDialogState extends State<HistoryDialog> with SingleTickerProviderStateMixin {

  TabController? cont;
  @override
  Widget build(BuildContext context) {
    var cdr = CDR.of(context);
    cont ??= TabController(
      length: 2,
      initialIndex: cdr.prefs.historyTab(),
      vsync: this
    )..addListener(() {
      cdr.prefs.setHistoryTab(cont!.index);
    });
    return Column(
      mainAxisSize: MainAxisSize.min,
      children:[
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: min(500, MediaQuery.of(context).size.height - 50),
          ),
          child: TabBarView(
            controller: cont,
            children: [
              history(cdr),
              saved(cdr)
            ]
          )
        ),
        TabBar(
          tabs: [
            Tab(text: cdr.locale.history),
            Tab(text: cdr.locale.saved)
          ],
          controller: cont,
        )
      ]
    );
  }

  Widget history(CDR cdr) =>
    ListView(
      children: List.generate(
        cdr.prefs.history().length,
        (index) => InkResponse(
          containedInkWell: true,
          highlightShape: BoxShape.rectangle,
          onTap: (){
            widget.setDisplay(cdr.prefs.history()[cdr.prefs.history().length - 1 - index]);
            cdr.nav.pop();
          },
          child: Row(
            children: [
              InkResponse(
                containedInkWell: true,
                highlightShape: BoxShape.rectangle,
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: Icon(Icons.save),
                ),
                onTap: () => setState(() => cdr.prefs.addToSavedFormulas(cdr.prefs.history()[cdr.prefs.history().length - 1 - index])),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  cdr.prefs.history()[cdr.prefs.history().length - 1 - index],
                  style: Theme.of(context).textTheme.headlineSmall,
                )
              )
            ],
          )
        )
      )
    );

  Widget saved(CDR cdr) =>
    ListView(
      children: List.generate(
        cdr.prefs.savedFormulas().length,
        (index) => InkResponse(
          containedInkWell: true,
          highlightShape: BoxShape.rectangle,
          onTap: (){
            widget.setDisplay(cdr.prefs.savedFormulas()[index]);
            cdr.nav.pop();
          },
          child: Row(
            children: [
              InkResponse(
                containedInkWell: true,
                highlightShape: BoxShape.rectangle,
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: Icon(Icons.delete),
                ),
                onTap: () => setState(() => cdr.prefs.removeSavedFormulas(index)),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  cdr.prefs.savedFormulas()[index],
                  style: Theme.of(context).textTheme.headlineSmall,
                )
              )
            ],
          ),
        )
      )
    );
}