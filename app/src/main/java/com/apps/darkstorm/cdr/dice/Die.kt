package com.apps.darkstorm.cdr.dice

import android.util.JsonReader
import android.util.JsonToken
import android.util.JsonWriter
import com.apps.darkstorm.cdr.CDR
import com.apps.darkstorm.cdr.saveLoad.JsonSavable
import com.apps.darkstorm.cdr.saveLoad.Save
import java.io.File
import java.util.*

data class Die(var sides: MutableList<JsonSavable> = mutableListOf(),private var name: String = ""): JsonSavable() {
    companion object {
        val fileExtension = ".die"
        fun numberDie(i:Int): Die{
            val d = Die()
            (1..i).forEach {
                d.sides.add(SimpleSide(it.toString()))
            }
            return d
        }
    }

    val fileExtension = ".die"

    override fun clone() = copy()
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
                "name"->name = jr.nextString()
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
        jw.name("name").value(name)
        jw.name("isComplex").beginArray()
        for(i in 0 until sides.size)
            jw.value(isComplex(i))
        jw.endArray()
        jw.name("sides").beginArray()
        for(s in sides)
            s.save(jw)
        jw.endArray()
        jw.endObject()
    }
    fun isComplex(i: Int) = sides[i] is ComplexSide
    fun getComplex(i: Int) = sides[i] as? ComplexSide
    fun getSimple(i: Int) = sides[i] as? SimpleSide
    fun rollIndex(): Int = Random().nextInt(sides.size)
    fun roll(): Any = sides[rollIndex()]
    override fun toString() = name + " " +  sides.toString()
    fun localLocation(cdr: CDR) = cdr.dir+"/"+name+fileExtension
    fun delete(cdr: CDR){
        File(localLocation(cdr)).delete()
    }
    fun rename(newName: String,cdr: CDR){
        while (saving)
            Thread.sleep(200)
        saving = true
        File(localLocation(cdr)).delete()
        name = newName
        Save.local(this,localLocation(cdr))
        saving = false
    }
    fun renameNoFileMove(newName: String){
        name = newName
    }
    fun getName() = name
}
