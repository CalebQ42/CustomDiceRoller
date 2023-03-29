import 'package:flutter/material.dart';

class Frame extends StatefulWidget{
  
  final Widget? child;

  const Frame({super.key, this.child});

  @override
  State<StatefulWidget> createState() => FrameState();

  static FrameState of(BuildContext context) => context.findAncestorStateOfType<FrameState>()!;
}

class FrameState extends State<Frame> {

  bool horizontal = false;
  bool expanded = true;
  double verticalTranslation = 0;

  ShapeBorder get shape =>
    horizontal ? const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))) :
        const RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(20.0)));

  EdgeInsets get contentMargin =>
    horizontal ? const EdgeInsets.only(top: 50) :
        const EdgeInsets.only(left: 50);

  Matrix4? get transform => !expanded ? null :
    horizontal ? Matrix4.translationValues(0, verticalTranslation, 0) :
        Matrix4.translationValues(150, 0, 0);

  @override
  Widget build(BuildContext context){
    var media = MediaQuery.of(context);
    horizontal = media.size.height > media.size.width;
    verticalTranslation = (media.size.height / 2) - 50;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: horizontal ? media.size.width : 200,
              height: horizontal ? (media.size.height / 2) : media.size.height,
              child: NavItems(horizontal),
            ),
            AnimatedContainer(
              transform: transform,
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

class NavItems extends StatelessWidget{

  final bool horizontal;

  const NavItems(this.horizontal, {super.key});

  @override
  Widget build(BuildContext context) =>
    Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("yo"),
        Spacer(),
        Text("potato"),
        Spacer(),
        Text("toadle")
      ],
    );
}