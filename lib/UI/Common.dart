import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyAppBar extends StatelessWidget{
  final Widget title;
  final List<Widget> actions = new List<Widget>();
  final List<PopupMenuItem> popupActions = new List<PopupMenuItem>();
  MyAppBar({this.title,List<Widget> additionalActions, List<PopupMenuItem> additionalPopupActions}){
    additionalActions ??= new List();
    additionalPopupActions ??= new List();
    List<PopupMenuItem> defPopup = [
      PopupMenuItem(
          value: "G+",
          child: const Text("G+ Community")
      ),
      PopupMenuItem(
          value: "Translate",
          child: const Text("Help Translate!")
      )
    ];
    additionalPopupActions.addAll(defPopup);
    var def = new PopupMenuButton(
        itemBuilder: (context)=>additionalPopupActions,
        onSelected:(t){
          var txt = t;
          switch(txt){
            case "G+":
              _launchInBrowser("https://plus.google.com/communities/117741233533206107778");
              break;
            case "Translate":
              _launchInBrowser("https://crwd.in/customdiceroller");
              break;
          }
        }
    );
    additionalActions.add(def);
    actions.addAll(additionalActions);
  }
  @override
  Widget build(BuildContext context) {
    var appBar = new AppBar(
      key: new Key("AppBar"),
      title: title,
      actions: actions,
    );
    return appBar;
    // return new PreferredSize(
    //   child: new Hero(
    //     tag: "AppBar",
    //     child: appBar
    //   ),
    //   preferredSize: appBar.preferredSize
    // );
  }
}

class MyNavDrawer extends Drawer{
  MyNavDrawer(BuildContext context): super(child: new ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        new DrawerHeader(
          child: const Text("CDR"),
          decoration: const BoxDecoration(color: Colors.deepPurple),
        ),
        new ListTile(
          leading: new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [new SvgPicture.asset(
              "assets/custom_die.svg",
              color: Theme.of(context).iconTheme.color
            )]
          ),
          title: new Text("Dice"),
          onTap:(){
            Navigator.pop(context);
            Navigator.pushNamed(context,"/dice");
            Navigator.
          }
        ),
        new ListTile(
          leading: new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [new SvgPicture.asset(
              "assets/die_stack.svg",
              color: Theme.of(context).iconTheme.color
            )]
          ),
          title: new Text("Dice"),
          onTap:(){
            Navigator.pop(context);
            Navigator.pushNamed(context,"/dice");
          }
        ),
        new ListTile(
          leading: new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [const Icon(Icons.functions)]
          ),
          title: new Text("Formula"),
          onTap:(){
            Navigator.pop(context);
            Navigator.pushNamed(context,"/formula");
          }
        ),
        new Divider(),
        new ListTile(
          leading: new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [const Icon(Icons.settings)]
          ),
          title: new Text("Settings"),
          onTap:(){
            Navigator.pop(context);
            Navigator.pushNamed(context,"/settings");
          }
        ),
      ]
  ));
  MyNavDrawer getThis() => this;
}

Future<Null> _launchInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(url, forceSafariVC: false, forceWebView: false);
  } else {
    throw 'Could not launch $url';
  }
}