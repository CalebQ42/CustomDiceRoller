package com.apps.darkstorm.cdr.dice

import android.app.Activity
import android.app.AlertDialog
import android.content.DialogInterface
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.text.Editable
import android.text.TextWatcher
import android.util.JsonReader
import android.util.JsonToken
import android.util.JsonWriter
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.EditText
import android.widget.NumberPicker
import com.apps.darkstorm.cdr.R
import com.apps.darkstorm.cdr.custVars.OnEditDialogClose
import com.apps.darkstorm.cdr.saveLoad.JsonSavable
import org.jetbrains.anko.find


data class ComplexSide(var number: Int = 0,var parts: MutableList<ComplexSidePart> = mutableListOf()): JsonSavable() {
    override fun toString(): String {
        val out = mutableListOf<String>()
        if(number != 0)
            out.add(number.toString())
        parts.forEach{ out.add(it.toString()) }
        return out.joinToString()
    }
    override fun clone() = this.copy()
    override fun save(jw: JsonWriter) {
        jw.beginObject()
        jw.name("number").value(number)
        jw.name("parts").beginArray()
        for(pt in parts)
            pt.save(jw)
        jw.endArray()
        jw.endObject()
    }
    override fun load(jr: JsonReader) {
        jr.beginObject()
        while(jr.hasNext() && jr.peek() != JsonToken.END_OBJECT){
            if(jr.peek()!=JsonToken.NAME){
                jr.skipValue()
                continue
            }
            val jName = jr.nextName()
            when(jName){
                "number"->number = jr.nextInt()
                "parts"->{
                    parts.clear()
                    jr.beginArray()
                    while(jr.peek()!=JsonToken.END_ARRAY){
                        val tmp = ComplexSidePart("",0)
                        tmp.load(jr)
                        parts.add(tmp)
                    }
                    jr.endArray()
                }
            }
        }
        jr.endObject()
    }
    data class ComplexSidePart(var name: String = "", var value: Int = 0): JsonSavable(){
        override fun clone() = copy()
        override fun load(jr: JsonReader) {
            jr.beginObject()
            while(jr.hasNext() && jr.peek() != JsonToken.END_OBJECT){
                if(jr.peek()!=JsonToken.NAME){
                    jr.skipValue()
                    continue
                }
                val name = jr.nextName()
                when(name){
                    "Name"->this.name = jr.nextString()
                    "Value"->value=jr.nextInt()
                }
            }
            jr.endObject()
        }
        override fun save(jw: JsonWriter) {
            jw.beginObject()
            jw.name("Name").value(name)
            jw.name("Value").value(value)
            jw.endObject()
        }
        override fun toString() = value.toString() + " " + name
    }
    companion object {
        //Leave -1 for new side
        fun edit(act: Activity, close: OnEditDialogClose, d: Die, position: Int = -1){
            var comp: ComplexSide = if(position == -1)
                ComplexSide()
            else
                d.getComplex(position)!!
            comp = comp.copy()
            val b = AlertDialog.Builder(act)
            val v = LayoutInflater.from(act).inflate(R.layout.recycle,null)
            b.setView(v)
            val rec = v as RecyclerView
            rec.layoutManager = LinearLayoutManager(act)
            val adap = EditItemAdapter(comp)
            rec.adapter = adap
            b.setPositiveButton(android.R.string.ok,{dialog,_->
                comp.parts.removeAll {
                    it.name == ""
                }
                if(position==-1)
                    d.sides.add(comp)
                else
                    d.sides[position] = comp
                close.onOk()

            }).setNeutralButton(R.string.add_part,{_,_->})
            if(position==-1)
                b.setNegativeButton(android.R.string.cancel,{dialog,_->
                    close.onCancel()
                    dialog.cancel()
                })
            else
                b.setNegativeButton(R.string.delete,{dialog,_->
                    d.sides.removeAt(position)
                    close.onDelete()
                    dialog.cancel()
                })
            val dialog = b.show()
            dialog.window.clearFlags(WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_ALT_FOCUSABLE_IM)
            val button = dialog.getButton(DialogInterface.BUTTON_NEUTRAL)
            button.setOnClickListener {
                comp.parts.add(ComplexSidePart())
                adap.notifyDataSetChanged()
            }
        }
        class EditItemAdapter(private val c: ComplexSide) : RecyclerView.Adapter<EditItemAdapter.ViewHolder>() {
            companion object {
                val number = -1
                val part = 0
            }
            override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
                val out = if(viewType == EditItemAdapter.number)
                    ViewHolder(LayoutInflater.from(parent.context).inflate(R.layout.side_complex_number, parent, false))
                else
                    ViewHolder(LayoutInflater.from(parent.context).inflate(R.layout.side_complex_part, parent, false))
                val np = out.v.find<NumberPicker>(R.id.numberPicker)
                np.minValue = 0
                np.maxValue = 10
                return out
            }
            override fun onBindViewHolder(holder: ViewHolder, position: Int) {
                holder.v.find<NumberPicker>(R.id.numberPicker).setOnValueChangedListener { _, _, p2 ->
                    if(holder.adapterPosition==0)
                        c.number = p2
                    else
                        c.parts[position - 1].value = p2
                }
                if(position==0)
                    holder.v.find<NumberPicker>(R.id.numberPicker).value = c.number
                else {
                    holder.v.find<NumberPicker>(R.id.numberPicker).value = c.parts[position - 1].value
                    val edit = holder.v.find<EditText>(R.id.editText)
                    edit.setText(c.parts[position-1].name)
                    edit.addTextChangedListener(object: TextWatcher{
                        override fun afterTextChanged(p0: Editable?) {
                            c.parts[holder.adapterPosition - 1].name = p0.toString()
                        }
                        override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {}
                        override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {}
                    })
                    holder.v.find<View>(R.id.remove).setOnClickListener {
                        c.parts.removeAt(holder.adapterPosition-1)
                        this.notifyItemRemoved(holder.adapterPosition)
                    }
                }
            }
            override fun getItemCount() = c.parts.size + 1
            override fun getItemViewType(position: Int) =
                    if(position==0)
                        EditItemAdapter.number
                    else
                        EditItemAdapter.part
            class ViewHolder(var v: View): RecyclerView.ViewHolder(v)
        }
    }
}