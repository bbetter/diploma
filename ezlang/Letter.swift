//
//  Cookie.swift
//  ezlang
//
//  Created by Andriy Puhach on 11/25/15.
//  Copyright © 2015 5wheels. All rights reserved.
//

import Foundation
import SpriteKit

enum LetterType: Int{
    case Normal = 0, Selected
    var spriteName: String {
        let spriteNames = [
            "word_block",
            "word_block"]
        
        return spriteNames[rawValue - 1]
    }
}

class Letter : CustomStringConvertible , Hashable{
    var row:Int = 0
    var column:Int = 0
    var positionInWord:Int = 0
    var sprite: SKSpriteNode?
    var letter: String = ""
    
    init(row:Int,column:Int,letter:String){
        self.row = row
        self.column = column
        self.letter = letter
    }

 
    var description : String {
        return "letter:\(letter) position:\(positionInWord) square:(\(column),\(row))"
    }
    
    var hashValue: Int {
        return row*10 + column
    }
}

func ==(lhs: Letter, rhs: Letter) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}