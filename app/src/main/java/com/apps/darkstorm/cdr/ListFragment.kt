package com.apps.darkstorm.cdr

import android.app.Fragment
import android.os.Bundle
import android.support.design.widget.FloatingActionButton
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.support.v7.widget.Toolbar
import android.view.*
import android.widget.FrameLayout
import android.widget.SearchView
import android.widget.TextView
import com.apps.darkstorm.cdr.custVars.FloatingActionMenu
import org.jetbrains.anko.act
import org.jetbrains.anko.appcompat.v7.titleResource
import org.jetbrains.anko.find
import org.jetbrains.anko.imageResource

class ListFragment: Fragment(){
    var dice = false
    lateinit var recycle: RecyclerView
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setHasOptionsMenu(true)
    }
    override fun onCreateView(inflater: LayoutInflater?, container: ViewGroup?, savedInstanceState: Bundle?) =
            inflater?.inflate(R.layout.recycler_fragment,container,false)

    override fun onViewCreated(view: View?, savedInstanceState: Bundle?) {
        val toolbar = act.find<Toolbar>(R.id.toolbar)
        if(dice)
            toolbar.titleResource = R.string.dice_group_nav_drawer
        else
            toolbar.titleResource = R.string.die_nav_drawer
        val fab = activity.find<FloatingActionButton>(R.id.fab)
        fab.imageResource = R.drawable.add
        fab.setOnClickListener {
            //create new die/dice UI
        }
        recycle= view?.find(R.id.recycler)!!
        recycle.adapter = listAdapter()
        val linlay = LinearLayoutManager(act)
        linlay.orientation = LinearLayoutManager.VERTICAL
        recycle.layoutManager = linlay
        val items = arrayOf(FloatingActionMenu.MenuItem(R.drawable.add,{println("hello1")},"test1"),FloatingActionMenu.MenuItem(R.drawable.add,{println("hello2")},"test2"))
        FloatingActionMenu.connect(fab,view.find<FrameLayout>(R.id.constraint),items)
    }
    override fun onCreateOptionsMenu(menu: Menu?, inflater: MenuInflater?) {
        inflater?.inflate(R.menu.searchable, menu)
        val searchView = menu!!.findItem(R.id.app_bar_search).actionView as SearchView
        searchView.setOnQueryTextListener(object: SearchView.OnQueryTextListener {
            override fun onQueryTextSubmit(p0: String?): Boolean {return true}
            override fun onQueryTextChange(p0: String?): Boolean {
                if(p0 != null)
                    (recycle.adapter as listAdapter).handleQuery(p0)
                return true
            }
        })
    }
    inner class listAdapter: RecyclerView.Adapter<listAdapter.ViewHolder>(){
        override fun getItemCount() = when(dice){
            true->(act.application as CDR).diceMaster.size
            else->(act.application as CDR).dieMaster.size
        }
        override fun onCreateViewHolder(parent: ViewGroup?, viewType: Int) = ViewHolder(act.layoutInflater.inflate(R.layout.list_item,parent,false))
        override fun onBindViewHolder(holder: ViewHolder, position: Int) {
            if(dice){
                holder.v.find<TextView>(R.id.name).text = (act.application as CDR).diceMaster[position].name
            }else{
                holder.v.find<TextView>(R.id.name).text = (act.application as CDR).dieMaster[position].name
            }
        }
        fun handleQuery(str: String){
            //handle searching
        }
        inner class ViewHolder(val v: View): RecyclerView.ViewHolder(v)
    }
    companion object {
        fun newInstance(dice: Boolean): ListFragment{
            val lf = ListFragment()
            lf.dice = dice
            return lf
        }
    }
}