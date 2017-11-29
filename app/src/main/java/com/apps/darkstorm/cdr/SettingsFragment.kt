package com.apps.darkstorm.cdr

import android.app.Fragment
import android.os.Bundle
import android.support.design.widget.FloatingActionButton
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.CompoundButton
import android.widget.Switch
import org.jetbrains.anko.act
import org.jetbrains.anko.find

class SettingsFragment: Fragment(){
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View =
            inflater.inflate(R.layout.recycle,container,false)
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        act.find<FloatingActionButton>(R.id.fab).hide()
        val r = view.find<RecyclerView>(R.id.recycler)
        r.adapter = SettingsAdap()
        val lm = LinearLayoutManager(view.context)
        lm.orientation = LinearLayoutManager.VERTICAL
        r.layoutManager = lm
    }
    fun simpleSwitch(resIDText: Int,resIDKey: Int,sw: Switch){
        sw.text = getString(resIDText)
        sw.isChecked = (act.application as CDR).prefs.getBoolean(getString(resIDKey),false)
        sw.setOnCheckedChangeListener{ _: CompoundButton, b: Boolean ->
            (act.application as CDR).prefs.edit().putBoolean(getString(resIDKey),b).apply()
        }
    }
    inner class SettingsAdap: RecyclerView.Adapter<SettingsAdap.ViewHolder>() {
        override fun onCreateViewHolder(parent: ViewGroup?, viewType: Int): ViewHolder? = when(viewType){
            0-> ViewHolder(activity.layoutInflater.inflate(R.layout.settings_switch,parent,false))
            1-> ViewHolder(activity.layoutInflater.inflate(R.layout.settings_divider,parent,false))
            else -> null
        }
        override fun onBindViewHolder(holder: ViewHolder, position: Int) {
            when(position){
                0-> simpleSwitch(R.string.individual_first_text,R.string.individual_first_key,holder.v.find(R.id.sw))
                2-> simpleSwitch(R.string.google_drive_text,R.string.google_drive_key,holder.v.find(R.id.sw))
            }
        }
        override fun getItemCount() = 1
        override fun getItemViewType(position: Int) = position%2
        inner class ViewHolder(val v: View): RecyclerView.ViewHolder(v)
    }
}