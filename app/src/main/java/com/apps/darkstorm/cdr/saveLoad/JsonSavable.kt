package com.apps.darkstorm.cdr.saveLoad

import android.util.JsonReader
import android.util.JsonWriter
import com.google.android.gms.drive.DriveFile
import com.google.android.gms.drive.DriveResourceClient
import org.jetbrains.anko.doAsync
import java.io.Reader
import java.io.Writer

abstract class JsonSavable: Cloneable{
    var editing = false
    var saving = false

    abstract fun save(jw: JsonWriter)
    abstract fun load(jr: JsonReader)
    abstract override fun equals(other: Any?): Boolean
    abstract override fun hashCode(): Int
    abstract override fun clone(): JsonSavable
    fun saveJson(wr: Writer){
        val jw = JsonWriter(wr)
        jw.isLenient = true
        jw.setIndent("  ")
        save(jw)
        jw.close()
        wr.close()
    }
    fun loadJson(rdr: Reader){
        val jr = JsonReader(rdr)
        jr.isLenient = true
        load(jr)
        jr.close()
        rdr.close()
    }

    fun stopEditing(){
        editing = false
    }
    fun startEditing(filename: String){
        if(!editing) {
            editing = true
            Save.local(this, filename)
            var tmp = clone()
            doAsync {
                while (editing) {
                    if (tmp != this && !saving) {
                        saving = true
                        Save.local(this@JsonSavable, filename)
                        tmp = clone()
                        saving = false
                    }
                    Thread.sleep(300)
                }
                if (tmp != this && !saving) {
                    saving = true
                    Save.local(this@JsonSavable, filename)
                    saving = false
                }
            }
        }
    }
    fun startEditing(drc: DriveResourceClient, df: DriveFile){
        if(!editing) {
            editing = true
            Save.drive(this, drc, df, true)
            var tmp = clone()
            while (editing) {
                if (tmp != this && !saving) {
                    saving = true
                    Save.drive(this, drc, df, true)
                    tmp = clone()
                    saving = false
                }
                Thread.sleep(300)
            }
            if (tmp != this && !saving) {
                saving = true
                Save.drive(this, drc, df, true)
                saving = false
            }
        }
    }

//    basicLoad
//    while(jr.hasNext() && jr.peek() != JsonToken.END_OBJECT){
//        if(jr.peek()!=JsonToken.NAME){
//            jr.skipValue()
//            continue
//        }
//        val jName = jr.nextName()
//        when(jName){
//        }
//    }
}