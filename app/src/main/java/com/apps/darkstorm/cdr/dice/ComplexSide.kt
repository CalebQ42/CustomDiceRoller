package com.apps.darkstorm.cdr.dice

import android.util.JsonReader
import android.util.JsonToken
import android.util.JsonWriter
import com.apps.darkstorm.cdr.saveLoad.JsonSavable

data class ComplexSide(var number: Int = 0,var parts: MutableList<ComplexSidePart> = mutableListOf()): JsonSavable() {
    fun addPart(side: ComplexSidePart) = parts.add(side)
    fun size() = parts.size
    fun get(i: Int) = parts[i]
    fun set(i: Int, side: ComplexSidePart){
        parts[i] = side
    }
    fun add(side: ComplexSidePart) = parts.add(side)
    override fun toString(): String {
        var out = number.toString() + ", "
        out += parts.toString()
        return out
    }
    override fun clone() = this.copy()
    override fun save(jw: JsonWriter) {
        jw.beginObject()
        jw.name("number").value(number)
        jw.name("parts").beginArray()
        for(pt in parts)
            pt.save(jw)
        jw.endArray()
        jw.endObject()
    }
    override fun load(jr: JsonReader) {
        jr.beginObject()
        while(jr.hasNext() && jr.peek() != JsonToken.END_OBJECT){
            if(jr.peek()!=JsonToken.NAME){
                jr.skipValue()
                continue
            }
            val jName = jr.nextName()
            when(jName){
                "number"->number = jr.nextInt()
                "parts"->{
                    parts.clear()
                    jr.beginArray()
                    while(jr.peek()!=JsonToken.END_ARRAY){
                        val tmp = ComplexSidePart("",0)
                        tmp.load(jr)
                        parts.add(tmp)
                    }
                    jr.endArray()
                }
            }
        }
        jr.endObject()
    }
    data class ComplexSidePart(var name: String, var value: Int): JsonSavable(){
        override fun clone() = copy()
        override fun load(jr: JsonReader) {
            jr.beginObject()
            while(jr.hasNext() && jr.peek() != JsonToken.END_OBJECT){
                if(jr.peek()!=JsonToken.NAME){
                    jr.skipValue()
                    continue
                }
                val name = jr.nextName()
                when(name){
                    "Name"->this.name = jr.nextString()
                    "Value"->value=jr.nextInt()
                }
            }
            jr.endObject()
        }
        override fun save(jw: JsonWriter) {
            jw.beginObject()
            jw.name("Name").value(name)
            jw.name("Value").value(value)
            jw.endObject()
        }
    }
}

//class ComplexSide: JsonSavable() {
//    fun addPart(side: ComplexSidePart) = parts.add(side)
//    fun size() = parts.size
//    fun get(i: Int) = parts[i]
//    fun set(i: Int, side: ComplexSidePart){
//        parts[i] = side
//    }
//    fun add(side: ComplexSidePart) = parts.add(side)
//    override fun toString(): String {
//        var out = number.toString() + ", "
//        out += parts.toString()
//        return out
//    }
//    override fun equals(other: Any?): Boolean {
//        if (this === other) return true
//        if (other !is ComplexSide) return false
//
//        if (number != other.number) return false
//        if (parts != other.parts) return false
//
//        return true
//    }
//    override fun hashCode(): Int {
//        var result = number
//        result = 31 * result + parts.hashCode()
//        return result
//    }
//}