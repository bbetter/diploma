//
// Created by mac on 31.12.15.
// Copyright (c) 2015 5wheels. All rights reserved.
//

import Foundation
import SpriteKit

class LetterNode : SKSpriteNode {
    private let DEFAULT_HEIGHT = 70
    private let DEFAULT_WIDTH = 70
    
    private var label:SKLabelNode?

    private let mainTexture : SKTexture = SKTexture(imageNamed:"character")

    var character:Character = " "
    var row:Int = 0
    var column:Int = 0
    
    
    init(row:Int,column:Int,character:Character){
        super.init(texture:mainTexture,color:UIColor.whiteColor(),size:CGSize(width:DEFAULT_WIDTH,height: DEFAULT_HEIGHT))
        self.colorBlendFactor = 1
        self.row = row
        self.column = column
        self.character = character;

        label = SKLabelNode()
        label!.fontColor = UIColor.blackColor()
        label!.fontSize = CGFloat(30)
        label!.text = String(character)

        self.addChild(label!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

