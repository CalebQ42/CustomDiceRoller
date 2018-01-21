package com.apps.darkstorm.cdr.dice

import android.util.JsonReader
import android.util.JsonToken
import android.util.JsonWriter
import com.apps.darkstorm.cdr.CDR
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

data class Dice(var dice: MutableList<Die> = mutableListOf(), var modifier: Int = 0,private var name: String = ""): JsonSavable() {
    companion object {
        val fileExtension = ".dice"
        fun numberDice(number: Int, sides: Int):Dice{
            val d = Dice()
            (1..number).forEach {d.dice.add(Die.numberDie(sides))}
            return d
        }
    }

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