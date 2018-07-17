package com.apps.darkstorm.cdr

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.util.AttributeSet
import android.view.View
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.drive.Drive
import org.jetbrains.anko.startActivity
import java.io.File


class SplashScreen : AppCompatActivity() {

    override fun onCreateView(name: String?, context: Context?, attrs: AttributeSet?): View? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val tmpFile = File(applicationInfo.dataDir+"/Dice")
        tmpFile.mkdir()
        tmpFile.setWritable(true)
        tmpFile.setReadable(true)
        (application as CDR).dir = tmpFile.absolutePath
        if((application as CDR).prefs.getBoolean(getString(R.string.google_drive_key),false)){
            val signInOptions = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
                    .requestScopes(Drive.SCOPE_FILE)
                    .build()
            (application as CDR).gsi = GoogleSignIn.getClient(this,signInOptions)
            startActivityForResult((application as CDR).gsi.signInIntent,0)
        }else {
            (application as CDR).reloadAll()
            finish()
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        when(requestCode){
            0->{
                if (resultCode == Activity.RESULT_OK){
                    (application as CDR).dc = Drive.getDriveClient(applicationContext,GoogleSignIn.getLastSignedInAccount(application)!!)
                    (application as CDR).drc = Drive.getDriveResourceClient(applicationContext,GoogleSignIn.getLastSignedInAccount(application)!!)
                    (application as CDR).sync {finish()}
                }else {
                    startActivityForResult((application as CDR).gsi.signInIntent,0)
                    finish()
                }
            }
        }
    }

    override fun finish() {
        startActivity<MainActivity>()
        super.finish()
    }
}
