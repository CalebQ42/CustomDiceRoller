package com.apps.darkstorm.cdr.dice

class ComplexSide {
    var number = 0
    var parts = mutableListOf<ComplexSidePart>()
    class ComplexSidePart(var name: String, var value: Int)
    fun addPart(side: ComplexSidePart){
        parts.add(side)
    }
    fun size() = parts.size
    fun get(i: Int) = parts[i]
    fun set(i: Int, side: ComplexSidePart){
        parts[i] = side
    }
    fun add(side: ComplexSidePart){
        parts.add(side)
    }
}