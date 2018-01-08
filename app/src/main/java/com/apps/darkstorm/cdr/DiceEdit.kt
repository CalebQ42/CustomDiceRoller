package com.apps.darkstorm.cdr

import android.app.AlertDialog
import android.app.Fragment
import android.os.Bundle
import android.support.design.widget.TextInputLayout
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.support.v7.widget.Toolbar
import android.text.InputType
import android.view.*
import android.widget.EditText
import android.widget.TextView
import com.apps.darkstorm.cdr.custVars.FloatingActionMenu
import com.apps.darkstorm.cdr.dice.Dice
import org.jetbrains.anko.act
import org.jetbrains.anko.find

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
                    dice.roll().showDialog(act,"Oops, something went wrong")
                    true
                }
                R.id.rename->{
                    val b = AlertDialog.Builder(act)
                    val v = LayoutInflater.from(act).inflate(R.layout.dialog_simple_side,null)
                    b.setView(v)
                    val edit = v.find<EditText>(R.id.editText)
                    (v as TextInputLayout).hint = getString(R.string.rename_dialog)
                    edit.text.insert(0,dice.getName())
                    b.setPositiveButton(android.R.string.ok,{_,_ ->
                        dice.rename(edit.text.toString(),act.application as CDR)
                        act.find<Toolbar>(R.id.toolbar).title = dice.getName()
                    }).setNegativeButton(android.R.string.cancel,{_,_->}).show()
                    true
                }
                else->super.onOptionsItemSelected(item)
            }
    override fun onViewCreated(view: View?, savedInstanceState: Bundle?) {
        if (view == null)
            return
        val rec = view.find<RecyclerView>(R.id.recycler)
        rec.layoutManager = LinearLayoutManager(act)
        val adap = diesAdapter()
        rec.adapter = adap
        act.find<Toolbar>(R.id.toolbar).title = dice.getName()
        val menuItems = mutableListOf(FloatingActionMenu.FloatingMenuItem(R.drawable.custom_die, {
            val b = AlertDialog.Builder(act)
            val v = LayoutInflater.from(act).inflate(R.layout.recycle,null)
            b.setView(v)
            val recB = v as RecyclerView
            recB.layoutManager = LinearLayoutManager(act)
            recB.adapter = customDieListAdapter(b.setNegativeButton(android.R.string.cancel,{_,_->}).show(),adap)
        }, getString(R.string.custom_die)), FloatingActionMenu.FloatingMenuItem(R.drawable.die, {
            val b = AlertDialog.Builder(act)
            val v = LayoutInflater.from(act).inflate(R.layout.dialog_simple_side,null)
            b.setView(v)
            val editNumber = v.find<EditText>(R.id.editText)
            (v as TextInputLayout).hint = getString(R.string.dice_number)
            editNumber.inputType = InputType.TYPE_CLASS_NUMBER
            editNumber.text.insert(0,"1")
            b.setPositiveButton(android.R.string.ok,{_,_ ->
                if(editNumber.text.toString() != ""){
                    val b = AlertDialog.Builder(act)
                    val v = LayoutInflater.from(act).inflate(R.layout.dialog_simple_side,null)
                    b.setView(v)
                    val editSides = v.find<EditText>(R.id.editText)
                    (v as TextInputLayout).hint = getString(R.string.side_number)
                    editSides.inputType = InputType.TYPE_CLASS_NUMBER
                    b.setPositiveButton(android.R.string.ok,{_,_ ->
                        if(editSides.text.toString() != ""){
                            for(d in Dice.numberDice(editNumber.text.toString().toInt(),editSides.text.toString().toInt()).dice) {
                                d.renameNoFileMove("d" + editSides.text.toString())
                                dice.dice.add(d)
                            }
                            adap.notifyItemRangeInserted(dice.dice.size-editNumber.text.toString().toInt()-1,dice.dice.size-1)
                        }
                    }).setNegativeButton(android.R.string.cancel,{_,_->}).show()
                }
            }).setNegativeButton(android.R.string.cancel,{_,_->}).show()
        }, getString(R.string.number_die)))
        (act.application as CDR).fab.setMenu(menuItems)
//        val mainFab = act.find<FloatingActionButton>(R.id.fab)
//        FloatingActionMenuLegacy.connect(mainFab,view.find<FrameLayout>(R.id.frame),menuItems)
    }

    inner class diesAdapter: RecyclerView.Adapter<diesAdapter.ViewHolder>(){
        override fun getItemCount() = dice.dice.size
        override fun onCreateViewHolder(parent: ViewGroup?, viewType: Int) =
                ViewHolder(LayoutInflater.from(parent?.context).inflate(R.layout.dice_die_list_item,parent,false))
        override fun onBindViewHolder(holder: ViewHolder?, position: Int) {
            if(holder != null)
            holder.v.findViewById<TextView>(R.id.name).text = dice.dice[position].getName()
            var txt = ""
            for(s in dice.dice[position].sides)
                txt += s.toString() + "\n"
            txt.removeSuffix("\n")
            holder?.v?.findViewById<TextView>(R.id.sides)?.text = txt
            holder?.v?.setOnClickListener {
                fragmentManager.beginTransaction().replace(R.id.content_main,DieEdit.newInstance(dice.dice[holder.adapterPosition],dice))
                        .setCustomAnimations(android.R.animator.fade_in,android.R.animator.fade_out).addToBackStack("Editing").commit()
            }
            holder?.v?.setOnLongClickListener {
                val b = AlertDialog.Builder(act)
                b.setMessage(R.string.delete_confirmation)
                b.setPositiveButton(android.R.string.yes,{_,_->
                    dice.dice.removeAt(holder.adapterPosition)
                    this.notifyItemRemoved(holder.adapterPosition)
                }).setNegativeButton(android.R.string.no,{_,_->}).show()
                true
            }
        }

        inner class ViewHolder(var v: View): RecyclerView.ViewHolder(v)
    }
    inner class customDieListAdapter(var d: AlertDialog, var adap: diesAdapter) : RecyclerView.Adapter<customDieListAdapter.ViewHolder>(){
        override fun getItemCount() = (act.application as CDR).getDies("").size
        override fun onCreateViewHolder(parent: ViewGroup?, viewType: Int) = ViewHolder(act.layoutInflater.inflate(R.layout.list_item,parent,false))
        override fun onBindViewHolder(holder: ViewHolder, position: Int) {
            holder.v.find<TextView>(R.id.name).text = (act.application as CDR).getDies("")[position].getName()
            holder.v.setOnClickListener {
                dice.dice.add((act.application as CDR).getDies("")[holder.adapterPosition])
                adap.notifyItemInserted(dice.dice.size-1)
                d.cancel()
            }
        }
        inner class ViewHolder(val v: View): RecyclerView.ViewHolder(v)
    }
    companion object {
        fun newInstance(dice: Dice): DiceEdit {
            val new = DiceEdit()
            new.dice = dice
            return new
        }
    }
}