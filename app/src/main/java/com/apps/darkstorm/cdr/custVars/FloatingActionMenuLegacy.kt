package com.apps.darkstorm.cdr.custVars

import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import android.support.design.widget.FloatingActionButton
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import com.apps.darkstorm.cdr.R
import org.jetbrains.anko.find
import org.jetbrains.anko.imageResource

object FloatingActionMenuLegacy {
    fun connect(mainfab: FloatingActionButton,root: ViewGroup, items: Array<FloatingActionMenu.FloatingMenuItem>){
        val openAnimation = {
            for((i,it) in items.withIndex()) {
                when(i){
                    0->it.linkedItem.animate().translationYBy(-mainfab.resources.getDimension(R.dimen.fam_1)).start()
                    1->it.linkedItem.animate().translationYBy(-mainfab.resources.getDimension(R.dimen.fam_2)).start()
                    2->it.linkedItem.animate().translationYBy(-mainfab.resources.getDimension(R.dimen.fam_3)).start()
                    3->it.linkedItem.animate().translationYBy(-mainfab.resources.getDimension(R.dimen.fam_4)).start()
                }
                if(it.getLabel()!="")
                    it.linkedItem.find<TextView>(R.id.label).visibility = View.VISIBLE
            }
        }
        val closeAnimation = {
            for((i,it) in items.withIndex()) {
                when(i){
                    0->it.linkedItem.animate().translationYBy(mainfab.resources.getDimension(R.dimen.fam_1)).start()
                    1->it.linkedItem.animate().translationYBy(mainfab.resources.getDimension(R.dimen.fam_2)).start()
                    2->it.linkedItem.animate().translationYBy(mainfab.resources.getDimension(R.dimen.fam_3)).start()
                    3->it.linkedItem.animate().translationYBy(mainfab.resources.getDimension(R.dimen.fam_4)).start()
                }
                it.linkedItem.find<TextView>(R.id.label).visibility = View.GONE
            }
        }
        var mainfabClose = {}
        val mainfabOpen = {
            mainfab.animate().rotation(45f).setListener(object: AnimatorListenerAdapter(){
                override fun onAnimationEnd(p0: Animator?) {
                    mainfab.setOnClickListener {
                        mainfabClose()
                    }
                }
                override fun onAnimationStart(p0: Animator?) { mainfab.setOnClickListener {} }
            }).start()
            openAnimation()
        }
        mainfabClose = {
            mainfab.animate().rotation(0f).setListener(object: AnimatorListenerAdapter(){
                override fun onAnimationEnd(p0: Animator?) {
                    mainfab.setOnClickListener {
                        mainfabOpen.invoke()
                    }
                }
                override fun onAnimationStart(p0: Animator?) { mainfab.setOnClickListener {} }
            }).start()
            closeAnimation()
        }
        mainfab.hide(object: FloatingActionButton.OnVisibilityChangedListener(){
            override fun onHidden(fab: FloatingActionButton) {
                mainfab.imageResource = R.drawable.add
                mainfab.show(object: FloatingActionButton.OnVisibilityChangedListener(){
                    override fun onShown(fab: FloatingActionButton) {
                        for(i in items){
                            val v = LayoutInflater.from(root.context).inflate(R.layout.fam_item,root,false)
                            i.linkToItem(v,{mainfabClose()})
                            root.addView(v)
                        }
                        mainfab.setOnClickListener { mainfabOpen() }
                    }
                })
            }
        })
    }
}