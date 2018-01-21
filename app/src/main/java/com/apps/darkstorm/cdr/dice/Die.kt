package com.apps.darkstorm.cdr.dice

import android.util.JsonReader
import android.util.JsonToken
import android.util.JsonWriter
import com.apps.darkstorm.cdr.CDR
import com.apps.darkstorm.cdr.R
import com.apps.darkstorm.cdr.saveLoad.JsonSavable
import com.apps.darkstorm.cdr.saveLoad.Save
import com.google.android.gms.drive.DriveFile
import com.google.android.gms.drive.DriveFolder
import com.google.android.gms.drive.MetadataChangeSet
import com.google.android.gms.drive.query.Filters
import com.google.android.gms.drive.query.Query
import com.google.android.gms.drive.query.SearchableField
import com.google.android.gms.tasks.Tasks
import java.io.File
import java.util.*

data class Die(var sides: MutableList<JsonSavable> = mutableListOf(), private var name: String = ""): JsonSavable() {
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
    override fun toString() = name + " " +  sides.toString()
    fun localLocation(cdr: CDR) = cdr.dir+"/"+name.replace(" ","_")+fileExtension
    fun driveFile(cdr: CDR): DriveFile?{
        var out: DriveFile? = null
        val res = cdr.drc.appFolder
        Tasks.await(res)
        if(!res.isSuccessful)
            return out
        val appFold: DriveFolder = res.result
        val childRes = cdr.drc.queryChildren(appFold, Query.Builder().addFilter(Filters.eq(SearchableField.TITLE,name.replace(" ","_")+fileExtension)).build())
        Tasks.await(childRes)
        if(!childRes.isSuccessful)
            return out
        val metBuf = childRes.result
        out = if(metBuf.count ==0){
            val createRes = cdr.drc.createFile(appFold, MetadataChangeSet.Builder().setTitle(name.replace(" ","_")+fileExtension).build(),null)
            Tasks.await(createRes)
            if(!createRes.isSuccessful)
                return out
            createRes.result
        }else
            metBuf[0].driveId.asDriveFile()
        childRes.result.release()
        return out
    }
    fun delete(cdr: CDR){
        File(localLocation(cdr)).delete()
        if(cdr.prefs.getBoolean(cdr.getString(R.string.google_drive_key),false))
            driveFile(cdr)?.driveId?.asDriveResource()?.let { cdr.drc.delete(it) }
    }
    fun rename(newName: String,cdr: CDR){
        while (saving)
            Thread.sleep(200)
        saving = true
        File(localLocation(cdr)).delete()
        name = newName
        Save.local(this,localLocation(cdr))
        if(cdr.prefs.getBoolean(cdr.getString(R.string.google_drive_key),false)) {
            driveFile(cdr)?.driveId?.asDriveResource()?.let {
                cdr.drc.updateMetadata(it,MetadataChangeSet.Builder().setTitle(name.replace(" ","_")+fileExtension).build())
            }
        }
        saving = false
    }
    fun renameNoFileMove(newName: String){
        name = newName
    }
    fun getName() = name
}
