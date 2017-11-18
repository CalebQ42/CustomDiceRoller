package com.apps.darkstorm.cdr.dice

class DiceFormula {
    companion object {
        fun solve(str: String): DiceResults{
            val dr = DiceResults()
            var last = 0
            for(i in str.indices){
                if (str[i] == '+' || str[i] == '-'){
                    parse(str.substring(last,i),dr)
                    last = i
                }
            }
            if(last != str.length-1)
                parse(str.substring(last),dr)
            return dr
        }
        private fun parse(str: String, dr: DiceResults){
            when{
                str.contains("d")->{
                    val sub = str.startsWith("-")
                    str.removePrefix("+")
                    str.removePrefix("-")
                    val pre: Int
                    val post: Int
                    val dInd = str.indexOf("d")
                    if(dInd==str.length-1)
                        return
                    pre = if(dInd==0)
                        1
                    else
                        str.substring(0,dInd).toInt()
                    post = str.substring(dInd+1).toInt()
                    val out = Dice.numberDice(pre,post).roll()
                    if(sub)
                        out.number *=-1
                    println("Hello: "+out.number)
                    println("gobble: "+dr.number)
                    dr.combineWith(out)
                }
                str.contains("{") && str.contains("}")->{
                    val sub = str.startsWith("-")
                    str.removePrefix("+")
                    str.removePrefix("-")
                    //proper parsley once functionality implemented
                }
                else->dr.number += str.toInt()
            }
        }
    }
}