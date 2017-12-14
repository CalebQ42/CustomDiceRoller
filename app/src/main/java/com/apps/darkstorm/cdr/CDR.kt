package com.apps.darkstorm.cdr

import android.app.Application
import android.content.Context
import android.content.SharedPreferences
import com.apps.darkstorm.cdr.dice.Dice
import com.apps.darkstorm.cdr.dice.Die
import java.io.File

class CDR: Application(){
    lateinit var prefs: SharedPreferences
    lateinit var dir: String
    lateinit var diceMaster: MutableList<Dice>
    lateinit var dieMaster: MutableList<Die>
    override fun onCreate() {
        prefs = getSharedPreferences(getString(R.string.preference_key), Context.MODE_PRIVATE)
        super.onCreate()
    }
    fun reloadDieMaster(){
        dieMaster = mutableListOf()
        val root = File(dir)
        root.listFiles().forEach { fil ->
            if(fil.isFile && fil.name.endsWith(Die.fileExtension)){
                val tmp = Die()
                tmp.loadJson(fil.reader())
                dieMaster.add(tmp)
            }
        }
    }
    fun reloadDiceMaster(){
        diceMaster = mutableListOf()
        val root = File(dir)
        root.listFiles().forEach { fil ->
            if(fil.isFile && fil.name.endsWith(Dice.fileExtension)){
                val tmp = Dice()
                tmp.loadJson(fil.reader())
                diceMaster.add(tmp)
            }
        }
    }
    fun reloadAll(){
        reloadDieMaster()
        reloadDiceMaster()
    }
}