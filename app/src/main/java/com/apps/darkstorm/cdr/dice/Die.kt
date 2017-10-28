package com.apps.darkstorm.cdr.dice

class Die{
    private var sides = mutableListOf<Any>()
    fun size() = sides.size
    fun isComplex(i: Int) = sides[i] is ComplexSide
    fun getComplex(i: Int) = sides[i] as? ComplexSide
    fun getSimple(i: Int) = sides[i] as? SimpleSide
    fun set(i: Int, a: Any){
        sides[i] = a
    }
    fun add(a: Any){
        sides.add(a)
    }
}
