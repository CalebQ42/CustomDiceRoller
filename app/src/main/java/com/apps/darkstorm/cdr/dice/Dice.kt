package com.apps.darkstorm.cdr.dice

import android.util.JsonReader
import android.util.JsonToken
import android.util.JsonWriter
import com.apps.darkstorm.cdr.saveLoad.JsonSavable

class Dice(private var dice: MutableList<Die> = mutableListOf()): JsonSavable() {
    override val fileExtension = ".dice"
    override fun save(jw: JsonWriter) {
        jw.beginObject()
        jw.name("dice").beginArray()
        for(d in dice)
            d.save(jw)
        jw.endArray()
        jw.endObject()
    }
    override fun load(jr: JsonReader) {
        jr.beginObject()
        while(jr.hasNext() && jr.peek() != JsonToken.END_OBJECT){
            if(jr.peek()!= JsonToken.NAME){
                jr.skipValue()
                continue
            }
            val jName = jr.nextName()
            when(jName){
                "dice"->{
                    while(jr.peek()!= JsonToken.END_ARRAY){
                        val dc = Die()
                        dc.load(jr)
                        dice.add(dc)
                    }
                }
            }
        }
        jr.endObject()
    }
    companion object {
        val fileExtension = ".dice"
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
        dice[i] = d
    }
    fun get(i:Int) = dice[i]
    fun roll(): DiceResults{
        val dr = DiceResults()
        for(d in dice){
            val i = d.rollIndex()
            when {
                d.isComplex(i) -> {
                    val s = d.getComplex(i)
                    for (p in s!!.parts)
                        dr.add(DiceResults.Result(p.name, p.value))
                    dr.addNum(s.number)
                }
                else -> {
                    val s = d.getSimple(i)
                    if(s!!.isInt())
                        dr.addNum(s.intSide())
                    else
                        dr.add(DiceResults.Result(s.stringSide(),1))
                }
            }
        }
        return dr
    }
}