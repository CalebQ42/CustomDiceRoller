package com.apps.darkstorm.cdr.dice

import android.app.Activity
import android.app.AlertDialog
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
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
    fun showDialog(a: Activity){
        val build = AlertDialog.Builder(a)
        val v = a.layoutInflater.inflate(R.layout.results_dialog,null)
        if(isNumOnly())
            v.findViewById<View>(R.id.recycler).visibility = View.GONE
        build.setView(v)
        v.findViewById<TextView>(R.id.number).text = number.toString()
        val r = v.findViewById<RecyclerView>(R.id.recycler)
        r.adapter = resultsAdap(this,a)
        val lm = LinearLayoutManager(a)
        lm.orientation = LinearLayoutManager.VERTICAL
        r.layoutManager = lm
        val ad = build.create()
        v.find<Button>(R.id.results).setOnClickListener {
            val b = AlertDialog.Builder(a)
            val view = a.layoutInflater.inflate(R.layout.results_ind_dialog,null)
            b.setView(view)
            val rec = view.find<RecyclerView>(R.id.recycler)
            rec.adapter = resultsListAdap(this,a)
            val l = LinearLayoutManager(a)
            l.orientation = LinearLayoutManager.VERTICAL
            rec.layoutManager = l
            b.show()
            ad.cancel()
        }
        ad.show()
    }

    private class resultsAdap(val dr: DiceResults, val a: Activity): RecyclerView.Adapter<resultsAdap.ViewHolder>(){
        override fun onBindViewHolder(holder: ViewHolder?, position: Int) {
            if (holder != null) {
                holder.v.findViewById<TextView>(R.id.label).text = dr.reses[position].name
                holder.v.findViewById<TextView>(R.id.number).text = dr.reses[position].value.toString()
            }
        }
        override fun getItemCount() = dr.reses.size
        override fun onCreateViewHolder(parent: ViewGroup?, viewType: Int) = ViewHolder(a.layoutInflater.inflate(R.layout.results_part,parent,false))
        class ViewHolder(val v: View): RecyclerView.ViewHolder(v)
    }

    private class resultsListAdap(val dr: DiceResults, val a: Activity): RecyclerView.Adapter<resultsListAdap.ViewHolder>(){
        override fun onCreateViewHolder(parent: ViewGroup?, viewType: Int) = ViewHolder(a.layoutInflater.inflate(R.layout.results_ind_simple,parent,false))
        override fun onBindViewHolder(holder: ViewHolder?, position: Int) {
            if (holder != null)
                holder.v.findViewById<TextView>(R.id.text).text =dr.resList[position].toString()
        }
        override fun getItemCount() = dr.resList.size
        class ViewHolder(val v: View): RecyclerView.ViewHolder(v)
    }
}