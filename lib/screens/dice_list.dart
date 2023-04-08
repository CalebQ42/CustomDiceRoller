import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/ui/frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DieList extends StatefulWidget{

  const DieList({super.key});

  @override
  State<StatefulWidget> createState() => DieListState();
}

class DieListState extends State<DieList>{
  @override
  Widget build(BuildContext context) {
    var cdr = CDR.of(context);
    //TODO
    return FrameContent(
      fab: FloatingActionButton(
        onPressed: (){
          //TODO: Add new die and open it.
        }
      ),
      child: AnimatedList(
        itemBuilder: (context, index, animation) {
          return Text("HI");
        },
      ),
    );
  }
}

