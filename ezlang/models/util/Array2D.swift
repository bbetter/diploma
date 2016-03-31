//
//  Array2D.swift
//  ezlang
//
//  Created by Andriy Puhach on 11/25/15.
//  Copyright © 2015 5wheels. All rights reserved.
//

import Foundation


struct Array2D<T> {

    var columns: Int
    var rows: Int
    
    var array: Array<Array<T>>

    init(rows:Int,columns:Int,item:T){
        self.columns = columns
        self.rows = rows
        array = Array(count: rows, repeatedValue: Array<T>(count: columns,repeatedValue: item))
    }

    subscript(row:Int) -> Array<T>{
        get{
            return array[row]
        }
        set{
            array[row] = newValue
        }
    }
    
    subscript(row: Int, column: Int) -> T {
        get {
            return array[row][column]
        }
        set {
            array[row][column] = newValue
        }
    }
    
    func countByCondition(condition: (T) -> Bool) -> Int {
        return array.flatMap({$0}).filter{item in condition(item)}.count
    }
    
    func toString()->String{
        var str:String = ""
        for i in (0 ... rows-1).reverse(){
            str = str + "\n"
            for j in  0 ... columns-1{
                var char =  self[i,j] as! Character
                if(char == Grid.EmptyCell){
                    char = "*"
                }
                str = str + String(char)+" "
            }
           
        }
        return str
    }
}