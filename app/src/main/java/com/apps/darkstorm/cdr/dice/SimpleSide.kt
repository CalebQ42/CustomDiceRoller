package com.apps.darkstorm.cdr.dice

import android.app.Activity
import android.app.AlertDialog
import android.util.JsonReader
import android.util.JsonToken
import android.util.JsonWriter
import android.view.LayoutInflater
import android.widget.EditText
import com.apps.darkstorm.cdr.R
import com.apps.darkstorm.cdr.custVars.OnEditDialogClose
import com.apps.darkstorm.cdr.saveLoad.JsonSavable
import org.jetbrains.anko.find

data class SimpleSide(private var value: String = ""): JsonSavable() {
    override fun clone() = this.copy()
    override fun save(jw: JsonWriter) {
        jw.beginObject()
        jw.name("value").value(value)
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
                "value"->value = jr.nextString()
            }
        }
        jr.endObject()
    }
    fun intSide() = value.toInt()
    fun stringSide() = value
    fun isInt() = value.toIntOrNull() != null
    fun set(side: String){
        value = side
    }
    fun set(side: Int){
        value = side.toString()
    }
    override fun toString() = value

    companion object {
        //Leave -1 for new side
        fun edit(act: Activity,close: OnEditDialogClose,d: Die, position: Int = -1){
            val b = AlertDialog.Builder(act)
            val v = LayoutInflater.from(act).inflate(R.layout.dialog_simple_side,null)
            b.setView(v)
            if(position!=-1)
                v.find<EditText>(R.id.editText).text.insert(0,d.getSimple(position)!!.stringSide())
            b.setPositiveButton(android.R.string.ok,{ dialog,_ ->
                if(position==-1)
                    d.sides.add(SimpleSide(v.find<EditText>(R.id.editText).text.toString()))
                else
                    d.getSimple(position)!!.set(v.find<EditText>(R.id.editText).text.toString())
                close.onOk()
                dialog.cancel()
            }).setNegativeButton(android.R.string.cancel,{dialog,_->
                close.onCancel()
                dialog.cancel()
            })
            if(position!=-1)
                b.setNeutralButton(R.string.delete,{dialog,_->
                    d.sides.removeAt(position)
                    close.onDelete()
                    dialog.cancel()
                })
            b.show()
        }
    }
}