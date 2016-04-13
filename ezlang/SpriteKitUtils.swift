//
// Created by mac on 29.03.16.
// Copyright (c) 2016 5wheels. All rights reserved.
//

import Foundation
import SpriteKit


extension CGPoint {

    func toPoint(layer:SKNode,size:Int)->(success:Bool,row:Int,column:Int){
        var nodeSize:CGFloat
        if(size == 5){
            nodeSize = CGFloat(70)
        }
        else{
            nodeSize = CGFloat(40)
        }
        if x >= 0 && x < CGFloat(size)*nodeSize &&
            y >= 0 && y < CGFloat(size)*nodeSize {
            return (true, Int(x / nodeSize), Int(y / nodeSize))
        } else {
            return (false, 0, 0)  // invalid location
        }
    }
}

//wtf
func fromPoint(row: Int, column: Int, size:Int) -> CGPoint {
    var nodeSize:CGFloat
    if(size == 5){
        nodeSize = CGFloat(70)
    }
    else{
        nodeSize = CGFloat(40)
    }
    return CGPoint(
            x: CGFloat(column) * nodeSize + nodeSize / 2.0,
            y: CGFloat(row) *  nodeSize + nodeSize / 2.0
    )
}
