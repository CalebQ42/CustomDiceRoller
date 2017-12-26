package com.apps.darkstorm.cdr

import android.app.Fragment
import android.os.Bundle
import android.support.design.widget.FloatingActionButton
import android.support.v7.widget.Toolbar
import android.view.*
import android.widget.FrameLayout
import com.apps.darkstorm.cdr.custVars.FloatingActionMenu
import com.apps.darkstorm.cdr.dice.Die
import org.jetbrains.anko.act
import org.jetbrains.anko.find

class DieEdit: Fragment(){
    lateinit var die: Die

    override fun onCreateView(inflater: LayoutInflater?, container: ViewGroup?, savedInstanceState: Bundle?) =
            inflater?.inflate(R.layout.edit,container,false)
    override fun onResume() {
        super.onResume()
        die.startEditing(die.localLocation(act.application as CDR))
    }
    override fun onPause() {
        super.onPause()
        die.stopEditing()
    }
    override fun onCreateOptionsMenu(menu: Menu?, inflater: MenuInflater?) {
        inflater?.inflate(R.menu.rollable,menu)
    }

    override fun onOptionsItemSelected(item: MenuItem?) =
        if(item?.itemId  == R.id.roll){
            //roll die
            true
        }else
            super.onOptionsItemSelected(item)
    override fun onViewCreated(view: View?, savedInstanceState: Bundle?) {
        if (view == null)
            return
        val toolbar = act.find<Toolbar>(R.id.toolbar)
        toolbar.title = die.getName()
        val menuItems = arrayOf(FloatingActionMenu.FloatingMenuItem(R.drawable.add_box,{
            println("simple side Add")
            //simple side add
        },getString(R.string.simple_side)), FloatingActionMenu.FloatingMenuItem(R.drawable.library_add,{
            println("complex side Add")
            //complex add
        },getString(R.string.complex_side)))
        val mainFab = act.find<FloatingActionButton>(R.id.fab)
        FloatingActionMenu.connect(mainFab,view.find<FrameLayout>(R.id.frame),menuItems)
    }
    companion object {
        fun newInstance(die: Die): DieEdit{
            val new = DieEdit()
            new.die = die
            return new
        }
    }
}