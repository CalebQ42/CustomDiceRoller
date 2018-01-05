package com.apps.darkstorm.cdr

import android.annotation.SuppressLint
import android.app.AlertDialog
import android.app.Fragment
import android.os.Bundle
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.support.v7.widget.Toolbar
import android.view.*
import android.widget.EditText
import android.widget.LinearLayout
import android.widget.TextView
import com.apps.darkstorm.cdr.custVars.FloatingActionMenu
import com.apps.darkstorm.cdr.custVars.OnEditDialogClose
import com.apps.darkstorm.cdr.dice.ComplexSide
import com.apps.darkstorm.cdr.dice.Dice
import com.apps.darkstorm.cdr.dice.Die
import com.apps.darkstorm.cdr.dice.SimpleSide
import org.jetbrains.anko.act
import org.jetbrains.anko.find
import org.jetbrains.anko.hintResource

class DieEdit: Fragment(){
    lateinit var die: Die
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setHasOptionsMenu(true)
    }
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
        inflater?.inflate(R.menu.renamable,menu)
    }

    override fun onOptionsItemSelected(item: MenuItem?) =
            when(item?.itemId){
                R.id.roll->{
                    val d = Dice()
                    d.dice.add(die)
                    d.roll().showDialog(act)
                    true
                }
                R.id.rename->{
                    val b = AlertDialog.Builder(act)
                    val v = LayoutInflater.from(act).inflate(R.layout.dialog_simple_side,null)
                    b.setView(v)
                    val edit = v.find<EditText>(R.id.editText)
                    edit.hintResource = R.string.rename_dialog
                    edit.text.insert(0,die.getName())
                    b.setPositiveButton(android.R.string.ok,{_,_ ->
                        die.rename(edit.text.toString(),act.application as CDR)
                        act.find<Toolbar>(R.id.toolbar).title = die.getName()
                    }).setNegativeButton(android.R.string.cancel,{_,_->}).show()
                    true
                }
                else->super.onOptionsItemSelected(item)
            }
    override fun onViewCreated(view: View?, savedInstanceState: Bundle?) {
        if (view == null)
            return
        act.find<Toolbar>(R.id.toolbar).title = die.getName()

        val rec = view.find<RecyclerView>(R.id.recycler)
        rec.layoutManager = LinearLayoutManager(act)
        val adap = sidesAdapter()
        rec.adapter = adap

        val menuItems = mutableListOf(FloatingActionMenu.FloatingMenuItem(R.drawable.add_box,{
            SimpleSide.edit(act,object: OnEditDialogClose(){
                override fun onOk() {
                    adap.notifyItemInserted(die.sides.size-1)
                }
            },die)
        },getString(R.string.simple_side)), FloatingActionMenu.FloatingMenuItem(R.drawable.library_add,{
            ComplexSide.edit(act,object: OnEditDialogClose(){
                override fun onOk() {
                    adap.notifyItemInserted(die.sides.size-1)
                }
            },die)
        },getString(R.string.complex_side)))
        (act.application as CDR).fab.setMenu(menuItems)
//        val mainFab = act.find<FloatingActionButton>(R.id.fab)
//        FloatingActionMenuLegacy.connect(mainFab,view.find<FrameLayout>(R.id.frame),menuItems)
    }

    inner class sidesAdapter(): RecyclerView.Adapter<sidesAdapter.ViewHolder>() {
        override fun onCreateViewHolder(parent: ViewGroup?, viewType: Int) = 
                ViewHolder(LayoutInflater.from(parent?.context).inflate(R.layout.sides_layout,parent,false))
        override fun getItemCount() = die.sides.size
        @SuppressLint("SetTextI18n")
        override fun onBindViewHolder(holder: ViewHolder?, position: Int) {
            if(die.isComplex(position)){
                val side = die.getComplex(position)!!
                if(side.number!= 0) {
                    val text: TextView = LayoutInflater.from(holder?.v?.context)?.inflate(R.layout.side_part, holder?.v?.find<LinearLayout>(R.id.items), false) as TextView
                    text.text = side.number.toString()
                    holder?.v?.find<LinearLayout>(R.id.items)?.addView(text)
                }
                for(pt in side.parts){
                    val text: TextView = LayoutInflater.from(holder?.v?.context)?.inflate(R.layout.side_part, holder?.v?.find<LinearLayout>(R.id.items), false) as TextView
                    text.text = pt.value.toString() + " " +pt.name
                    holder?.v?.find<LinearLayout>(R.id.items)?.addView(text)
                }
            }else{
                val text: TextView = LayoutInflater.from(holder?.v?.context)?.inflate(R.layout.side_part, holder?.v?.find<LinearLayout>(R.id.items), false) as TextView
                text.text = die.getSimple(position)?.stringSide()
                holder?.v?.find<LinearLayout>(R.id.items)?.addView(text)
            }
            holder?.v?.setOnLongClickListener {
                if(die.isComplex(holder.adapterPosition)){
                    ComplexSide.edit(act,object: OnEditDialogClose(){
                        override fun onOk(){
                            this@sidesAdapter.notifyItemChanged(holder.adapterPosition)
                        }
                        override fun onDelete() {
                            this@sidesAdapter.notifyItemRemoved(holder.adapterPosition)
                        }
                    },die,holder.adapterPosition)
                }else{
                    SimpleSide.edit(act,object: OnEditDialogClose(){
                        override fun onOk(){
                            this@sidesAdapter.notifyItemChanged(holder.adapterPosition)
                        }
                        override fun onDelete() {
                            this@sidesAdapter.notifyItemRemoved(holder.adapterPosition)
                        }
                    },die,holder.adapterPosition)
                }
                true
            }
        }
        inner class ViewHolder(var v: View): RecyclerView.ViewHolder(v)
    }
    companion object {
        fun newInstance(die: Die): DieEdit{
            val new = DieEdit()
            new.die = die
            return new
        }
    }
}