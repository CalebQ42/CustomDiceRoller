import 'package:customdiceroller/Dice/Dice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CDR{
  SharedPreferences prefs;
  String dir;
  List<Die> _dieMaster;
  List<Dice> _diceMaster;

  List<Die> getDies(String str){
    _dieMaster.sort((a,b)=> a.getName().compareTo(b.getName()));
    if(str=="")
      return _dieMaster;
    return new List.of(_dieMaster.where((d)=>d.getName().contains(str)));
  }
  void removeDieAt(String str, int i){
    var d = getDies(str)[i];
//    d.delete();
    _dieMaster.remove(d);
  }
  Die addNewDie(){
    var newy = Die();
    var i = 1;
    while(_dieMaster.any((d)=>d.getName()==newy.getName())){
      newy.renameNoFileMove("New DiehasConflictDie " + i.toString());
    }
    _dieMaster.add(newy);
    return newy;
  }
  bool hasConflictDie(String name){
    return _dieMaster.any((d)=>d.getName() == name);
  }

  List<Dice> getDice(String str){
    _diceMaster.sort((a,b)=>a.getName().compareTo(b.getName()));
    if(str=="")
      return _diceMaster;
    return new List.of(_diceMaster.where((d)=>d.getName().contains(str)));
  }
  void removeDiceAt(String str,int i){
    var d = getDice(str);
//    d.delete();
    _diceMaster.remove(d);
  }
  Dice addNewDice(){
    var newy = Dice();
    var i = 1;
    while(_diceMaster.any((d)=>d.getName()==newy.getName())){
      newy.renameNoFileMove("New Dice " + i.toString());
    }
    _diceMaster.add(newy);
    return newy;
  }
  bool hasConflictDice(String name){
    return _diceMaster.any((d)=>d.getName()==name);
  }
}