import 'dart:math';

import 'package:customdiceroller/cdr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Frame extends StatefulWidget{
  
  final Widget child;

  const Frame({super.key, required this.child});

  @override
  State<StatefulWidget> createState() => FrameState();

  static FrameState of(BuildContext context) => context.findAncestorStateOfType<FrameState>()!;
}

class FrameState extends State<Frame> {

  bool vertical = false;
  bool expanded = false;
  bool hidden = true;
  double verticalTranslation = 0;

  String _selection = "";

  String get selection => _selection;
  set selection(String sel) =>
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        hidden =  sel.startsWith("/intro") || sel == "/loading";
        _selection = sel;
      });
    });

  Future<bool> handleBackpress() async{
    if(expanded){
      setState(() => expanded = !expanded);
      return false;
    }
    return true;
  }

  ShapeBorder get shape =>
    hidden ? const RoundedRectangleBorder() :
    vertical ? const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))) :
        const RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(20.0)));
  EdgeInsets get contentMargin =>
    hidden ? EdgeInsets.zero : vertical ? const EdgeInsets.only(top: 50) :
        const EdgeInsets.only(left: 50);
  Matrix4? get transform => !expanded ? Matrix4.translationValues(0, 0, 0) :
    vertical ? Matrix4.translationValues(0, verticalTranslation, 0) :
        Matrix4.translationValues(200, 0, 0);
  ShapeBorder get topItemShape =>
    hidden ? const RoundedRectangleBorder() :
    vertical ? const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))) :
        const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0)));
  EdgeInsets get topItemMargin =>
    hidden ? EdgeInsets.zero : vertical ? const EdgeInsets.symmetric(horizontal: 20) :
        const EdgeInsets.only(left: 20);

  @override
  Widget build(BuildContext context){
    var media = MediaQuery.of(context);
    vertical = media.size.height > media.size.width;
    verticalTranslation = (media.size.height / 2) - 50;
    var cdr = CDR.of(context);
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedContainer(
              duration: cdr.globalDuration,
              width: vertical ? media.size.width : 270,
              height: vertical ? (media.size.height / 2) : media.size.height,
              child: Column(
                children: [
                  Nav(
                    name: locale.cdr,
                    icon: const Icon(Icons.menu),
                    onTap: () => setState(() => expanded = !expanded),
                    vertical: vertical,
                    expanded: expanded,
                    topItem: true,
                  ),
                  const Spacer(),
                  Nav(
                    name: locale.calculator,
                    icon: const Icon(Icons.calculate),
                    onTap: () {
                      setState(() => expanded = false);
                      if(_selection != "/calculator") cdr.nav?.popAndPushNamed("/calculator");
                    },
                    vertical: vertical,
                    expanded: expanded,
                    selected: _selection == "/calculator",
                  ),
                  Nav(
                    name: locale.dice,
                    icon: Transform.rotate(
                      angle: pi * 1/4,
                      child: const Icon(Icons.casino)
                    ),
                    onTap: () {
                      setState(() => expanded = false);
                      if(_selection != "/dieList") cdr.nav?.pushNamed("/dieList");
                    },
                    vertical: vertical,
                    expanded: expanded,
                    selected: _selection == "/dieList",
                  ),
                  // Nav(
                  //   name: locale.diceGroups,
                  //   icon: const Icon(Icons.spoke),
                  //   onTap: () =>
                  //     cdr.nav?.pushNamed("/groupList"),
                  //   vertical: vertical,
                  //   expanded: expanded,
                  //   selected: _selection == "/groupList",
                  // ),
                  const Spacer(),
                  Nav(
                    name: locale.settings,
                    icon: const Icon(Icons.settings),
                    onTap: () {
                      setState(() => expanded = false);
                      if(_selection != "/settings") cdr.nav?.pushNamed("/settings");
                    },
                    vertical: vertical,
                    lastItem: true,
                    expanded: expanded,
                    selected: _selection == "/settings",
                  )
                ],
              ),
            ),
            AnimatedContainer(
              transform: transform,
              duration: cdr.globalDuration,
              margin: contentMargin,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                shape: shape
              ),
              curve: Curves.easeIn,
              child: Stack(
                children:[
                  widget.child,
                  AnimatedSwitcher(
                    duration: cdr.globalDuration,
                    child: expanded ? GestureDetector(
                      onTap: () => setState(() => expanded = false),
                      child: Container(
                        color: Colors.black.withOpacity(0.25),
                      ),
                    ) : null,
                  ),
                ]
              )
            )
          ],
        )
      )
    );
  }
}

class Nav extends StatelessWidget{
  
  final Widget icon;
  final String name;
  final Function() onTap;
  final bool vertical;
  final bool lastItem;
  final bool topItem;
  final bool expanded;
  final bool selected;

  const Nav({super.key,
      required this.icon,
      required this.name,
      required this.onTap,
      required this.vertical,
      required this.expanded,
      this.topItem = false,
      this.lastItem = false,
      this.selected = false});
  
  @override
  Widget build(BuildContext context) {
    var cdr = CDR.of(context);
    var inner = AnimatedContainer(
      duration: cdr.globalDuration,
      margin: (){
        EdgeInsets margin = vertical ? EdgeInsets.zero : const EdgeInsets.only(right: 20);
        if(vertical && (topItem && !expanded) || lastItem){
          margin = margin += const EdgeInsets.only(bottom: 20);
        }
        return margin;
      }(),
      // margin: vertical && ((topItem && !expanded) || lastItem) ? const EdgeInsets.only(bottom: 20) : EdgeInsets.zero,
      child: AnimatedAlign(
        duration: cdr.globalDuration,
        alignment: expanded ? Alignment.center : Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
                    duration: cdr.globalDuration,
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
            Text(name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ]
        )
      )
    );
    return SizedOverflowBox(
      alignment: Alignment.topLeft,
      size: const Size.fromHeight(50),
      child: InkResponse(
        highlightShape: BoxShape.rectangle,
        containedInkWell: true,
        onTap: onTap,
        child: inner,
      )
    );
  }
}

class FrameContent extends StatelessWidget{

  final Widget? child;
  final bool allowPop;
  final Widget? fab;

  const FrameContent({
    super.key,
    this.child,
    this.allowPop = true,
    this.fab
  });

  @override
  Widget build(BuildContext context) =>
    WillPopScope(
      onWillPop: allowPop ? Frame.of(context).handleBackpress : () async => true,
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Container(
              color: Theme.of(context).canvasColor,
              child: child,
            )
          ),
          if(fab != null) Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: fab
            ),
          )
        ]
      ),
    );
}