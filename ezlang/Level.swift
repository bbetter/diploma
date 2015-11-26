//
//  Level.swift
//  ezlang
//
//  Created by Andriy Puhach on 11/25/15.
//  Copyright © 2015 5wheels. All rights reserved.
//

import Foundation

let NumColumns = 5
let NumRows = 5

class Level {
    
    private let uppercaseLetters = Array(65...90).map {String(UnicodeScalar($0))}
    private var letters = Array2D<Letter>(rows: NumColumns, columns: NumRows)
    
    func letterAtColumn(row: Int, column: Int) -> Letter? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return letters[column, row]
    }
    
    func shuffle() -> Set<Letter> {
        return createInitialLetters()
    }
    
    func randomLetter() -> String {
        let randomIndex = arc4random_uniform(
            UInt32(uppercaseLetters.count))
        return uppercaseLetters[Int(randomIndex)]
    }
    
    
    private func createInitialLetters() -> Set<Letter> {
        var set = Set<Letter>()
        
    
        // 1
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                
        
                
                // 3
                let cookie = Letter(row: row, column: column, letter: randomLetter())
                letters[row, column] = cookie
                
                // 4
                set.insert(cookie)
            }
        }
        return set
    }
}