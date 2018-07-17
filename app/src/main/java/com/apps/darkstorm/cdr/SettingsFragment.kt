package com.apps.darkstorm.cdr

import android.app.Activity
import android.app.AlertDialog
import android.content.Intent
import android.os.Bundle
import android.support.v4.app.Fragment
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.support.v7.widget.Toolbar
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Switch
import com.apps.darkstorm.cdr.custVars.Setting
import com.apps.darkstorm.cdr.saveLoad.Save
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.drive.Drive
import org.jetbrains.anko.appcompat.v7.titleResource
import org.jetbrains.anko.find
import org.jetbrains.anko.support.v4.act

class SettingsFragment: Fragment(){
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//    }
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View =
            inflater.inflate(R.layout.recycle,container,false)
    private lateinit var adap: SettingsAdap
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        val toolbar = act.findViewById<Toolbar>(R.id.toolbar)
        toolbar.titleResource = R.string.settings_nav_drawer
        val settings = arrayOf(Setting(R.string.individual_first_text,getString(R.string.individual_first_key), false,(act.application as CDR).prefs,Setting.boolean),
                Setting(R.string.google_drive_text,getString(R.string.google_drive_key),false,(act.application as CDR).prefs,Setting.boolean),
                Setting(R.string.theme_text,getString(R.string.theme_key),false,(act.application as CDR).prefs,Setting.boolean),
                Setting(R.string.default_section,getString(R.string.default_section_key),0,(act.application as CDR).prefs,Setting.multipleChoice))
        settings[1].addCheckedChangedListener { b ->
            if(b) {
                val signInOptions = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
                        .requestScopes(Drive.SCOPE_APPFOLDER)
                        .build()
                (act.application as CDR).gsi = GoogleSignIn.getClient(act, signInOptions)
                startActivityForResult((act.application as CDR).gsi.signInIntent, 0)
            }else{
                (act.application as CDR).gsi.signOut()
            }
        }
        settings[2].addCheckedChangedListener { _ ->
            act.recreate()
        }
        settings[3].setSpinnerItems(act.resources.getStringArray(R.array.default_opening))
        (act.application as CDR).fab.hide()
        val r = view.find<RecyclerView>(R.id.recycler)
        adap = SettingsAdap(settings)
        r.adapter = adap
        val lm = LinearLayoutManager(view.context)
        lm.orientation = LinearLayoutManager.VERTICAL
        r.layoutManager = lm
    }
    inner class SettingsAdap(private var settings: Array<Setting>): RecyclerView.Adapter<SettingsAdap.ViewHolder>() {
        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder = when(viewType){
            Setting.boolean-> ViewHolder(Setting.createSwitch(act.layoutInflater,parent,false))
            Setting.multipleChoice-> ViewHolder(Setting.createSpinner(act.layoutInflater,parent,false))
            Setting.stringValue-> ViewHolder(Setting.createStringEdit(act.layoutInflater,parent,false))
            else-> ViewHolder(Setting.createDivider(act.layoutInflater,parent,false))
        }
        override fun onBindViewHolder(holder: ViewHolder, position: Int) {
            when(getItemViewType(position)){
                Setting.boolean->settings[position/2].linkToSwitch(holder.v as Switch)
                Setting.multipleChoice->settings[position/2].linkToSpinner(act,holder.v)
                Setting.stringValue->settings[position/2].linkToString(act,holder.v)
            }
        }
        override fun getItemCount() = settings.size*2
        override fun getItemViewType(position: Int) =
            if(position%2 == 1)
                Setting.divider
            else
                settings[position/2].type
        inner class ViewHolder(val v: View): RecyclerView.ViewHolder(v)
    }
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        when(requestCode){
            0->{
                if (resultCode == Activity.RESULT_OK){
                    (act.application as CDR).dc = Drive.getDriveClient(act.applicationContext, GoogleSignIn.getLastSignedInAccount(act.application)!!)
                    (act.application as CDR).drc = Drive.getDriveResourceClient(act.applicationContext, GoogleSignIn.getLastSignedInAccount(act.application)!!)
                    val bu = AlertDialog.Builder(act)
                    bu.setView(R.layout.waiting_sync)
                    bu.setCancelable(false)
                    val dia = bu.create()
                    if((act.application as CDR).getDies("").size>0 || (act.application as CDR).getDice("").size>0){
                        val b = AlertDialog.Builder(act)
                        b.setMessage(R.string.upload_profiles_drive)
                        b.setPositiveButton(android.R.string.yes) { di, _->
                            di.cancel()
                            for(d in (act.application as CDR).getDies(""))
                                Save.drive(d,(act.application as CDR).drc,d.driveFile((act.application as CDR))!!,true)
                            for(d in (act.application as CDR).getDice(""))
                                Save.drive(d,(act.application as CDR).drc,d.driveFile((act.application as CDR))!!,true)
                        }.setOnCancelListener { dia.show() }.show()
                    }else
                        dia.show()
                    (act.application as CDR).sync {dia.cancel()}
                }else {
                    (act.application as CDR).prefs.edit().putBoolean(getString(R.string.google_drive_key), false).apply()
                    adap.notifyItemChanged(2)
                }
            }
            else->super.onActivityResult(requestCode, resultCode, data)
        }
    }
}