package com.apps.darkstorm.cdr.dice

class DiceFormula {
    companion object {
        fun solve(str: String): DiceResults{
            val dr = DiceResults()
            var last = 0
            var problem = false
            for(i in str.indices){
                if (str[i] == '+' || str[i] == '-'){
                    val prob = parse(str.substring(last,i),dr)
                    if(prob){
                        problem = true
                        break
                    }
                    last = i
                }
            }
            if(!problem) {
                if (last != str.length - 1)
                    problem = parse(str.substring(last), dr)
            }
            dr.problem = problem
            return dr
        }
        private fun parse(str: String, dr: DiceResults): Boolean{
            when{
                str.contains("d")->{
                    dr.subtractMode = str.startsWith("-")
                    str.removePrefix("+")
                    str.removePrefix("-")
                    val pre: Int?
                    val post: Int?
                    val dInd = str.indexOf("d")
                    if(dInd==str.length-1)
                        return true
                    pre = if(dInd==0)
                        1
                    else
                        str.substring(0,dInd).toIntOrNull()
                    post = str.substring(dInd+1).toIntOrNull()
                    if(pre == null || post == null)
                        return true
                    val out = Dice.numberDice(pre,post).roll()
                    dr.combineWith(out)
                    dr.subtractMode = false
                }
                str.contains("{") && str.contains("}")->{
                    val sub = str.startsWith("-")
                    str.removePrefix("+")
                    str.removePrefix("-")
                    //proper parsley once functionality implemented
                }
                else->{
                    val tmp = str.toIntOrNull() ?: return true
                    dr.addNum(tmp)
                }
            }
            return false
        }
    }
}