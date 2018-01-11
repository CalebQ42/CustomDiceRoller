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
import com.apps.darkstorm.cdr.custVars.Adapters
import com.apps.darkstorm.cdr.custVars.FloatingActionMenu
import com.apps.darkstorm.cdr.dice.Dice
import com.apps.darkstorm.cdr.dice.Die
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
    }
    override fun onOptionsItemSelected(item: MenuItem?) =
            when(item?.itemId){
                R.id.roll->{
                    dice.roll().showDialog(act,"Oops, something went wrong")
                    true
                }
                else->super.onOptionsItemSelected(item)
            }
    override fun onViewCreated(view: View?, savedInstanceState: Bundle?) {
        if (view == null)
            return
        val rec = view.find<RecyclerView>(R.id.recycler)
        rec.layoutManager = LinearLayoutManager(act)
        val adap = DiesAdapter()
        rec.adapter = adap
        act.find<Toolbar>(R.id.toolbar).title = dice.getName()
        val menuItems = mutableListOf(FloatingActionMenu.FloatingMenuItem(R.drawable.custom_die, {
            val b = AlertDialog.Builder(act)
            val v = LayoutInflater.from(act).inflate(R.layout.recycle,null)
            b.setView(v)
            val recB = v as RecyclerView
            recB.layoutManager = LinearLayoutManager(act)
            val dialog = b.setNegativeButton(android.R.string.cancel,{_,_->})
                    .setNeutralButton(R.string.new_custom_die,{_,_->
                        val d = Die()
                        d.renameNoFileMove("New Die")
                        dice.dice.add(d)
                        adap.notifyItemInserted(dice.dice.size)
                    }).show()
            recB.adapter = Adapters.DieListAdapter(act.application as CDR,false,{d->
                dice.dice.add(d)
                adap.notifyItemInserted(dice.dice.size)
                dialog.cancel()
            })
        }, getString(R.string.custom_die)),
                FloatingActionMenu.FloatingMenuItem(R.drawable.die, {
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
    }

    inner class DiesAdapter : RecyclerView.Adapter<Adapters.SimpleHolder>(){
        override fun getItemCount() = dice.dice.size + 1
        override fun onCreateViewHolder(parent: ViewGroup?, viewType: Int): Adapters.SimpleHolder {
            return if(viewType == normalCard)
                Adapters.SimpleHolder(LayoutInflater.from(parent?.context).inflate(R.layout.dice_die_list_item, parent, false))
            else
                Adapters.SimpleHolder(LayoutInflater.from(parent?.context).inflate(R.layout.name_card, parent, false))
        }
        override fun onBindViewHolder(holder: Adapters.SimpleHolder?, position: Int) {
            if(holder == null)
                return
            if(holder.itemViewType == nameCard){
                holder.v.findViewById<TextView>(R.id.name).text = dice.getName()
                holder.v.setOnClickListener {
                    val b = AlertDialog.Builder(act)
                    val v = LayoutInflater.from(act).inflate(R.layout.dialog_simple_side,null)
                    b.setView(v)
                    val edit = v.find<EditText>(R.id.editText)
                    (v as TextInputLayout).hint = getString(R.string.rename_dialog)
                    edit.text.insert(0,dice.getName())
                    b.setPositiveButton(android.R.string.ok,{_,_ ->
                        dice.rename(edit.text.toString(),act.application as CDR)
                        holder.v.findViewById<TextView>(R.id.name).text = dice.getName()
                    }).setNegativeButton(android.R.string.cancel,{_,_->}).show()
                }
                return
            }
            holder.v.findViewById<TextView>(R.id.name).text = dice.dice[position-1].getName()
            var txt = ""
            for(s in dice.dice[position-1].sides)
                txt += s.toString() + "\n"
            txt.removeSuffix("\n")
            holder.v.findViewById<TextView>(R.id.sides)?.text = txt
            holder.v.setOnClickListener {
                fragmentManager.beginTransaction().replace(R.id.content_main,DieEdit.newInstance(dice.dice[holder.adapterPosition-1],dice))
                        .setCustomAnimations(android.R.animator.fade_in,android.R.animator.fade_out).addToBackStack("Editing").commit()
            }
            holder.v.setOnLongClickListener {
                val b = AlertDialog.Builder(act)
                b.setMessage(R.string.delete_confirmation)
                b.setPositiveButton(android.R.string.yes,{_,_->
                    dice.dice.removeAt(holder.adapterPosition-1)
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
        val nameCard = -1
        val normalCard = 1
    }
    companion object {
        fun newInstance(dice: Dice): DiceEdit {
            val new = DiceEdit()
            new.dice = dice
            return new
        }
    }
}