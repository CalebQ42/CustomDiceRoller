package com.apps.darkstorm.cdr.dice

import java.util.*

class Die{
    companion object {
        fun numberDie(i:Int): Die{
            val d = Die()
            (1..i).forEach {
                d.add(SimpleSide(it))
            }
            return d
        }
    }
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
    fun roll(): Int = Random().nextInt(size())
    override fun toString() = sides.toString()
}
