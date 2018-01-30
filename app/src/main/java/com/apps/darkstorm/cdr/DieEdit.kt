package com.apps.darkstorm.cdr

import android.annotation.SuppressLint
import android.app.AlertDialog
import android.app.Fragment
import android.os.Bundle
import android.support.design.widget.TextInputLayout
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.support.v7.widget.Toolbar
import android.view.*
import android.widget.EditText
import android.widget.LinearLayout
import android.widget.TextView
import com.apps.darkstorm.cdr.custVars.Adapters
import com.apps.darkstorm.cdr.custVars.FloatingActionMenu
import com.apps.darkstorm.cdr.custVars.OnEditDialogClose
import com.apps.darkstorm.cdr.dice.ComplexSide
import com.apps.darkstorm.cdr.dice.Dice
import com.apps.darkstorm.cdr.dice.Die
import com.apps.darkstorm.cdr.dice.SimpleSide
import org.jetbrains.anko.act
import org.jetbrains.anko.find
import org.jetbrains.anko.longToast
import org.jetbrains.anko.toast

class DieEdit: Fragment(){
    lateinit var die: Die
    var dice: Dice? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setHasOptionsMenu(true)
    }
    override fun onCreateView(inflater: LayoutInflater?, container: ViewGroup?, savedInstanceState: Bundle?) =
            inflater?.inflate(R.layout.edit,container,false)
    override fun onResume() {
        super.onResume()
        if(dice == null)
            die.startEditing({cdr -> die.localLocation(cdr)},act.application as CDR,{cdr -> die.driveFile(cdr)})
        else
            dice!!.startEditing({cdr -> dice!!.localLocation(cdr)},act.application as CDR,{cdr -> dice!!.driveFile(cdr)})
    }
    override fun onPause() {
        super.onPause()
        if(dice == null)
            die.stopEditing()
        else
            dice!!.stopEditing()
    }
    override fun onCreateOptionsMenu(menu: Menu?, inflater: MenuInflater?) {
        inflater?.inflate(R.menu.rollable,menu)
    }

    override fun onOptionsItemSelected(item: MenuItem?) =
            when(item?.itemId){
                R.id.roll->{
                    if(die.sides.size>0) {
                        val d = Dice()
                        d.dice.add(die)
                        d.roll().showDialog(act,getString(R.string.something_went_wrong))
                    }else
                        toast(R.string.needs_one_side)
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
        val adap = SidesAdapter()
        rec.adapter = adap

        val menuItems = mutableListOf(FloatingActionMenu.FloatingMenuItem(R.drawable.add_box,{
            SimpleSide.edit(act,object: OnEditDialogClose(){
                override fun onOk() {
                    adap.notifyItemInserted(die.sides.size)
                }
            },die)
        },getString(R.string.simple_side)), FloatingActionMenu.FloatingMenuItem(R.drawable.library_add,{
            ComplexSide.edit(act,object: OnEditDialogClose(){
                override fun onOk() {
                    adap.notifyItemInserted(die.sides.size)
                }
            },die)
        },getString(R.string.complex_side)))
        (act.application as CDR).fab.setMenu(menuItems)
    }

    inner class SidesAdapter: RecyclerView.Adapter<Adapters.SimpleHolder>() {
        override fun onCreateViewHolder(parent: ViewGroup?, viewType: Int) = if(viewType == nameCard)
                Adapters.SimpleHolder(LayoutInflater.from(parent?.context).inflate(R.layout.name_card,parent,false))
            else
                Adapters.SimpleHolder(LayoutInflater.from(parent?.context).inflate(R.layout.sides_layout,parent,false))
        override fun getItemCount() = die.sides.size + 1
        @SuppressLint("SetTextI18n")
        override fun onBindViewHolder(holder: Adapters.SimpleHolder?, position: Int) {
            if(holder == null)
                return
            if(position == 0){
                holder.v.findViewById<TextView>(R.id.name).text = die.getName()
                holder.v.setOnClickListener {
                    val b = AlertDialog.Builder(act)
                    val v = LayoutInflater.from(act).inflate(R.layout.dialog_simple_side,null)
                    b.setView(v)
                    val edit = v.find<EditText>(R.id.editText)
                    (v as TextInputLayout).hint = getString(R.string.rename_dialog)
                    edit.text.insert(0,die.getName())
                    val d = b.setPositiveButton(android.R.string.ok,{_,_ -> }).setNegativeButton(android.R.string.cancel,{_,_->}).show()
                    d.getButton(AlertDialog.BUTTON_POSITIVE).setOnClickListener {
                        if(dice != null){
                            die.renameNoFileMove(edit.text.toString())
                            holder.v.findViewById<TextView>(R.id.name).text = die.getName()
                            d.cancel()
                        }else {
                            if(edit.text.toString() == die.getName())
                                d.cancel()
                            else if (edit.text.contains("{") || edit.text.contains("}") || edit.text.contains("+") || edit.text.contains("-")) {
                                longToast(R.string.invalid_name)
                            } else if ((act.application as CDR).hasConflictDie(edit.text.toString())) {
                                val build = AlertDialog.Builder(act)
                                build.setMessage(R.string.overwrite_warning_die)
                                build.setPositiveButton(android.R.string.ok, { _, _ ->
                                    die.rename(edit.text.toString(), act.application as CDR)
                                    holder.v.findViewById<TextView>(R.id.name).text = die.getName()
                                    (act.application as CDR).reloadDieMaster()
                                    d.cancel()
                                }).setNegativeButton(android.R.string.cancel, { _, _ -> }).show()
                            } else {
                                die.rename(edit.text.toString(), act.application as CDR)
                                holder.v.findViewById<TextView>(R.id.name).text = die.getName()
                                d.cancel()
                            }
                        }
                    }
                }
                return
            }
            holder.v.findViewById<LinearLayout>(R.id.items).removeAllViews()
            if(die.isComplex(position-1)){
                val side = die.getComplex(position-1)!!
                if(side.number!= 0) {
                    val text: TextView = LayoutInflater.from(holder.v.context)?.inflate(R.layout.side_part, holder.v.findViewById<LinearLayout>(R.id.items), false) as TextView
                    text.text = side.number.toString()
                    holder.v.findViewById<LinearLayout>(R.id.items).addView(text)
                }
                for(pt in side.parts){
                    val text: TextView = LayoutInflater.from(holder.v.context)?.inflate(R.layout.side_part, holder.v.findViewById<LinearLayout>(R.id.items), false) as TextView
                    text.text = pt.value.toString() + " " +pt.name
                    holder.v.findViewById<LinearLayout>(R.id.items).addView(text)
                }
            }else{
                val text: TextView = LayoutInflater.from(holder.v.context)?.inflate(R.layout.side_part, holder.v.findViewById<LinearLayout>(R.id.items), false) as TextView
                text.text = die.getSimple(position-1)?.stringSide()
                holder.v.findViewById<LinearLayout>(R.id.items).addView(text)
            }
            holder.v.setOnClickListener {
                if(die.isComplex(holder.adapterPosition-1)){
                    ComplexSide.edit(act,object: OnEditDialogClose(){
                        override fun onOk(){
                            this@SidesAdapter.notifyItemChanged(holder.adapterPosition-1)
                        }
                        override fun onDelete() {
                            this@SidesAdapter.notifyItemRemoved(holder.adapterPosition-1)
                        }
                    },die,holder.adapterPosition-1)
                }else{
                    SimpleSide.edit(act,object: OnEditDialogClose(){
                        override fun onOk(){
                            this@SidesAdapter.notifyItemChanged(holder.adapterPosition-1)
                        }
                        override fun onDelete() {
                            this@SidesAdapter.notifyItemRemoved(holder.adapterPosition-1)
                        }
                    },die,holder.adapterPosition-1)
                }
            }
            holder.v.setOnLongClickListener {
                val b = AlertDialog.Builder(act)
                b.setMessage(R.string.delete_confirmation)
                b.setPositiveButton(android.R.string.yes,{_,_->
                    die.sides.removeAt(holder.adapterPosition-1)
                    this.notifyItemRemoved(holder.adapterPosition-1)
                }).setNegativeButton(android.R.string.no,{_,_->}).show()
                true
            }
        }

        override fun getItemViewType(position: Int): Int {
            return if(position == 0)
                nameCard
            else
                normalCard
        }
        private val nameCard = -1
        private val normalCard = 1
    }
    companion object {
        fun newInstance(die: Die): DieEdit{
            val new = DieEdit()
            new.die = die
            return new
        }
        fun newInstance(die: Die, dice: Dice): DieEdit{
            val new = DieEdit()
            new.die = die
            new.dice = dice
            return new
        }
    }
}