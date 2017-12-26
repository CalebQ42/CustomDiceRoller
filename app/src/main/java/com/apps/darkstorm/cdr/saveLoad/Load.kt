package com.apps.darkstorm.cdr.saveLoad

import com.google.android.gms.drive.DriveFile
import com.google.android.gms.drive.DriveResourceClient
import java.io.File
import java.io.InputStreamReader

object Load{
    fun local(js: JsonSavable,filename: String){
        if(File(filename+".bak").exists()) {
            js.loadJson(File(filename).reader())
            Save.local(js,filename)
            File(filename+".bak").delete()
        }else
            js.loadJson(File(filename).reader())
    }
    fun drive(js: JsonSavable, drc: DriveResourceClient, df: DriveFile, blocking: Boolean){
        var done= false
        drc.openFile(df, DriveFile.MODE_READ_ONLY).addOnSuccessListener { driveContents ->
            js.loadJson(InputStreamReader(driveContents.inputStream))
            done = true
        }
        if(blocking){
            while(!done)
                Thread.sleep(300)
        }
    }
}