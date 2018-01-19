package com.apps.darkstorm.cdr

import android.app.Application
import android.content.Context
import android.content.SharedPreferences
import com.apps.darkstorm.cdr.custVars.FloatingActionMenu
import com.apps.darkstorm.cdr.dice.Dice
import com.apps.darkstorm.cdr.dice.Die
import com.apps.darkstorm.cdr.saveLoad.Load
import com.apps.darkstorm.cdr.saveLoad.Save
import com.google.android.gms.auth.api.signin.GoogleSignInClient
import com.google.android.gms.drive.DriveClient
import com.google.android.gms.drive.DriveResourceClient
import com.google.android.gms.drive.query.Query
import com.google.android.gms.tasks.Tasks
import org.jetbrains.anko.doAsync
import java.io.File

class CDR: Application(){
    lateinit var gsi: GoogleSignInClient
    lateinit var dc: DriveClient
    lateinit var drc: DriveResourceClient
    var driveFail = false

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
    fun hasConflictDie(name: String): Boolean{
        val out = dieMaster.find {d->
            d.getName() == name ||
                d.getName().replace(" ","_") == name ||
                d.getName().replace(" ","_") == name.replace(" ","_")
        }
        return out != null
    }
    fun hasConflictGroup(name: String): Boolean{
        val out = diceMaster.find {d->
            d.getName() == name ||
                    d.getName().replace(" ","_") == name ||
                    d.getName().replace(" ","_") == name.replace(" ","_")
        }
        return out != null
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
                val tmp = Die()
                Load.local(tmp,fil.absolutePath)
                dieMaster.add(tmp)
            }
        }
        dieMaster.sortBy { it.getName() }
    }
    fun reloadDiceMaster(){
        diceMaster = mutableListOf()
        val root = File(dir)
        root.listFiles().forEach { fil ->
            if(fil.isFile && fil.name.endsWith(Dice.fileExtension)){
                val tmp = Dice()
                Load.local(tmp,fil.absolutePath)
                diceMaster.add(tmp)
            }
        }
        diceMaster.sortBy { it.getName() }
    }
    fun reloadAll(){
        reloadDieMaster()
        reloadDiceMaster()
    }
    fun reloadAllDrive(){
        dieMaster = mutableListOf()
        diceMaster = mutableListOf()
        try {
            val syncRes = dc.requestSync()
            Tasks.await(syncRes)
        }catch(_: java.util.concurrent.ExecutionException){}
        val appFoldRes = drc.rootFolder
        Tasks.await(appFoldRes)
        val appFold = appFoldRes.result
        val queryRes = drc.queryChildren(appFold, Query.Builder().build())
        Tasks.await(queryRes)
        val out = queryRes.result
        out.forEach { met ->
            if(met.title.endsWith(Die.fileExtension) && !met.isTrashed) {
                val tmp = Die()
                Load.drive(tmp,drc,met.driveId.asDriveFile(),true)
                dieMaster.add(tmp)
            }else if(met.title.endsWith(Dice.fileExtension) && !met.isTrashed){
                val tmp = Dice()
                Load.drive(tmp,drc,met.driveId.asDriveFile(),true)
                diceMaster.add(tmp)
            }
        }
        out.release()
        dieMaster.sortBy { it.getName() }
        diceMaster.sortBy { it.getName() }
    }
    fun sync(postExecute: ()->Unit){
        doAsync{
            reloadAllDrive()
            val localDie = mutableListOf<Die>()
            val localDice = mutableListOf<Dice>()
            val root = File(dir)
            root.listFiles().forEach { fil ->
                if(fil.isFile && fil.name.endsWith(Dice.fileExtension)){
                    val tmp = Dice()
                    Load.local(tmp,fil.absolutePath)
                    localDice.add(tmp)
                }else if(fil.isFile && fil.name.endsWith(Die.fileExtension)){
                    val tmp = Die()
                    Load.local(tmp,fil.absolutePath)
                    localDie.add(tmp)
                }
            }
            dieMaster.forEach {die ->
                val d = localDie.find{it.getName() == die.getName()}
                if(d!= null){
                    val dFile = File(d.localLocation(this@CDR))
                    val dieDriveFile = die.driveFile(this@CDR)
                    if(dieDriveFile!= null) {
                        val meta = drc.getMetadata(dieDriveFile)
                        Tasks.await(meta)
                        if (dFile.lastModified() < meta.result.modifiedDate.time)
                            Save.local(die,die.localLocation(this@CDR))
                        else
                            Save.drive(d,drc,dieDriveFile,true)
                    }
                }else
                    Save.local(die,die.localLocation(this@CDR))
            }
            localDie.filter{ die->
                val d = dieMaster.find{it.getName() == die.getName()}
                d==null
            }.forEach {
                Save.drive(it,drc,it.driveFile(this@CDR)!!,true)
            }
            reloadAllDrive()
            postExecute()
        }
    }
}