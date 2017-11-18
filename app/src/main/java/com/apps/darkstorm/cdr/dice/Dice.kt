package com.apps.darkstorm.cdr.dice

class Dice(private var dice: MutableList<Die> = mutableListOf()){
    companion object {
        fun numberDice(number: Int, sides: Int):Dice{
            val d = Dice()
            (1..number).forEach {d.add(Die.numberDie(sides))}
            println(d.dice)
            return d
        }
    }
    fun size() = dice.size
    fun add(d: Die){
        dice.add(d)
    }
    fun set(i: Int, d: Die){
        dice.set(i,d)
    }
    fun get(i:Int) = dice[i]
    fun roll(): DiceResults{
        val dr = DiceResults()
        for(d in dice){
            val i = d.roll()
            when {
                d.isComplex(i) -> {
                    val s = d.getComplex(i)
                    for (p in s!!.parts)
                        dr.add(DiceResults.Result(p.name, p.value))
                    dr.number += s.number
                }
                else -> {
                    val s = d.getSimple(i)
                    if(s!!.isInt())
                        dr.number+=s.intSide()
                    else
                        dr.set(s.stringSide(),dr.get(s.stringSide())+1)
                }
            }
        }
        return dr
    }
}