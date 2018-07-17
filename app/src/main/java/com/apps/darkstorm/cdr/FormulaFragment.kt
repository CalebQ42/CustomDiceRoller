package com.apps.darkstorm.cdr

import android.app.AlertDialog
import android.content.res.Configuration
import android.os.Bundle
import android.support.v4.app.Fragment
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.support.v7.widget.Toolbar
import android.text.Editable
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import android.widget.ImageView
import com.apps.darkstorm.cdr.custVars.Adapters
import com.apps.darkstorm.cdr.dice.DiceFormula
import org.jetbrains.anko.appcompat.v7.titleResource
import org.jetbrains.anko.find
import org.jetbrains.anko.support.v4.act
import org.jetbrains.anko.support.v4.toast

class FormulaFragment : Fragment() {
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,
                              savedInstanceState: Bundle?): View? =
            inflater.inflate(R.layout.formula_fragment, container, false)

    override fun onConfigurationChanged(newConfig: Configuration?) {
        if(newConfig?.orientation != origOrientation)
            fragmentManager?.beginTransaction()?.replace(R.id.content_main,FormulaFragment.newInstance(disp.text.toString()))?.commit()
        super.onConfigurationChanged(newConfig)
    }

    var startText = ""
    private lateinit var disp: EditText
    private var origOrientation = 0

    override fun onViewCreated(v: View, savedInstanceState: Bundle?) {
        origOrientation = resources.configuration.orientation
        val toolbar = act.find<Toolbar>(R.id.toolbar)
        toolbar.titleResource = R.string.formula_nav_drawer
        disp = v.find(R.id.display)
        disp.text = Editable.Factory().newEditable(startText)
        v.find<Button>(R.id.clear).setOnClickListener { disp.text.delete(0,disp.text.length)}
        disp.showSoftInputOnFocus = false
        v.find<Button>(R.id.one).setOnClickListener { disp.text.delete(disp.selectionStart,disp.selectionEnd).insert(disp.selectionStart,"1") }
        v.find<Button>(R.id.two).setOnClickListener { disp.text.delete(disp.selectionStart,disp.selectionEnd).insert(disp.selectionStart,"2") }
        v.find<Button>(R.id.three).setOnClickListener { disp.text.delete(disp.selectionStart,disp.selectionEnd).insert(disp.selectionStart,"3") }
        v.find<Button>(R.id.four).setOnClickListener { disp.text.delete(disp.selectionStart,disp.selectionEnd).insert(disp.selectionStart,"4") }
        v.find<Button>(R.id.five).setOnClickListener { disp.text.delete(disp.selectionStart,disp.selectionEnd).insert(disp.selectionStart,"5") }
        v.find<Button>(R.id.six).setOnClickListener { disp.text.delete(disp.selectionStart,disp.selectionEnd).insert(disp.selectionStart,"6") }
        v.find<Button>(R.id.seven).setOnClickListener { disp.text.delete(disp.selectionStart,disp.selectionEnd).insert(disp.selectionStart,"7") }
        v.find<Button>(R.id.eight).setOnClickListener { disp.text.delete(disp.selectionStart,disp.selectionEnd).insert(disp.selectionStart,"8") }
        v.find<Button>(R.id.nine).setOnClickListener { disp.text.delete(disp.selectionStart,disp.selectionEnd).insert(disp.selectionStart,"9") }
        v.find<Button>(R.id.zero).setOnClickListener { disp.text.delete(disp.selectionStart,disp.selectionEnd).insert(disp.selectionStart,"0") }
        v.find<Button>(R.id.plus).setOnClickListener { disp.text.delete(disp.selectionStart,disp.selectionEnd).insert(disp.selectionStart,"+") }
        v.find<Button>(R.id.minus).setOnClickListener { disp.text.delete(disp.selectionStart,disp.selectionEnd).insert(disp.selectionStart,"-") }
        v.find<Button>(R.id.dee).setOnClickListener { disp.text.delete(disp.selectionStart,disp.selectionEnd).insert(disp.selectionStart,"d") }
        v.find<Button>(R.id.add_dice).setOnClickListener {
            val b = AlertDialog.Builder(act)
            val view = LayoutInflater.from(act).inflate(R.layout.recycle,null)
            b.setView(view)
            val rec = view as RecyclerView
            b.setNegativeButton(android.R.string.cancel) { _, _->}
            rec.layoutManager = LinearLayoutManager(act)
            val d = b.show()
            @Suppress("MoveLambdaOutsideParentheses")
            rec.adapter = Adapters.DieListAdapter(act.application as CDR,false, { die->
                disp.text.delete(disp.selectionStart,disp.selectionEnd).insert(disp.selectionStart,"{Die:" + die.getName() + "}")
                d.cancel()
            })
        }
        v.find<Button>(R.id.add_group).setOnClickListener {
            val b = AlertDialog.Builder(act)
            val view = LayoutInflater.from(act).inflate(R.layout.recycle,null)
            b.setView(view)
            val rec = view as RecyclerView
            b.setNegativeButton(android.R.string.cancel) { _, _->}
            rec.layoutManager = LinearLayoutManager(act)
            val d = b.show()
            @Suppress("MoveLambdaOutsideParentheses")
            rec.adapter = Adapters.DiceGroupListAdapter(act.application as CDR,false, { dice->
                disp.text.delete(disp.selectionStart,disp.selectionEnd).insert(disp.selectionStart,"{Group:" + dice.getName() + "}")
                d.cancel()
            })
        }
        v.find<ImageView>(R.id.back).setOnClickListener {
            if(disp.text.isNotEmpty()){
                if(disp.hasSelection()) {
                    var begin = disp.selectionStart
                    var end = disp.selectionEnd
                    for (i in begin downTo 0) {
                        if (disp.text[i] == '}')
                            break
                        else if (disp.text[i] == '{') {
                            begin = i
                            break
                        }
                    }
                    for (i in end until disp.text.length) {
                        if (disp.text[i] == '{')
                            break
                        else if (disp.text[i] == '}') {
                            end = i+1
                            break
                        }
                    }
                    disp.text.delete(begin, end)
                }else if(disp.selectionStart!=0){
                    if(disp.text[disp.selectionStart-1]=='}'){
                        println("Hello")
                        var begin = disp.selectionStart-2
                        for (i in begin downTo 0) {
                            if (disp.text[i] == '}')
                                break
                            else if (disp.text[i] == '{') {
                                begin = i
                                break
                            }
                        }
                        disp.text.delete(begin,disp.selectionStart)
                    }else {
                        var begin = disp.selectionStart - 1
                        var end = disp.selectionStart
                        for (i in begin downTo 0) {
                            if (disp.text[i] == '}')
                                break
                            else if (disp.text[i] == '{') {
                                begin = i
                                break
                            }
                        }
                        for (i in end until disp.text.length) {
                            if (disp.text[i] == '{')
                                break
                            else if (disp.text[i] == '}') {
                                end = i + 1
                                break
                            }
                        }
                        disp.text.delete(begin, end)
                    }
                }
            }
        }
        (act.application as CDR).fab.setStatic(R.drawable.die_roll) {
            if(disp.text.toString() == "")
                toast(getString(R.string.empty_formula))
            else
                DiceFormula.solve(disp.text.toString(),act.application as CDR).showDialog(act,getString(R.string.invalid_formula))
        }
    }
    companion object {
        fun newInstance(str: String): FormulaFragment{
            val out = FormulaFragment()
            out.startText = str
            return out
        }
    }
}
