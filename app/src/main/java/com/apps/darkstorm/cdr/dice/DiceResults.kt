package com.apps.darkstorm.cdr.dice

import android.app.Activity
import android.app.AlertDialog
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import com.apps.darkstorm.cdr.R

class DiceResults {
    var number = 0
    private var reses = mutableListOf<Result>()
    class Result(var name:String, var value: Int)
    fun add(res: Result){
        reses.add(res)
    }
    fun size() = reses.size
    fun set(i: Int, res: Result){
        reses.set(i,res)
    }
    fun set(name: String, i: Int){
        for(r in reses){
            if(r.name == name) {
                r.value = i
                return
            }
        }
        add(Result(name,i))
    }
    fun has(name:String): Boolean{
        for(r in reses){
            if(r.name == name)
                return true
        }
        return false
    }
    fun get(name: String): Int{
        for(r in reses){
            if(r.name == name)
                return r.value
        }
        return 0
    }
    fun indexOf(name:String):Int{
        for(r in reses.indices){
            if(reses[r].name == name)
                return r
        }
        return 0
    }
    fun combineWith(dr: DiceResults){
        number += dr.number
        dr.reses.filter { has(it.name) }
                .forEach { reses[indexOf(it.name)].value += it.value }
    }
    fun isNumOnly() = reses.size == 0
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
        build.show()
    }

    private class resultsAdap(val dr: DiceResults, val a: Activity): RecyclerView.Adapter<resultsAdap.ViewHolder>(){
        override fun onBindViewHolder(holder: ViewHolder?, position: Int) {
            if (holder != null) {
                holder.v.findViewById<TextView>(R.id.label).text = dr.reses[position].name
                holder.v.findViewById<TextView>(R.id.number).text = dr.reses[position].value.toString()
            }
        }

        override fun getItemCount() = dr.reses.size

        override fun onCreateViewHolder(parent: ViewGroup?, viewType: Int) = ViewHolder(a.layoutInflater.inflate(R.layout.results_part,parent))

        class ViewHolder(val v: View): RecyclerView.ViewHolder(v)
    }
}