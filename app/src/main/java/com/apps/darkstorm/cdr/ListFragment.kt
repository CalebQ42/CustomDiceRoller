package com.apps.darkstorm.cdr

import android.app.AlertDialog
import android.os.Bundle
import android.support.v4.app.Fragment
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.support.v7.widget.Toolbar
import android.view.*
import android.widget.SearchView
import com.apps.darkstorm.cdr.custVars.Adapters
import org.jetbrains.anko.appcompat.v7.titleResource
import org.jetbrains.anko.find
import org.jetbrains.anko.support.v4.act

class ListFragment: Fragment(){
    var dice = false
    lateinit var recycle: RecyclerView
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setHasOptionsMenu(true)
    }
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View =
            inflater.inflate(R.layout.recycler_fragment,container,false)

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        val toolbar = act.find<Toolbar>(R.id.toolbar)
        if(dice)
            toolbar.titleResource = R.string.dice_group_nav_drawer
        else
            toolbar.titleResource = R.string.die_nav_drawer
        (act.application as CDR).fab.setStatic(R.drawable.add){
            if(dice)
                fragmentManager!!.beginTransaction().replace(R.id.content_main,DiceEdit.newInstance((act.application as CDR).addNewGroup()))
                        .setCustomAnimations(android.R.animator.fade_in,android.R.animator.fade_out).addToBackStack("New Group").commit()
            else
                fragmentManager!!.beginTransaction().replace(R.id.content_main,DieEdit.newInstance((act.application as CDR).addNewDie()))
                        .setCustomAnimations(android.R.animator.fade_in,android.R.animator.fade_out).addToBackStack("New Die").commit()
        }
        recycle = view.find(R.id.recycler)
        recycle.adapter = if(dice)
            Adapters.DiceGroupListAdapter(act.application as CDR,true,{ d ->
                fragmentManager!!.beginTransaction().replace(R.id.content_main,DiceEdit.newInstance(d))
                        .setCustomAnimations(android.R.animator.fade_in,android.R.animator.fade_out).addToBackStack("Editing").commit()
            }) { _, str, i->
                val b = AlertDialog.Builder(act)
                b.setMessage(R.string.delete_confirmation)
                b.setPositiveButton(android.R.string.yes) { _, _->
                    (act.application as CDR).removeDiceAt(str,i)
                    recycle.adapter.notifyItemRemoved(i)
                }.setNegativeButton(android.R.string.no) { _, _->}.show()
            }
        else
            Adapters.DieListAdapter(act.application as CDR,true,{ d ->
                fragmentManager!!.beginTransaction().replace(R.id.content_main,DieEdit.newInstance(d))
                        .setCustomAnimations(android.R.animator.fade_in,android.R.animator.fade_out).addToBackStack("Editing").commit()
            }) { _, str, i->
                val b = AlertDialog.Builder(act)
                b.setMessage(R.string.delete_confirmation)
                b.setPositiveButton(android.R.string.yes) { _, _->
                    (act.application as CDR).removeDieAt(str,i)
                    recycle.adapter.notifyItemRemoved(i)
                }.setNegativeButton(android.R.string.no) { _, _->}.show()
            }
        val linlay = LinearLayoutManager(act)
        linlay.orientation = LinearLayoutManager.VERTICAL
        recycle.layoutManager = linlay
    }
    override fun onCreateOptionsMenu(menu: Menu?, inflater: MenuInflater?) {
        inflater?.inflate(R.menu.searchable, menu)
        val searchView = menu!!.findItem(R.id.app_bar_search).actionView as SearchView
        searchView.setOnQueryTextListener(object: SearchView.OnQueryTextListener {
            override fun onQueryTextSubmit(p0: String?): Boolean {return true}
            override fun onQueryTextChange(p0: String?): Boolean {
                if(p0 != null)
                    (recycle.adapter as Adapters.SearchableAdapter).search(p0)
                return true
            }
        })
    }
    companion object {
        fun newInstance(dice: Boolean): ListFragment{
            val lf = ListFragment()
            lf.dice = dice
            return lf
        }
    }
}