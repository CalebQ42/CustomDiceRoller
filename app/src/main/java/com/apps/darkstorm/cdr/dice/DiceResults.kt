package com.apps.darkstorm.cdr.dice

class DiceResults() {
    var number = 0
    private var reses = mutableListOf<Result>()
    class Result(var name:String, var value: Int)
    fun add(res: Result){
        reses.add(res)
    }
    fun size() = reses.size
    fun set(i: Int, res: Result){
        reses.set(i,res)
    }
    fun set(name: String, i: Int){
        for(r in reses){
            if(r.name == name) {
                r.value = i
                return
            }
        }
        add(Result(name,i))
    }
    fun has(name:String): Boolean{
        for(r in reses){
            if(r.name == name)
                return true
        }
        return false
    }
    fun getInt(name: String): Int{
        for(r in reses){
            if(r.name == name)
                return r.value
        }
        return 0
    }
}