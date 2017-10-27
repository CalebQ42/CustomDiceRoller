package com.apps.darkstorm.cdr.dice

class ComplexSide {
    class ComplexSidePart(var name: String, var value: Int)
    private var parts = ArrayList<ComplexSidePart>()
    fun addPart(side: ComplexSidePart){
        parts.add(side)
    }
    fun size() = parts.size
    fun get(i: Int) = parts[i]
    fun set(i: Int, side: ComplexSidePart){
        parts[i] = side
    }
}