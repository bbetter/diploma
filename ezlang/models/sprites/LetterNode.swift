//
// Created by mac on 31.12.15.
// Copyright (c) 2015 5wheels. All rights reserved.
//

import Foundation
import SpriteKit

class LetterNode : SKSpriteNode {
    private let DEFAULT_HEIGHT = 70
    private let DEFAULT_WIDTH = 70
    
    var label:SKLabelNode?

    private let mainTexture : SKTexture = SKTexture(imageNamed:"character")

    var character:Character = " "

    var row:Int = 0
    var column:Int = 0

    init(row:Int,column:Int,size:CGFloat,character:Character){
        super.init(texture:mainTexture,color:UIColor.whiteColor(),size:CGSize(width:size,height: size))
        self.colorBlendFactor = 1
        self.row = row
        self.column = column
        self.character = character;

        label = SKLabelNode()
        label!.fontColor = UIColor.blackColor()
        if(size == CGFloat(40)){
            label!.fontSize = CGFloat(20)
        }
        else{
            label!.fontSize = CGFloat(30)
        }
        label!.text = String(character)

        self.addChild(label!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //todo: more like a business logic
    static func mockLetter(row:Int,column:Int) -> LetterNode{
        return LetterNode(row:row,column:column,size: CGFloat(70),character: String.randomLetter()[0])
    }
    
    func isARound(letter: LetterNode) -> Bool {
        return (letter.row - 1 == row - 1 || letter.row + 1 == row + 1) ||
            (letter.column - 1 == column - 1 || letter.column + 1 == column + 1)
    }
}

