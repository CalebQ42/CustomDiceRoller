package com.apps.darkstorm.cdr.dice

class SimpleSide {
    private var value = ""
    constructor(value: String){
        this.value = value
    }
    constructor(value: Int){
        this.value = value.toString()
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
}