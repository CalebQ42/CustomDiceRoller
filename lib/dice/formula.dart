import 'dart:math';

import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/dice/dice.dart';
import 'package:customdiceroller/dice/results.dart';

class DiceFormula{
  static DiceResults solve(String str, CDR cdr){
    str = str.toLowerCase();
    var dr = DiceResults();
    var last = 0;
    var problem = false;
    outside:
    for (var i = 0;i < str.length;i++){
      if(str[i]=="{"){
        for(var j = i;j < str.length;j++){
          if(str[j]=="}"){
            var prob = parse(str.substring(last,j+1),dr,cdr);
            if(prob){
              problem = true;
              break outside;
            }
            last = j+1;
          }
        }
      }else if(str[i]=='+'||str[i]=='-'){
        var prob = parse(str.substring(last,i),dr,cdr);
        if(prob){
          problem = true;
          break;
        }
        last = i;
      }
    }
    if(!problem){
      if(last <= str.length -1){
        problem = parse(str.substring(last),dr,cdr);
      }
    }
    dr.problem = problem;
    return dr;
  }

  static bool parse(String str, DiceResults dr, CDR cdr){
    if(str.contains("d")){
      dr.subtractMode = str.startsWith("-");
      if(str.startsWith("+")||str.startsWith("-")){
        str = str.substring(1);
      }
      int? pre;
      int? post;
      var dInd = str.indexOf("d");
      if(dInd == str.length-1) return true;
      if(dInd ==0){
        pre = 1;
      }else{
        pre = int.tryParse(str.substring(0,dInd));
      }
      post = int.tryParse(str.substring(dInd+1));
      if(pre == null || post == null) return true;
      dr.addAll(numberDice(pre, post));
      dr.subtractMode = false;
    }else if(str.contains("{") && str.contains("}")){
      dr.subtractMode = str.startsWith("-");
      if(str.startsWith("+")||str.startsWith("-")) str = str.substring(1);
      int? pre;
      if(str.indexOf("{")!=0 && str[str.indexOf("{")-1] == 'd'){
        str = str.substring(0,str.indexOf('{'))+str.substring(str.indexOf("{"));
      }
      if(str.indexOf("{")!=0){
        pre = int.tryParse(str.substring(0,str.indexOf("{")));
      }else{
        pre = 1;
      }
      if(pre == null) return true;
      var inner = str.substring(str.indexOf("{")+1,str.lastIndexOf("}"));
      var d = cdr.db.dies.getByTitleSync(inner);
      if(d == null) return true;
      dr.addAll(d.roll(pre));
      dr.subtractMode = false;
    }else{
      var tmp = int.tryParse(str);
      if(tmp ==null) return true;
      dr.add(Side.number(tmp));
    }
    return false;
  }

  static List<Side> numberDice(int number, int sides){
    var out = <Side>[];
    var ran = Random.secure();
    for(int i = 0; i < number; i++){
      out.add(Side.number(ran.nextInt(sides)+1));
    }
    return out;
  }
}