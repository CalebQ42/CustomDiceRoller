package com.apps.darkstorm.cdr.SaveLoad

import android.util.JsonReader
import android.util.JsonWriter
import java.io.Reader
import java.io.Writer

abstract class JsonSavable{
    abstract fun save(jw: JsonWriter)
    abstract fun load(jr: JsonReader)
    fun saveJson(wr: Writer){
        val jw = JsonWriter(wr)
        jw.beginObject()
        save(jw)
        jw.endObject()
        jw.close()
        wr.close()
    }
    fun loadJson(rdr: Reader){
        val jr = JsonReader(rdr)
        jr.beginObject()
        load(jr)
        jr.endObject()
        jr.close()
        rdr.close()
    }

//    basicLoad
//    while(jr.hasNext() && jr.peek() != JsonToken.END_OBJECT){
//        val jName = jr.nextName()
//        when(jName){
//        }
//    }
}