import 'dart:math';

import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/dice/dice.dart';
import 'package:customdiceroller/ui/frame.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class DieList extends StatefulWidget{

  const DieList({super.key});

  @override
  State<StatefulWidget> createState() => DieListState();
}

class DieListState extends State<DieList>{
  GlobalKey<AnimatedListState> listKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var cdr = CDR.of(context);
    return FrameContent(
      fab: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async{
          await cdr.db.writeTxn(() async => await cdr.db.dies.put(Die()));
          listKey.currentState?.insertItem(cdr.db.dies.countSync()-1);
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
              () async {
                await cdr.db.writeTxn(() async => await cdr.db.dies.delete(die.id));
                listKey.currentState?.removeItem(
                  index,
                  (context, animation) => SizeTransition(sizeFactor: animation)
                );
              }
            ),
            onDismissed: (direction) async {
              await cdr.db.writeTxn(() async => await cdr.db.dies.delete(die.id));
              listKey.currentState?.removeItem(
                index,
                (context, animation) => SizeTransition(sizeFactor: animation)
              );
            },
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
  Widget build(BuildContext context) =>
    Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(5),
      child: InkResponse(
        containedInkWell: true,
        highlightShape: BoxShape.rectangle,
        onTap: () =>  CDR.of(context).nav?.pushNamed("/die/${d.uuid}"),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            InkResponse(
              containedInkWell: true,
              highlightShape: BoxShape.rectangle,
              onTap: (){
                var res = d.roll();
                //TODO: Display result;
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
              child: Text(d.title, style: Theme.of(context).textTheme.headlineSmall,)
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