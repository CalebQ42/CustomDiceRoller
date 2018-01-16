package com.apps.darkstorm.cdr.dice

import com.apps.darkstorm.cdr.CDR

class DiceFormula {
    companion object {
        fun solve(str: String, cdr: CDR): DiceResults{
            val dr = DiceResults()
            var last = 0
            var problem = false
            outside@ for(i in str.indices){
                if(str[i]=='{'){
                    for (j in i until str.length){
                        if(str[j]=='}') {
                            val prob = parse(str.substring(last, j + 1), dr,cdr)
                            if (prob) {
                                problem = true
                                break@outside
                            }
                            last = j + 1
                        }
                    }
                }else if (str[i] == '+' || str[i] == '-'){
                    val prob = parse(str.substring(last,i),dr,cdr)
                    if(prob){
                        problem = true
                        break
                    }
                    last = i
                }
            }
            println("Hello: "+ problem.toString())
            if(!problem) {
                if (last <= str.length - 1)
                    problem = parse(str.substring(last), dr,cdr)
            }
            dr.problem = problem
            return dr
        }
        private fun parse(str: String, dr: DiceResults, cdr: CDR): Boolean{
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
                    dr.subtractMode = str.startsWith("-")
                    str.removePrefix("+")
                    str.removePrefix("-")
                    if(str.indexOf('{')!=0 && str[str.indexOf('{') - 1] == 'd')
                        str.removeRange(str.indexOf('{') - 1, str.indexOf('{'))
                    val pre = (if(str.indexOf('{')!=0)
                        str.substring(0,str.indexOf('{')).toIntOrNull()
                    else
                        1) ?: return true
                    var inner = str.substring(str.indexOf('{')+1,str.lastIndexOf('}'))
                    if (inner.startsWith("Die:")){
                        inner = inner.substring(4)
                        for(i in cdr.getDies("")){
                            if(i.getName() == inner){
                                val tmp = Dice()
                                for(j in 1..pre)
                                    tmp.dice.add(i.copy())
                                dr.combineWith(tmp.roll())
                                break
                            }
                        }
                    }else if(inner.startsWith("Group:")){
                        inner = inner.substring(6)
                        for(i in cdr.getDice("")){
                            if(i.getName() == inner){
                                val tmp = Dice()
                                for(j in 1..pre)
                                    tmp.dice.addAll(i.copy().dice)
                                dr.combineWith(tmp.roll())
                                break
                            }
                        }
                    }
                    dr.subtractMode = false
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