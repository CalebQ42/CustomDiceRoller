package com.apps.darkstorm.cdr

import android.app.Fragment
import android.os.Bundle
import android.support.design.widget.FloatingActionButton
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import org.jetbrains.anko.act
import org.jetbrains.anko.find

class DieEdit: Fragment(){
    override fun onCreateView(inflater: LayoutInflater?, container: ViewGroup?, savedInstanceState: Bundle?) =
            inflater.inflate(R.layout.edit_die,container,false)

    override fun onViewCreated(view: View?, savedInstanceState: Bundle?) {
        val mainFab = act.find<FloatingActionButton>(R.id.fab)
    }
}