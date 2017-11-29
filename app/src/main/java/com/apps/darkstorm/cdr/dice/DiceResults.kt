package com.apps.darkstorm.cdr.dice

import android.app.Activity
import android.app.AlertDialog
import android.content.DialogInterface
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import com.apps.darkstorm.cdr.CDR
import com.apps.darkstorm.cdr.R
import org.jetbrains.anko.find

class DiceResults {
    var number = 0
    private var reses = mutableListOf<Result>()
    var resList = mutableListOf<Any>()
    class Result(var name:String, var value: Int){
        override fun toString() = value.toString() + " " + name
    }
    fun add(res: Result){
        resList.add(res)
        val ind = indexOf(res.name)
        when(ind){
            -1 -> reses.add(res)
            else-> reses[ind].value += res.value
        }
    }
    fun addNum(i: Int){
        println("In: "+i.toString())
        number += i
        resList.add(i)
    }
    fun size() = reses.size
    fun set(name: String, i: Int){
        for(r in reses){
            if(r.name == name) {
                r.value = i
                return
            }
        }
        add(Result(name,i))
    }
    fun has(name:String): Boolean = reses.any { it.name == name }
    fun get(name: String): Int{
        return reses
                .firstOrNull { it.name == name }
                ?.value
                ?: 0
    }
    fun indexOf(name:String):Int{
        return reses.indices.firstOrNull { reses[it].name == name }
                ?: 0
    }
    fun combineWith(dr: DiceResults){
        dr.resList.forEach {
            when(it){
                is Int-> addNum(it)
                is Result-> add(it)
            }
        }
    }
    fun isNumOnly() = resList.size == 0
    fun showDialog(a: Activity) =
        if((a.application as CDR).prefs.getBoolean(a.getString(R.string.individual_first_key),false))
            showIndividualDialog(a)
        else
            showCombinedDialog(a)
    fun showCombinedDialog(a: Activity){
        val build = AlertDialog.Builder(a)
        val v = a.layoutInflater.inflate(R.layout.results_dialog,null)
        if(isNumOnly())
            v.findViewById<View>(R.id.recycler).visibility = View.GONE
        build.setView(v)
        v.findViewById<TextView>(R.id.number).text = number.toString()
        val r = v.findViewById<RecyclerView>(R.id.recycler)
        r.adapter = ResultsAdap(a)
        val lm = LinearLayoutManager(a)
        lm.orientation = LinearLayoutManager.VERTICAL
        r.layoutManager = lm
        build.setPositiveButton(R.string.individual, { dialogInterface: DialogInterface, _: Int ->
            showIndividualDialog(a)
            dialogInterface.cancel()
        }).setNegativeButton(android.R.string.cancel, {dialog: DialogInterface,_:Int->
            dialog.cancel()
        }).show()
    }
    fun showIndividualDialog(a: Activity){
        val b = AlertDialog.Builder(a)
        val view = a.layoutInflater.inflate(R.layout.results_ind_dialog,null)
        b.setView(view)
        val rec = view.find<RecyclerView>(R.id.recycler)
        rec.adapter = ResultsListAdap(a)
        val l = LinearLayoutManager(a)
        l.orientation = LinearLayoutManager.VERTICAL
        rec.layoutManager = l
        b.setPositiveButton(R.string.combined,{dialogInt: DialogInterface, _: Int ->
            showCombinedDialog(a)
            dialogInt.cancel()
        }).setNegativeButton(android.R.string.cancel, {dialog: DialogInterface,_:Int->
            dialog.cancel()
        }).show()
    }

    inner class ResultsAdap(private val a: Activity): RecyclerView.Adapter<ResultsAdap.ViewHolder>(){
        override fun onBindViewHolder(holder: ViewHolder?, position: Int) {
            if (holder != null) {
                holder.v.findViewById<TextView>(R.id.label).text = reses[position].name
                holder.v.findViewById<TextView>(R.id.number).text = reses[position].value.toString()
            }
        }
        override fun getItemCount() = reses.size
        override fun onCreateViewHolder(parent: ViewGroup?, viewType: Int) = ViewHolder(a.layoutInflater.inflate(R.layout.results_part,parent,false))
        inner class ViewHolder(val v: View): RecyclerView.ViewHolder(v)
    }

    inner class ResultsListAdap(private val a: Activity): RecyclerView.Adapter<ResultsListAdap.ViewHolder>(){
        override fun onCreateViewHolder(parent: ViewGroup?, viewType: Int) = ViewHolder(a.layoutInflater.inflate(R.layout.results_ind_simple,parent,false))
        override fun onBindViewHolder(holder: ViewHolder?, position: Int) {
            if (holder != null)
                holder.v.findViewById<TextView>(R.id.text).text = resList[position].toString()
        }
        override fun getItemCount() = resList.size
        inner class ViewHolder(val v: View): RecyclerView.ViewHolder(v)
    }
}