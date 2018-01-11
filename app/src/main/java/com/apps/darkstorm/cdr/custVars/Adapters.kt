package com.apps.darkstorm.cdr.custVars

import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import com.apps.darkstorm.cdr.CDR
import com.apps.darkstorm.cdr.R
import com.apps.darkstorm.cdr.dice.Dice
import com.apps.darkstorm.cdr.dice.Die
import org.jetbrains.anko.find

object Adapters {
    class SimpleHolder(var v: View): RecyclerView.ViewHolder(v)
    class DieListAdapter(private val cdr: CDR,private val card: Boolean, private val onClick: (Die)->Unit,
                         private val onLongClick: (Die,String,Int)->Unit = {_,_,_->}): SearchableAdapter(){
        private var searchString = ""
        override fun onBindViewHolder(holder: SimpleHolder?, position: Int){
            if(holder == null)
                return
            holder.v.find<TextView>(R.id.name).text = cdr.getDies(searchString)[position].getName()
        }
        override fun getItemCount() = cdr.getDies(searchString).size
        override fun onCreateViewHolder(parent: ViewGroup?, viewType: Int): SimpleHolder {
            val holder = if(card)
                SimpleHolder(LayoutInflater.from(parent?.context).inflate(R.layout.list_item_card,parent,false))
            else
                SimpleHolder(LayoutInflater.from(parent?.context).inflate(R.layout.list_item,parent,false))
            holder.v.setOnClickListener { onClick(cdr.getDies(searchString)[holder.adapterPosition]) }
            holder.v.setOnLongClickListener {onLongClick(cdr.getDies(searchString)[holder.adapterPosition],searchString,holder.adapterPosition); true}
            return holder
        }
        override fun search(str: String){
            searchString = str
            notifyDataSetChanged()
        }
    }
    class DiceGroupListAdapter(private val cdr: CDR, private val card: Boolean, private val onClick: (Dice)->Unit,
                               private val onLongClick: (Dice,String,Int)->Unit = {_,_,_->}): SearchableAdapter(){
        private var searchString = ""
        override fun onBindViewHolder(holder: SimpleHolder?, position: Int){
            if(holder == null)
                return
            holder.v.find<TextView>(R.id.name).text = cdr.getDice(searchString)[position].getName()
        }
        override fun getItemCount() = cdr.getDice(searchString).size
        override fun onCreateViewHolder(parent: ViewGroup?, viewType: Int): SimpleHolder {
            val holder = if(card)
                SimpleHolder(LayoutInflater.from(parent?.context).inflate(R.layout.list_item_card,parent,false))
            else
                SimpleHolder(LayoutInflater.from(parent?.context).inflate(R.layout.list_item,parent,false))
            holder.v.setOnClickListener { onClick(cdr.getDice(searchString)[holder.adapterPosition]) }
            holder.v.setOnLongClickListener { onLongClick(cdr.getDice(searchString)[holder.adapterPosition],searchString,holder.adapterPosition); true}
            return holder
        }
        override fun search(str: String){
            searchString = str
            notifyDataSetChanged()
        }
    }
    abstract class SearchableAdapter: RecyclerView.Adapter<SimpleHolder>(){
        abstract fun search(str: String)
    }
}