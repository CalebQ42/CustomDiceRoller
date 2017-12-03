package com.apps.darkstorm.cdr.dice

import android.util.JsonReader
import android.util.JsonToken
import android.util.JsonWriter
import com.apps.darkstorm.cdr.SaveLoad.JsonSavable

class SimpleSide: JsonSavable {
    override fun save(jw: JsonWriter) {
        jw.beginObject()
        jw.name("value").value(value)
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
            }
        }
        jr.endObject()
    }

    private var value = ""
    constructor(value: String){
        this.value = value
    }
    constructor(value: Int){
        this.value = value.toString()
    }
    fun intSide() = value.toInt()
    fun stringSide() = value
    fun isInt() = value.toIntOrNull() != null
    fun set(side: String){
        value = side
    }
    fun set(side: Int){
        value = side.toString()
    }
    override fun toString() = value
}