//
// Created by mac on 29.03.16.
// Copyright (c) 2016 5wheels. All rights reserved.
//

import Foundation
import SpriteKit

let NodeSize:CGFloat = 70.0

extension CGPoint {

    func toPoint(layer:SKNode)->(success:Bool,rows:Int,columns:Int){
        let NodeSize5 = CGFloat(5.0) * NodeSize
        if x >= 0 && x < NodeSize5 && y >= 0 && y < NodeSize5 {
            let rows = (y / NodeSize) + 0.6
            let cols = (x / NodeSize) 
            return (true, Int(rows), Int(cols))
        } else {
            return (false, 0,0)
        }
    }
}

//wtf
func pointForColumn(column: Int, row: Int) -> CGPoint {
    return CGPoint(
            x: CGFloat(column) * NodeSize + NodeSize / 2.0,
            y: CGFloat(row) * NodeSize + NodeSize / 2.0
    )
}

extension LetterNode{
    func isARound(letter: LetterNode) -> Bool {
        return (letter.row - 1 == row - 1 || letter.row + 1 == row + 1) ||
                (letter.column - 1 == column - 1 || letter.column + 1 == column + 1)
    }
}
