package com.apps.darkstorm.cdr

import android.app.Fragment
import android.content.Context
import android.os.Bundle
import android.text.Editable
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import android.widget.ImageButton
import com.apps.darkstorm.cdr.dice.DiceFormula
import org.jetbrains.anko.find

class FormulaFragment : Fragment() {
    private var mListenerFormula: OnFormulaFragmentInteractionListener? = null

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,
                              savedInstanceState: Bundle?): View? =
            inflater.inflate(R.layout.fragment_formula, container, false)

    override fun onViewCreated(v: View, savedInstanceState: Bundle?) {
        val disp = v.find<EditText>(R.id.display)
        disp.isEnabled = false
        v.find<ImageButton>(R.id.back).setOnClickListener {
            if(disp.text.isNotEmpty())
                disp.text = Editable.Factory.getInstance().newEditable(disp.text.substring(0,disp.text.length-1))
        }
        v.find<Button>(R.id.one).setOnClickListener { disp.text.append('1') }
        v.find<Button>(R.id.two).setOnClickListener { disp.text.append('2') }
        v.find<Button>(R.id.three).setOnClickListener { disp.text.append('3') }
        v.find<Button>(R.id.plus).setOnClickListener { disp.text.append('+') }
        v.find<Button>(R.id.four).setOnClickListener { disp.text.append('4') }
        v.find<Button>(R.id.five).setOnClickListener { disp.text.append('5') }
        v.find<Button>(R.id.six).setOnClickListener { disp.text.append('6') }
        v.find<Button>(R.id.seven).setOnClickListener { disp.text.append('7') }
        v.find<Button>(R.id.eight).setOnClickListener { disp.text.append('8') }
        v.find<Button>(R.id.nine).setOnClickListener { disp.text.append('9') }
        v.find<Button>(R.id.minus).setOnClickListener { disp.text.append('-') }
        v.find<Button>(R.id.zero).setOnClickListener { disp.text.append('0') }
        v.find<Button>(R.id.dee).setOnClickListener { disp.text.append('d') }
        v.find<Button>(R.id.enter).setOnClickListener { DiceFormula.solve(disp.text.toString()).showDialog(activity) }
    }

    override fun onAttach(context: Context?) {
        super.onAttach(context)
        if (context is OnFormulaFragmentInteractionListener) {
            mListenerFormula = context
        } else {
            throw RuntimeException(context!!.toString() + " must implement OnFormulaFragmentInteractionListener")
        }
    }

    override fun onDetach() {
        super.onDetach()
        mListenerFormula = null
    }

    interface OnFormulaFragmentInteractionListener

    companion object {
        fun newInstance(): FormulaFragment = FormulaFragment()
    }
}
