package com.apps.darkstorm.cdr

import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import org.jetbrains.anko.startActivity
import java.io.File

class SplashScreen : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val tmpFile = File(applicationInfo.dataDir+"/Dice")
        tmpFile.mkdir()
        (application as CDR).dir = tmpFile.absolutePath
        (application as CDR).reloadAll()
        finish()
    }

    override fun finish() {
        startActivity<MainActivity>()
        super.finish()
    }
}
