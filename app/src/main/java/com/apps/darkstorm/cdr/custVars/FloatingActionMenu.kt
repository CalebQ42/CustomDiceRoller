package com.apps.darkstorm.cdr.custVars

import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import android.support.design.widget.FloatingActionButton
import android.view.View
import android.view.ViewGroup
import android.view.animation.AnticipateOvershootInterpolator
import android.widget.TextView
import com.apps.darkstorm.cdr.R
import org.jetbrains.anko.find
import org.jetbrains.anko.imageResource
import org.jetbrains.anko.layoutInflater

object FloatingActionMenu {
    class MenuItem(var imageID: Int, var onClick: () -> Unit, private var label: String = ""){
        lateinit var linkedItem: View
        lateinit var hideAction: ()->Unit
        fun setImage(imageID: Int){
            this.imageID = imageID
            if(::linkedItem.isInitialized)
                linkedItem.findViewById<FloatingActionButton>(R.id.item).imageResource = imageID
        }
        fun setOnClickListener(onClick: () -> Unit){
            this.onClick = onClick
            if(::linkedItem.isInitialized)
                linkedItem.find<FloatingActionButton>(R.id.item).setOnClickListener {
                    onClick()
                    hideAction()
                }
        }
        fun setLabel(label: String){
            this.label = label
            if(::linkedItem.isInitialized) {
                if(label == "")
                    linkedItem.find<TextView>(R.id.label).visibility = View.GONE
                else {
                    linkedItem.find<TextView>(R.id.label).text = label
                    linkedItem.find<TextView>(R.id.label).visibility = View.VISIBLE
                }
            }
        }
        fun getLabel() = label
        fun linkToItem(item: View, hideAction: ()->Unit){
            linkedItem = item
            this.hideAction = hideAction
            val fab = item.find<FloatingActionButton>(R.id.item)
            fab.setOnClickListener {
                onClick()
                hideAction()
            }
            fab.imageResource = imageID
            if(label == "")
                item.find<TextView>(R.id.label).visibility = View.GONE
            else {
                item.find<TextView>(R.id.label).text = label
                item.find<TextView>(R.id.label).visibility = View.VISIBLE
            }
        }
    }
    fun connect(mainfab: FloatingActionButton,root: ViewGroup, items: Array<MenuItem>){
        mainfab.imageResource = R.drawable.add
        val openAnimation = {
            for((i,it) in items.withIndex()) {
                println(it.linkedItem.y)
                it.linkedItem.y -= (54 * mainfab.resources.displayMetrics.density)
                println(it.linkedItem.y)
//                it.linkedItem.animate().translationYBy(-(54 * (i+1)) * mainfab.resources.displayMetrics.density).start()
                if(it.getLabel()!="")
                    it.linkedItem.find<TextView>(R.id.label).visibility = View.VISIBLE
            }
        }
        val closeAnimation = {
            for((i,it) in items.withIndex()) {
                println(it.linkedItem.y)
                it.linkedItem.y += (54 * mainfab.resources.displayMetrics.density) + (i*10)
                println(it.linkedItem.y)
//                it.linkedItem.animate().translationYBy((54 * (i+1)) * mainfab.resources.displayMetrics.density).start()
                it.linkedItem.find<TextView>(R.id.label).visibility = View.GONE
            }
        }
        var mainfabClose = {}
        val mainfabOpen = {
            mainfab.animate().rotation(45f).setInterpolator(AnticipateOvershootInterpolator(4f)).setListener(object: AnimatorListenerAdapter(){
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
            mainfab.animate().rotation(0f).setInterpolator(AnticipateOvershootInterpolator()).setListener(object: AnimatorListenerAdapter(){
                override fun onAnimationEnd(p0: Animator?) {
                    mainfab.setOnClickListener {
                        mainfabOpen.invoke()
                    }
                }
                override fun onAnimationStart(p0: Animator?) { mainfab.setOnClickListener {} }
            }).start()
            closeAnimation()
        }
        for(i in items){
            val v = root.context.layoutInflater.inflate(R.layout.menu_item,root,true)
            println(v)
            i.linkToItem(v,{closeAnimation()})
        }
        mainfab.setOnClickListener { mainfabOpen() }
    }
}