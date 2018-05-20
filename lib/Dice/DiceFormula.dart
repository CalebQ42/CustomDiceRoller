import 'package:customdiceroller/CDR.dart';
import 'package:customdiceroller/Dice/Dice.dart';
import 'package:customdiceroller/Dice/DiceResults.dart';

class DiceFormula{
  static DiceResults solve(String str,CDR cdr){
    var dr = new DiceResults();
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
      if(last <= str.length -1)
        problem = parse(str.substring(last),dr,cdr);
    }
    dr.problem = problem;
    return dr;
  }
  static bool parse(String str, DiceResults dr, CDR cdr){
    if(str.contains("d")){
      dr.subtractMode = str.startsWith("-");
      if(str.startsWith("+")||str.startsWith("-"))
        str = str.substring(1);
      int pre;
      int post;
      var dInd = str.indexOf("d");
      if(dInd == str.length-1)
        return true;
      if(dInd ==0)
        pre = 1;
      else
        pre = int.tryParse(str.substring(0,dInd));
      post = int.tryParse(str.substring(dInd+1));
      if(pre ==null || post ==null)
        return true;
      var out = Dice.numberDice(pre, post).roll();
      dr.combineWith(out);
      dr.subtractMode = false;
    }else if(str.contains("{") && str.contains("}")){
      dr.subtractMode = str.startsWith("-");
      if(str.startsWith("+")||str.startsWith("-"))
        str = str.substring(1);
      int pre;
      if(str.indexOf("{")!=0 && str[str.indexOf("{")-1] == 'd')
        str = str.substring(0,str.indexOf('{'))+str.substring(str.indexOf("{"));
      if(str.indexOf("{")!=0)
        pre = int.tryParse(str.substring(0,str.indexOf("{")));
      else
        pre = 1;
      if(pre ==null)
        return true;
      var inner = str.substring(str.indexOf("{")+1,str.lastIndexOf("}"));
      if(inner.startsWith("Die:")){
        inner = inner.substring(4);
        for(var i in cdr.getDies("")){
          if(i.getName() == inner){
            var tmp = Dice();
            for (var j=0;j<pre;j++)
              tmp.dice.add(i.clone());
            dr.combineWith(tmp.roll());
            break;
          }
        }
      }else if(inner.startsWith("Group:")){
        inner = inner.substring(6);
        for(var i in cdr.getDice("")){
          if(i.getName() == inner){
            var tmp = Dice();
            for (var j=0;j<pre;j++)
              tmp.dice.addAll((i.clone() as Dice).dice);
            dr.combineWith(tmp.roll());
            break;
          }
        }
      }
      dr.subtractMode = false;
    }else{
      var tmp = int.tryParse(str);
      if(tmp ==null)
        return true;
      dr.addNum(tmp);
    }
    return false;
  }
}