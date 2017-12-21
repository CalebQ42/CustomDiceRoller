package com.apps.darkstorm.cdr.dice

import android.util.JsonReader
import android.util.JsonToken
import android.util.JsonWriter
import com.apps.darkstorm.cdr.saveLoad.JsonSavable
import java.util.*

class Die: JsonSavable() {
    val name: String = ""
    val fileExtension = ".die"
    override fun load(jr: JsonReader) {
        jr.beginObject()
        val sideTypes = mutableListOf<Boolean>()
        while(jr.hasNext() && jr.peek() != JsonToken.END_OBJECT){
            if(jr.peek()!= JsonToken.NAME){
                jr.skipValue()
                continue
            }
            val jName = jr.nextName()
            when(jName){
                "isComplex"->{
                    jr.beginArray()
                    while(jr.peek()!=JsonToken.END_ARRAY)
                        sideTypes.add(jr.nextBoolean())
                    jr.endArray()
                }
                "sides"->{
                    jr.beginArray()
                    var i = 0
                    while(jr.peek()!=JsonToken.END_ARRAY){
                        when(sideTypes[i]){
                            true->{
                                val cs = ComplexSide()
                                cs.load(jr)
                                sides.add(cs)
                            }
                            else->{
                                val ss = SimpleSide("")
                                ss.load(jr)
                                sides.add(ss)
                            }
                        }
                        i++
                    }
                    jr.endArray()
                }
            }
        }
        jr.endObject()
    }
    override fun save(jw: JsonWriter) {
        jw.beginObject()
        jw.name("isComplex").beginArray()
        for(i in 0..size())
            jw.value(isComplex(i))
        jw.name("sides").beginArray()
        for(s in sides)
            s.save(jw)
        jw.endArray()
        jw.endObject()
    }
    companion object {
        val fileExtension = ".die"
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
    fun rollIndex(): Int = Random().nextInt(size())
    fun roll(): Any = sides[rollIndex()]
    override fun toString() = sides.toString()
}
