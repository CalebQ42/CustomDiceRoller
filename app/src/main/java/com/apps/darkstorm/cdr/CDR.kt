package com.apps.darkstorm.cdr

import android.app.Application
import android.content.Context
import android.content.SharedPreferences
import com.apps.darkstorm.cdr.custVars.FloatingActionMenu
import com.apps.darkstorm.cdr.dice.Dice
import com.apps.darkstorm.cdr.dice.Die
import java.io.File

class CDR: Application(){
    lateinit var prefs: SharedPreferences
    lateinit var dir: String
    lateinit private var diceMaster: MutableList<Dice>
    lateinit private var dieMaster: MutableList<Die>
    lateinit var fab: FloatingActionMenu
    fun getDies(str: String): MutableList<Die>{
        dieMaster.sortBy { it.getName() }
        if(str=="")
            return dieMaster
        return dieMaster
                .filter { it.getName().contains(str) }
                .toMutableList()
    }
    fun removeDieAt(str: String, i: Int){
        getDies(str)[i].delete(this)
        dieMaster.remove(getDies(str)[i])
    }
    fun getDice(str: String): MutableList<Dice>{
        diceMaster.sortBy { it.getName() }
        if(str=="")
            return diceMaster
        return diceMaster
                .filter { it.getName().contains(str) }
                .toMutableList()
    }
    fun removeDiceAt(str: String, i: Int){
        getDice(str)[i].delete(this)
        diceMaster.remove(getDice(str)[i])
    }
    fun addNewDie(): Die {
        val newy = Die()
        newy.renameNoFileMove("New Die")
        var i = 1
        while(dieMaster.find { d->
                d.getName() == newy.getName()
            }!=null){
            newy.renameNoFileMove("New Die" + i.toString())
            i++
        }
        dieMaster.add(newy)
        return newy
    }
    fun addNewGroup(): Dice {
        val newy = Dice()
        newy.renameNoFileMove("New Group")
        var i = 1
        while(dieMaster.find { d->
                d.getName() == newy.getName()
            }!=null){
            newy.renameNoFileMove("New Group" + i.toString())
            i++
        }
        diceMaster.add(newy)
        return newy
    }
    override fun onCreate() {
        prefs = getSharedPreferences(getString(R.string.preference_key), Context.MODE_PRIVATE)
        super.onCreate()
    }
    fun reloadDieMaster(){
        dieMaster = mutableListOf()
        val root = File(dir)
        root.listFiles().forEach { fil ->
            if(fil.isFile && fil.name.endsWith(Die.fileExtension)){
                val bak = File(fil.absolutePath+".bak")
                if(bak.exists()){
                    val tmp = Die()
                    tmp.loadJson(bak.reader())
                    dieMaster.add(tmp)
                    bak.delete()
                    tmp.saveJson(fil.writer())
                }else {
                    val tmp = Die()
                    tmp.loadJson(fil.reader())
                    dieMaster.add(tmp)
                }
            }
        }
        dieMaster.sortBy { it.getName() }
    }
    fun reloadDiceMaster(){
        diceMaster = mutableListOf()
        val root = File(dir)
        root.listFiles().forEach { fil ->
            if(fil.isFile && fil.name.endsWith(Dice.fileExtension)){
                val bak = File(fil.absolutePath+".bak")
                if(bak.exists()){
                    val tmp = Dice()
                    tmp.loadJson(fil.reader())
                    diceMaster.add(tmp)
                    bak.delete()
                    tmp.saveJson(fil.writer())
                }else {
                    val tmp = Dice()
                    tmp.loadJson(fil.reader())
                    diceMaster.add(tmp)
                }
            }
        }
        diceMaster.sortBy { it.getName() }
    }
    fun reloadAll(){
        reloadDieMaster()
        reloadDiceMaster()
    }
}