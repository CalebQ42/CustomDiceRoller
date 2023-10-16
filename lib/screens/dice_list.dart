import 'dart:math';

import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/dice/dice.dart';
import 'package:darkstorm_common/bottom.dart';
import 'package:darkstorm_common/frame_content.dart';
import 'package:darkstorm_common/speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class DieList extends StatefulWidget{

  const DieList({super.key});

  @override
  State<StatefulWidget> createState() => DieListState();
}

class DieListState extends State<DieList>{
  GlobalKey<AnimatedListState> listKey = GlobalKey();
  GlobalKey<SpeedDialState> speedDialKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var cdr = CDR.of(context);
    return FrameContent(
      speedDialKey: speedDialKey,
      fab: cdr.prefs.stupid() && cdr.stupid != null ? SpeedDial(
        key: speedDialKey,
        children: [
          SpeedDialIcons(
            label: cdr.locale.newDie,
            child: const Icon(Icons.add_box_outlined),
            onPressed: () async{
              var newD = Die(title: cdr.locale.newDie);
              cdr.nav.pushNamed("/die/${newD.uuid}", arguments: newD);
              if(await cdr.db.dies.getByTitle(newD.title) == null){
                await cdr.db.writeTxn(() async => await cdr.db.dies.put(newD));
              }
            }
          ),
          SpeedDialIcons(
            label: cdr.locale.download,
            child: const Icon(Icons.download),
            onPressed: () {
              var mes = ScaffoldMessenger.of(context);
              var cont = TextEditingController();
              Bottom(
                children: (c) => [
                  Text(cdr.locale.shareCode, style: Theme.of(context).textTheme.titleLarge),
                  Container(height: 10),
                  TextField(controller: cont)
                ],
                buttons: (c) => [
                  TextButton(
                    child: Text(cdr.locale.cancel),
                    onPressed: () => cdr.nav.pop()
                  ),
                  TextButton(
                    child: Text(cdr.locale.download),
                    onPressed: () async{
                      var res = await cdr.stupid!.downloadProfile(cont.text);
                      if(res){
                        listKey.currentState?.insertItem(cdr.db.dies.countSync()-1);
                      }else{
                        mes.clearSnackBars();
                        mes.showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 10),
                            content: Text(cdr.locale.downloadFailed),
                          )
                        );
                      }
                      cdr.nav.pop();
                    },
                  ),
                ]
              ).show(context);
            },
          )
        ]
      ) : FloatingActionButton(
        child: const Icon(Icons.add_box_outlined),
        onPressed: () async{
          var newD = Die(title: cdr.locale.newDie);
          cdr.nav.pushNamed("/die/${newD.uuid}", arguments: newD);
          if(await cdr.db.dies.getByTitle(newD.title) == null){
            await cdr.db.writeTxn(() async => await cdr.db.dies.put(newD));
          }
        }
      ),
      child: AnimatedList(
        key: listKey,
        itemBuilder: (context, index, animation) {
          var die = cdr.db.dies.where().offset(index).findFirstSync();
          if(die == null) return const Text("uh oh");
          return Dismissible(
            key: ValueKey<Die>(die),
            direction: cdr.prefs.swipeDelete() ? DismissDirection.horizontal : DismissDirection.none,
            child: DieItem(
              die,
              () => die.delete(context, listKey, index),
            ),
            onDismissed: (_) => die.delete(context, listKey, index),
          );
        },
        initialItemCount: cdr.db.dies.countSync(),
      ),
    );
  }
}

class DieItem extends StatelessWidget{
  final Die d;
  final void Function() onDelete;
  const DieItem(this.d, this.onDelete, {super.key});
  
  @override
  Widget build(BuildContext context) {
    var cdr = CDR.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(5),
      child: InkResponse(
        containedInkWell: true,
        highlightShape: BoxShape.rectangle,
        onTap: () {
          var routeName = "/die/${d.uuid}";
          var prevRoute = cdr.observatory.containsRoute(name: routeName);
          if(prevRoute != null) cdr.nav.removeRoute(prevRoute);
          cdr.nav.pushNamed("/die/${d.uuid}");
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            InkResponse(
              containedInkWell: true,
              highlightShape: BoxShape.rectangle,
              onTap: () {
                if(d.sides.isNotEmpty){
                  d.rollRes().showResults(context);
                }else{
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 10),
                      content: Text(cdr.locale.pleaseAddSide)
                    )
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Transform.rotate(
                  angle: pi/4,
                  child: const Icon(Icons.casino)
                )
              )
            ),
            Container(width: 10),
            Expanded(
              child: Text(
                d.title,
                style: Theme.of(context).textTheme.headlineSmall
              )
            ),
            if(CDR.of(context).prefs.deleteButton()) InkResponse(
              containedInkWell: true,
              highlightShape: BoxShape.rectangle,
              onTap: onDelete,
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Icon(Icons.delete_forever)
              )
            ),
          ]
        )
      )
    );
  }
}