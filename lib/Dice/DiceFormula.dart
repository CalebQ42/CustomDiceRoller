//import 'package:customdiceroller/Dice/DiceResults.dart';
//import 'package:customdiceroller/Dice/Dice.dart';
//
//class DiceFormula{
//  static DiceResults solve(String str){
//    var dr = new DiceResults();
//    var last = 0;
//    var problem = false;
//    outside:
//    for (var i = 0;i < str.length;i++){
//      if(str.substring(i,i+1)=="{"){
//        for(var j = i;j < str.length;j++){
//          if(str.substring(j,j+1)=="}"){
//            val prob =
//          }
//        }
//      }
//    }
//  }
//  static bool parse(String str, DiceResults dr){
//    if(str.contains("d")){
//      dr.subtractMode = str.startsWith("-");
//      if(str.startsWith("+")||str.startsWith("-"))
//        str = str.substring(1);
//      int pre;
//      int post;
//      var dInd = str.indexOf("d");
//      if(dInd == str.length-1)
//        return true;
//      if(dInd ==0)
//        pre = 1;
//      else
//        pre = int.parse(str.substring(0,dInd),onError: (str)=>null);
//      post = int.parse(str.substring(dInd+1),onError: (s)=>null);
//      if(pre ==null || post ==null)
//        return true;
//      var out = Dice.numberDice(pre, post).roll();
//      dr.combineWith(out);
//      dr.subtractMode = false;
//    }
//    //TODO: Custom dice
//    return false;
//  }
//}