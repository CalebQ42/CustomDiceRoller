import 'package:flutter/material.dart';

class Frame extends StatefulWidget{
  
  final Widget? child;

  const Frame({super.key, this.child});

  @override
  State<StatefulWidget> createState() => FrameState();

  static FrameState of(BuildContext context) => context.findAncestorStateOfType<FrameState>()!;
}

class FrameState extends State<Frame> with SingleTickerProviderStateMixin {

  bool horizontal = false;

  ShapeBorder get shape =>
    horizontal ? const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))) :
        const RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(20.0)));

  EdgeInsets get contentMargin =>
    horizontal ? const EdgeInsets.only(top: 50) :
        const EdgeInsets.only(left: 50);

  @override
  Widget build(BuildContext context){
    var media = MediaQuery.of(context);
    horizontal = media.size.height > media.size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Text("yo")
              ]
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: contentMargin,
              clipBehavior: Clip.hardEdge,
              decoration: ShapeDecoration(
                color: Theme.of(context).canvasColor,
                shape: shape
              ),
              child: widget.child
            )
          ],
        )
      )
    );
  }
}