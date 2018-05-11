import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MyAppBar extends AppBar{
  MyAppBar({Widget title,List<Widget> actions}):super(title: title,actions: (){
    actions ??= new List();
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
    actions.add(def);
    return actions;
  }());
}

class MyNavDrawer extends Drawer{
  MyNavDrawer(): super(child: new ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        new DrawerHeader(
          child: const Text("CDR"),
          decoration: const BoxDecoration(color: Colors.deepPurple),
        ),
        new ListTile(
          leading: const Icon(Icons.casino),
          title: new Text("Dice"),
          onTap:(){
            //TODO
          }
        ),
        new ListTile(
          leading: const Icon(Icons.group_work),
          title: new Text("Dice Groups"),
          onTap:(){
            //TODO
          }
        ),
        new ListTile(
          leading: const Icon(Icons.functions),
          title: new Text("Formula"),
          onTap:(){
            //TODO
          }
        ),
        new Divider(),
        new ListTile(
          leading: const Icon(Icons.settings),
          title: new Text("Settings"),
          onTap:(){
            //TODO
          }
        )
      ]
  ));
}

Future<Null> _launchInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(url, forceSafariVC: false, forceWebView: false);
  } else {
    throw 'Could not launch $url';
  }
}