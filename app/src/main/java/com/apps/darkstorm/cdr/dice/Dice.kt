package com.apps.darkstorm.cdr.dice

import android.util.JsonReader
import android.util.JsonToken
import android.util.JsonWriter
import com.apps.darkstorm.cdr.CDR
import com.apps.darkstorm.cdr.saveLoad.JsonSavable
import com.apps.darkstorm.cdr.saveLoad.Save
import java.io.File

data class Dice(var dice: MutableList<Die> = mutableListOf()): JsonSavable() {
    companion object {
        val fileExtension = ".dice"
        fun numberDice(number: Int, sides: Int):Dice{
            val d = Dice()
            (1..number).forEach {d.dice.add(Die.numberDie(sides))}
            return d
        }
    }

    private var name: String = ""
    val fileExtension = ".dice"

    override fun clone() = copy()
    override fun save(jw: JsonWriter) {
        jw.beginObject()
        jw.name("name").value(name)
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
                "name"->name = jr.nextString()
                "dice"-> {
                    jr.beginArray()
                    while (jr.peek() != JsonToken.END_ARRAY) {
                        val dc = Die()
                        dc.load(jr)
                        dice.add(dc)
                    }
                    jr.endArray()
                }
            }
        }
        jr.endObject()
    }
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
    fun localLocation(cdr: CDR) = cdr.dir+"/"+name+fileExtension
    fun rename(newName: String,cdr: CDR){
        File(localLocation(cdr)).delete()
        name = newName
        Save.local(this,localLocation(cdr))
    }
    fun renameNoFileMove(newName: String){
        name = newName
    }
    fun getName() = name
}