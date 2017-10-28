package com.apps.darkstorm.cdr.dice

class Dice{
    private var dice = mutableListOf<Die>()
    fun size() = dice.size
    fun add(d: Die){
        dice.add(d)
    }
    fun set(i: Int, d: Die){
        dice.set(i,d)
    }
    fun get(i:Int) = dice[i]
}