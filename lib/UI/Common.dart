import 'dart:async';

import 'package:customdiceroller/CustVars/Widgets/Label.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MyAppBar extends StatelessWidget{
  final Label title;
  final List<Widget> actions = new List<Widget>();
  MyAppBar({this.title,List<Widget> additionalActions}){
    additionalActions ??= new List();
    var def = new PopupMenuButton(
        itemBuilder: (context)=>[
          PopupMenuItem(
              value: "G+",
              child: const Text("G+ Community")
          ),
          PopupMenuItem(
              value: "Translate",
              child: const Text("Help Translate!")
          )
        ],
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
      actions: actions
    );
    return new PreferredSize(
      child: new Hero(
        tag: "AppBar",
        child: appBar
      ),
      preferredSize: appBar.preferredSize
    );
  }
  void setTitle(String title){
    this.title.setText(title);
  }
}

//class MyAppBar extends AppBar{
//  final Label title;
//  MyAppBar({this.title,List<Widget> actions}):super(title: title,actions: (){
//    actions ??= new List();
//    var def = new PopupMenuButton(
//        itemBuilder: (context)=>[
//          PopupMenuItem(
//              value: "G+",
//              child: const Text("G+ Community")
//          ),
//          PopupMenuItem(
//              value: "Translate",
//              child: const Text("Help Translate!")
//          )
//        ],
//        onSelected:(t){
//          var txt = t;
//          switch(txt){
//            case "G+":
//              _launchInBrowser("https://plus.google.com/communities/117741233533206107778");
//              break;
//            case "Translate":
//              _launchInBrowser("https://crwd.in/customdiceroller");
//              break;
//          }
//        }
//    );
//    actions.add(def);
//    return actions;
//  }());
//  void setTitle(String title){
//    this.title.setText(title);
//  }
//}

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [const Icon(Icons.casino)]
          ),
          title: new Text("Dice"),
          onTap:(){
            Navigator.pop(context);
            Navigator.pushNamed(context,"/dice");
          }
        ),
        new ListTile(
          leading: new FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: new  Column(
              children:[
                new Row(
                  children: <Widget>[
                    const Icon(Icons.casino)
                  ],
                ),
                new Row(
                  children: <Widget>[
                    const Icon(Icons.casino),
                    const Icon(Icons.casino)
                  ]
                )
              ]
            )
          ),
          title: new Text("Dice Groups"),
          onTap:(){
            Navigator.pop(context);
            Navigator.pushNamed(context,"/group");
          }
        ),
        new ListTile(
          leading: new Row(
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