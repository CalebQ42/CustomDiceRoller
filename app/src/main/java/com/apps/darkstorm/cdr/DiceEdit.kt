package com.apps.darkstorm.cdr

import android.app.Fragment
import android.os.Bundle
import android.support.design.widget.FloatingActionButton
import android.support.v7.widget.Toolbar
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.apps.darkstorm.cdr.custVars.FloatingActionMenu
import com.apps.darkstorm.cdr.dice.Dice
import org.jetbrains.anko.act
import org.jetbrains.anko.find

class DiceEdit : Fragment(){
    lateinit var dice: Dice

    override fun onCreateView(inflater: LayoutInflater?, container: ViewGroup?, savedInstanceState: Bundle?) =
            inflater?.inflate(R.layout.edit,container,false)
    override fun onResume() {
        super.onResume()
        dice.startEditing(dice.localLocation(act.application as CDR))
    }
    override fun onPause() {
        super.onPause()
        dice.stopEditing()
    }
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        val toolbar = act.find<Toolbar>(R.id.toolbar)
        toolbar.title = dice.getName()
        val menuItems = arrayOf(FloatingActionMenu.FloatingMenuItem(R.drawable.die,{
            println("Die Add")
            //die add
        },getString(R.string.die_nav_drawer)), FloatingActionMenu.FloatingMenuItem(R.drawable.add_box,{
            println("modifier Add")
            //modifier add
        },getString(R.string.modifier)))
        val mainFab = act.find<FloatingActionButton>(R.id.fab)
        FloatingActionMenu.connect(mainFab,view.find<FrameLayout>(R.id.frame),menuItems)
    }
    companion object {
        fun newInstance(dice: Dice): DiceEdit {
            val new = DiceEdit()
            new.dice = dice
            return new
        }
    }
}