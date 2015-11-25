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
    private var letters = Array2D<Letter>(columns: NumColumns, rows: NumRows)
    
    func cookieAtColumn(column: Int, row: Int) -> Letter? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return letters[column, row]
    }
    
    func shuffle() -> Set<Letter> {
        return createInitialLetters()
    }
    
    private func createInitialLetters() -> Set<Cookie> {
        var set = Set<Letter>()
        
        // 1
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                
                // 2
                var cookieType = CookieType.random()
                
                // 3
                let cookie = Cookie(column: column, row: row, cookieType: cookieType)
                Letters[column, row] = cookie
                
                // 4
                set.insert(cookie)
            }
        }
        return set
    }
}