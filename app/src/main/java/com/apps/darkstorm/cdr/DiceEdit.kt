package com.apps.darkstorm.cdr

import android.app.AlertDialog
import android.app.Fragment
import android.os.Bundle
import android.support.design.widget.FloatingActionButton
import android.support.v7.widget.Toolbar
import android.view.*
import android.widget.EditText
import android.widget.FrameLayout
import com.apps.darkstorm.cdr.custVars.FloatingActionMenu
import com.apps.darkstorm.cdr.dice.Dice
import org.jetbrains.anko.act
import org.jetbrains.anko.find
import org.jetbrains.anko.hintResource

class DiceEdit : Fragment(){
    lateinit var dice: Dice
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setHasOptionsMenu(true)
    }
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
    override fun onCreateOptionsMenu(menu: Menu?, inflater: MenuInflater?) {
        inflater?.inflate(R.menu.rollable,menu)
        inflater?.inflate(R.menu.renamable,menu)
    }
    override fun onOptionsItemSelected(item: MenuItem?) =
            when(item?.itemId){
                R.id.roll->{
                    dice.roll().showDialog(act)
                    true
                }
                R.id.rename->{
                    val b = AlertDialog.Builder(act)
                    val v = LayoutInflater.from(act).inflate(R.layout.dialog_simple_side,null)
                    b.setView(v)
                    val edit = v.find<EditText>(R.id.editText)
                    edit.hintResource = R.string.rename_dialog
                    edit.text.insert(0,dice.getName())
                    b.setPositiveButton(android.R.string.ok,{_,_ ->
                        dice.rename(edit.text.toString(),act.application as CDR)
                        act.find<Toolbar>(R.id.toolbar).title = dice.getName()
                    }).setNegativeButton(android.R.string.cancel,{_,_->}).show()
                    true
                }
                else->super.onOptionsItemSelected(item)
            }
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        act.find<Toolbar>(R.id.toolbar).title = dice.getName()
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