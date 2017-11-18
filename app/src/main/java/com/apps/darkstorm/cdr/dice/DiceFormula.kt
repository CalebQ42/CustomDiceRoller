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
            println("thing:" + str)
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
                        0
                    else
                        str.substring(0,dInd).toInt()
                    post = str.substring(dInd+1).toInt()
                    dr.number += if(sub)
                            -1*Dice.numberDice(pre,post).roll().number
                        else
                            Dice.numberDice(pre,post).roll().number
                    println("Pre: "+pre.toString())
                    println("Post: "+post.toString())
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