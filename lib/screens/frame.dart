import 'package:customdiceroller/cdr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Frame extends StatefulWidget{
  
  final Widget child;

  Frame({super.key, required this.child}){
    if(child is! FrameContent){
      throw("Frame must have FrameContents child");
    }
  }

  @override
  State<StatefulWidget> createState() => FrameState();

  static FrameState of(BuildContext context) => context.findAncestorStateOfType<FrameState>()!;
}

class FrameState extends State<Frame> {

  bool vertical = false;
  bool expanded = false;
  bool hidden = false;
  double verticalTranslation = 0;

  String _selection = "";

  String get selection => _selection;
  set selection(String sel) =>
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if(sel == "/intro") { //TODO: add all values that need a hidden appbar
          hidden = true;
        }else{
          hidden = false;
        }
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
                    onTap: () =>
                      cdr.navKey.currentState?.pushNamed("/calculator"),
                    vertical: vertical,
                    expanded: expanded,
                    selected: _selection == "/calculator",
                  ),
                  Nav(
                    name: "testing",
                    icon: const Icon(Icons.radio),
                    onTap: () {
                      cdr.navKey.currentState?.pushNamed("/intro");
                      Future.delayed(const Duration(seconds: 5), () => cdr.navKey.currentState?.pushNamed("/calculator"));
                    },
                    vertical: vertical,
                    expanded: expanded,
                  ),
                  const Spacer(),
                  Nav(
                    name: locale.settings,
                    icon: const Icon(Icons.settings),
                    onTap: () =>
                      cdr.navKey.currentState?.pushNamed("/settings"),
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
                  widget.child
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
  
  final Icon icon;
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
      margin: vertical && ((topItem && !expanded) || lastItem) ? const EdgeInsets.only(bottom: 20) : EdgeInsets.zero,
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
          Expanded(
            child: topItem && vertical ? AnimatedAlign(
              alignment: expanded ? Alignment.center : Alignment.centerLeft,
              duration: cdr.globalDuration,
              child: Text(name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ) : Text(name,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            )
          ),
          if(!vertical) const SizedBox(width: 20),
        ]
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

  const FrameContent({super.key, this.child});

  @override
  Widget build(BuildContext context) =>
    WillPopScope(
      onWillPop: Frame.of(context).handleBackpress,
      child: Container(
        color: Theme.of(context).canvasColor,
        child: child,
      ),
    );
}