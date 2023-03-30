import 'package:customdiceroller/cdr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Frame extends StatefulWidget{
  
  final Widget? child;

  const Frame({super.key, this.child});

  @override
  State<StatefulWidget> createState() => FrameState();

  static FrameState of(BuildContext context) => context.findAncestorStateOfType<FrameState>()!;
}

class FrameState extends State<Frame> {

  bool vertical = false;
  bool expanded = false;
  double verticalTranslation = 0;

  String _selection = "";

  set selection(String sel) => setState(() => _selection = sel);

  Future<bool> handleBackpress() async{
    if(expanded){
      setState(() => expanded = !expanded);
      return true;
    }
    return false;
  }

  ShapeBorder get shape =>
    vertical ? const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))) :
        const RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(20.0)));

  EdgeInsets get contentMargin =>
    vertical ? const EdgeInsets.only(top: 50) :
        const EdgeInsets.only(left: 50);

  Matrix4? get transform => !expanded ? Matrix4.translationValues(0, 0, 0) :
    vertical ? Matrix4.translationValues(0, verticalTranslation, 0) :
        Matrix4.translationValues(200, 0, 0);

  @override
  Widget build(BuildContext context){
    var media = MediaQuery.of(context);
    vertical = media.size.height > media.size.width;
    verticalTranslation = (media.size.height / 2) - 48;
    var cdr = CDR.of(context);
    return WillPopScope(
      onWillPop: handleBackpress,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: vertical ? media.size.width : 270,
                height: vertical ? (media.size.height / 2) : media.size.height,
                child: Column(
                  children: [
                    Nav(
                      name: AppLocalizations.of(context)!.cdr,
                      icon: const Icon(Icons.menu),
                      onTap: () => setState(() => expanded = !expanded),
                      vertical: vertical,
                      topAndNotExpanded: true && !expanded,
                    ),
                    const Spacer(),
                    const Spacer(),
                    Nav(
                      name: AppLocalizations.of(context)!.settings,
                      icon: const Icon(Icons.settings),
                      onTap: () =>
                        cdr.navKey.currentState?.pushNamed("/settings"),
                      vertical: vertical,
                      lastItem: true,
                      selected: _selection == "settings",
                    )
                  ],
                ),
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
                curve: Curves.easeIn,
                child: widget.child,
              )
            ],
          )
        )
      )
    );
  }
}

class Nav extends StatelessWidget{
  
  final Icon icon;
  final String name;
  final Function() onTap;
  final bool vertical;
  final bool lastItem;
  final bool topAndNotExpanded;
  final bool selected;

  const Nav({super.key, required this.icon, required this.name, required this.onTap, this.vertical = true, this.lastItem = false, this.topAndNotExpanded = false, this.selected = false});
  
  @override
  Widget build(BuildContext context) =>
    InkResponse(
      highlightShape: BoxShape.rectangle,
      containedInkWell: true,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: topAndNotExpanded && vertical ? const EdgeInsets.only(bottom: 20) : EdgeInsets.zero,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  icon,
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: selected ? const EdgeInsets.symmetric(vertical: 3) : EdgeInsets.zero,
                    height: selected ? 2 : 0,
                    width: 5,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200)),
                      color: Colors.white
                    ),
                  )
                ]
              )
            ),
            Expanded(
              child: Text(name,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            if(!vertical) const SizedBox(width: 20),
          ]
        )
      ),
    );
}