package com.apps.darkstorm.cdr.dice

import android.util.JsonWriter
import com.apps.darkstorm.cdr.SaveLoad.JsonSavable
import java.util.*

class Die: JsonSavable() {
    override fun save(jw: JsonWriter) {
        jw.beginObject()
        jw.name("sides").beginArray()
        for(s in sides)
            s.save(jw)
        jw.endArray()
        jw.endObject()
    }
    companion object {
        fun numberDie(i:Int): Die{
            val d = Die()
            (1..i).forEach {
                d.add(SimpleSide(it))
            }
            return d
        }
    }
    private var sides = mutableListOf<JsonSavable>()
    fun size() = sides.size
    fun isComplex(i: Int) = sides[i] is ComplexSide
    fun getComplex(i: Int) = sides[i] as? ComplexSide
    fun getSimple(i: Int) = sides[i] as? SimpleSide
    fun set(i: Int, a: JsonSavable){
        sides[i] = a
    }
    fun add(a: JsonSavable){
        sides.add(a)
    }
    fun roll(): Int = Random().nextInt(size())
    override fun toString() = sides.toString()
}
