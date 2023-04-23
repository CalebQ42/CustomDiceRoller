import 'package:flutter/material.dart';

class Bottom extends StatefulWidget{

  final List<Widget> Function(BuildContext)? buttons;
  final Color? background;
  final Widget Function(BuildContext)? child;
  final bool padding;
  final bool dismissible;
  final bool scroll;

  final GlobalKey<_ButtonState> _butKey = GlobalKey();


  Bottom({
    this.buttons,
    this.background,
    required this.child,
    this.padding = true,
    this.dismissible = true,
    this.scroll = true,
    super.key
  });

  @override
  State<Bottom> createState() => BottomState();

  static BottomState? of(BuildContext context) => context.findAncestorStateOfType<BottomState>();

  void updateButtons() => _butKey.currentState?.refresh();
  
  void show(BuildContext context) =>
    showModalBottomSheet(
      context: context,
      builder: (c) => this,
      backgroundColor: background,
      isScrollControlled: true,
      isDismissible: dismissible,
      useSafeArea: true,
    );
}

class BottomState extends State<Bottom> {

  @override
  Widget build(BuildContext context) {
    var child = Padding(
      padding: widget.padding ? const EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
        bottom: 15
      ) : EdgeInsets.zero,
      child: widget.child!(context)
    );
    return Wrap(
      children: [
        widget.scroll ? SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          primary: false,
          child: child
        ) : child,
        if(widget.buttons != null) _BottomButtons(
          key: widget._butKey,
          builder: widget.buttons!,
        )
      ],
    );
  }
}

class _BottomButtons extends StatefulWidget{
  final List<Widget> Function(BuildContext) builder;

  const _BottomButtons({required this.builder, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ButtonState();
}

class _ButtonState extends State<_BottomButtons>{

  void refresh() => setState((){});

  @override
  Widget build(BuildContext context) =>
    ButtonBar(
      alignment: MainAxisAlignment.end,
      children: widget.builder(context)
    );
}