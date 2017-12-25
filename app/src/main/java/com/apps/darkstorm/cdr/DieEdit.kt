package com.apps.darkstorm.cdr

import android.app.Fragment
import android.os.Bundle
import android.support.design.widget.FloatingActionButton
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.apps.darkstorm.cdr.custVars.FloatingActionMenu
import org.jetbrains.anko.act
import org.jetbrains.anko.find

class DieEdit: Fragment(){
    override fun onCreateView(inflater: LayoutInflater?, container: ViewGroup?, savedInstanceState: Bundle?) =
            inflater?.inflate(R.layout.edit,container,false)

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        val menuItems = arrayOf(FloatingActionMenu.FloatingMenuItem(R.drawable.add_box,{
            //simple side add
        },getString(R.string.simple_side)), FloatingActionMenu.FloatingMenuItem(R.drawable.library_add,{
            //complex add
        },getString(R.string.complex_side)))
        val mainFab = act.find<FloatingActionButton>(R.id.fab)
        mainFab.show()
        FloatingActionMenu.connect(mainFab,view.find<FrameLayout>(R.id.frame),menuItems)
    }
}