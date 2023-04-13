import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/ui/frame.dart';
import 'package:flutter/material.dart';

class FrameContent extends StatefulWidget{

  final Widget? child;
  final bool allowPop;
  final Widget? fab;
  final GlobalKey<FrameSpeedDialState>? fabKey;

  const FrameContent({
    super.key,
    this.child,
    this.allowPop = true,
    this.fab,
    this.fabKey
  });

  @override
  State<FrameContent> createState() => FrameContentState();

  static FrameContentState of(BuildContext context) => context.findAncestorStateOfType<FrameContentState>()!;
}

class FrameContentState extends State<FrameContent> {

  bool _fabExpanded = false;
  set fabExtended(bool b) {
    setState(() => _fabExpanded = b);
  }

  @override
  Widget build(BuildContext context) =>
    WillPopScope(
      onWillPop:
        !widget.allowPop ?
          () async => true :
        widget.fabKey?.currentState?.expanded ?? false ?
          () async{
            widget.fabKey?.currentState?.expanded = false;
            return true;
          } :
        Frame.of(context).handleBackpress,
      child: Container(
        color: Theme.of(context).canvasColor,
        child: Stack(
          children: [
            widget.child ?? Container(),
            AnimatedSwitcher(
              duration: CDR.of(context).globalDuration,
              transitionBuilder: (child, animation) =>
                FadeTransition(
                  opacity: animation,
                  child: child
                ),
              child: _fabExpanded ?
                GestureDetector(
                  onTap: () {
                    widget.fabKey?.currentState?.expanded = false;
                    fabExtended = false;
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black.withOpacity(.25),
                  )
                ) : null,
            ),
            if(widget.fab != null) Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: widget.fab
              ),
            ),
          ]
        ),
      )
    );
}

class FrameSpeedDial extends StatefulWidget{

  final List<SpeedDialIcons> children;

  const FrameSpeedDial({required super.key, required this.children});

  @override
  State<StatefulWidget> createState() => FrameSpeedDialState();
}

class FrameSpeedDialState extends State<FrameSpeedDial> with SingleTickerProviderStateMixin{
  bool _expanded = false;
  bool get expanded => _expanded;
  set expanded(bool b) {
    _expanded = b;
    if(_expanded){
      anim?.animateTo(1.0,
        duration: CDR.of(context).globalDuration,
      );
    }else{
      anim?.animateBack(0,
        duration: CDR.of(context).globalDuration,
      );
    }
    setState(() {});
  }

  AnimationController? anim;

  @override
  Widget build(BuildContext context) {
    anim ??= AnimationController(vsync: this);
    var cdr = CDR.of(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ...List.generate(
            widget.children.length,
            (i) => AnimatedPositioned(
              duration: cdr.globalDuration,
              bottom: _expanded ? (50*(i+1)) + 18 : 8,
              right: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if(widget.children[i].label != null) AnimatedSwitcher(
                    duration: cdr.globalDuration,
                    transitionBuilder: (child, animation) =>
                      SizeTransition(
                        axis: Axis.horizontal,
                        sizeFactor: animation,
                        child: child,
                      ),
                    child: _expanded ? Card(
                      color: Theme.of(context).canvasColor,
                      elevation: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          widget.children[i].label!,
                        )
                      )
                    ) : null
                  ),
                  if(widget.children[i].label != null) AnimatedContainer(
                    duration: cdr.globalDuration,
                    width: _expanded ? 10 : 0,
                  ),
                  widget.children[i],
                ]
              )
            )
          ),
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              expanded = !expanded;
              FrameContent.of(context).fabExtended = expanded;
            },
            child: RotationTransition(
              turns: Tween<double>(begin: 0, end: .375).animate(anim!),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      )
    );
  }
}

class SpeedDialIcons extends StatelessWidget{
  final String? label;
  final Widget? child;
  final Function() onPressed;

  const SpeedDialIcons({super.key, this.label, this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) =>
    FloatingActionButton.small(
      onPressed: (){
        onPressed();
        context.findAncestorStateOfType<FrameSpeedDialState>()?.expanded = false;
        FrameContent.of(context).fabExtended = false;
      },
      heroTag: null,
      child: child,
    );
}