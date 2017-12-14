package com.apps.darkstorm.cdr.saveLoad

import com.google.android.gms.drive.DriveFile
import com.google.android.gms.drive.DriveResourceClient
import java.io.File
import java.io.OutputStreamWriter

object Save{
    fun local(js: JsonSavable,filename: String) = js.saveJson(File(filename).writer())
    fun drive(js: JsonSavable,drc: DriveResourceClient,df: DriveFile, blocking: Boolean){
        var done= false
        drc.openFile(df,DriveFile.MODE_WRITE_ONLY).addOnSuccessListener {driveContents ->
            js.saveJson(OutputStreamWriter(driveContents.outputStream))
            done = true
        }
        if(blocking){
            while(!done)
                Thread.sleep(300)
        }
    }
}