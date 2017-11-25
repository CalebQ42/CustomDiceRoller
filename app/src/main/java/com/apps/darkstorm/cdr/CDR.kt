package com.apps.darkstorm.cdr

import android.app.Application
import android.content.Context
import android.content.SharedPreferences

class CDR: Application(){
    lateinit var prefs: SharedPreferences

    override fun onCreate() {
        prefs = getSharedPreferences(getString(R.string.preference_key), Context.MODE_PRIVATE)
        super.onCreate()
    }
}