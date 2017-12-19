package com.apps.darkstorm.cdr.custVars

import android.app.Activity
import android.app.AlertDialog
import android.content.SharedPreferences
import android.support.design.widget.TextInputEditText
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import com.apps.darkstorm.cdr.R
import org.jetbrains.anko.find
import org.jetbrains.anko.hintResource
import org.jetbrains.anko.textResource
class Setting(private val textID: Int, private val key: String, private val defaultValue: Any, private val prefs: SharedPreferences, val type: Int){
    lateinit var checkedChangeListener: ((Boolean) -> Unit)
    fun linkToSwitch(sw: Switch){
        sw.isChecked = prefs.getBoolean(key, defaultValue as Boolean)
        sw.textResource = textID
        sw.setOnCheckedChangeListener { _, b ->
            prefs.edit().putBoolean(key,b).apply()
            if(::checkedChangeListener.isInitialized)
                checkedChangeListener.invoke(b)
        }
    }
    fun addCheckedChangedListener(ccl: (Boolean) -> Unit){checkedChangeListener = ccl}
    lateinit var onItemSelectedListener: (Int)->Unit
    lateinit var array: Array<String>
    fun linkToSpinner(ac: Activity, v: View, itemViewID: Int = android.R.layout.simple_spinner_item){
        v.find<TextView>(R.id.name).textResource = textID
        val sp = v.find<Spinner>(R.id.spinner)
        sp.adapter = ArrayAdapter<String>(ac,itemViewID,array)
        sp.setSelection(prefs.getInt(key,defaultValue as Int))
        sp.onItemSelectedListener = object: AdapterView.OnItemSelectedListener{
            override fun onNothingSelected(s0: AdapterView<*>?) {}
            override fun onItemSelected(s0: AdapterView<*>?, s1: View?, position: Int, s2: Long) {
                prefs.edit().putInt(key,position).apply()
                if(::onItemSelectedListener.isInitialized)
                    onItemSelectedListener.invoke(position)
            }
        }
    }
    fun addItemSelectedListener(isl: (Int)->Unit){
        onItemSelectedListener = isl
    }
    fun setSpinnerItems(items: Array<String>){
        array = items
    }
    lateinit var onStringConfirmed: (String)->Unit
    fun linkToString(ac: Activity,v: View){
        v.find<TextView>(R.id.setting_name).textResource = textID
        val value = v.find<TextView>(R.id.setting_value)
        value.text = prefs.getString(key,defaultValue as String)
        v.setOnClickListener {
            val build = AlertDialog.Builder(ac)
            val view = ac.layoutInflater.inflate(R.layout.settings_string_edit,null)
            build.setView(view)
            val txt = view.find<TextInputEditText>(R.id.editText)
            txt.hintResource = textID
            txt.setText(prefs.getString(key,defaultValue))
            build.setPositiveButton(android.R.string.ok,{dialog,_->
                prefs.edit().putString(key,txt.text.toString()).apply()
                value.text = txt.text
                dialog.cancel()
            }).setNegativeButton(android.R.string.cancel,{dialog,_->
                dialog.cancel()
            }).show()
        }
    }
    fun createView(inflater: LayoutInflater,parent: ViewGroup?,attach: Boolean):View = when(type){
        Setting.boolean->Setting.createSwitch(inflater,parent,attach)
        Setting.multipleChoice->Setting.createSpinner(inflater,parent,attach)
        Setting.stringValue->Setting.createStringEdit(inflater,parent,attach)
        else-> Setting.createSwitch(inflater,parent,attach)
    }

    companion object {
        val boolean = 0
        val multipleChoice = 1
        val stringValue = 2
        val divider = 3
        fun createSwitch(inflater: LayoutInflater,parent: ViewGroup?,attach: Boolean):View = inflater.inflate(R.layout.settings_switch,parent,attach)
        fun createSpinner(inflater: LayoutInflater,parent: ViewGroup?,attach: Boolean):View = inflater.inflate(R.layout.settings_spinner,parent,attach)
        fun createStringEdit(inflater: LayoutInflater,parent: ViewGroup?,attach: Boolean):View = inflater.inflate(R.layout.settings_string,parent,attach)
        fun createDivider(inflater: LayoutInflater,parent: ViewGroup?,attach: Boolean):View = inflater.inflate(R.layout.settings_divider,parent,attach)
    }
}