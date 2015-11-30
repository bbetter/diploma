//
//  GameScene.swift
//  ezlang
//
//  Created by Andriy Puhach on 11/25/15.
//  Copyright © 2015 5wheels. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene : SKScene{
    var level: Level!
    
    let TileWidth: CGFloat = 50
    let TileHeight: CGFloat = 50
    
    let gameLayer = SKNode()
    let lettersLayer = SKNode()
    
    var swipeFromColumn: Int? = nil
    var swipeFromRow: Int? = nil
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "gameplay_bgNEW")
        addChild(background)
        
        addChild(gameLayer)
        
        let layerPosition = CGPoint(
            x: -TileWidth * CGFloat(NumColumns) / 2,
            y: -TileHeight * CGFloat(NumRows) / 2)
        
        lettersLayer.position = layerPosition
        gameLayer.addChild(lettersLayer)
    }
    
    func addSpritesForLetters(letters: Set<Letter>) {
        lettersLayer.removeAllChildren()
        for letter in letters {
            let sprite = SKSpriteNode(texture: SKTexture(imageNamed: "word_block"),size: CGSize(width: 50,height: 50))
            sprite.colorBlendFactor = 1
            sprite.color = UIColor.whiteColor()
            let label : SKLabelNode = SKLabelNode()
            label.fontColor = UIColor.blackColor()
            label.fontSize = CGFloat(15)
            label.text = letter.letter
            sprite.addChild(label)
            sprite.position = pointForColumn(letter.column, row:letter.row)
            lettersLayer.addChild(sprite)
        
            letter.sprite = sprite
        }
    }
    
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2)
    }
    
    func convertPoint(point: CGPoint) -> (success: Bool, row: Int, column: Int) {
        if point.x >= 0 && point.x < CGFloat(NumColumns)*TileWidth &&
            point.y >= 0 && point.y < CGFloat(NumRows)*TileHeight {
                return (true, Int(point.x / TileWidth), Int(point.y / TileHeight))
        } else {
            return (false, 0, 0)  // invalid location
        }
    }
    
    var swipedLetters = [Letter]()
   
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        let location = touch.locationInNode(lettersLayer)
        // 2
        let (success, row, column) = convertPoint(location)
        if success {
            // 3
            if let letter = level.letterAtColumn(row,column: column) {
                if(!swipedLetters.contains(letter)){
                    letter.sprite?.color = UIColor.yellowColor()
                    
                    swipedLetters.append(letter)
                }
            }
        }

    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 1
        var i = 0

        swipedLetters.forEach({
            print("row:\($0.row);column:\($0.column);letter:\($0.letter)")
            $0.sprite?.runAction( SKAction.sequence([
                SKAction.moveTo(CGPoint(x: 50.0 * CGFloat(i),y: 0), duration:1.0),
                SKAction.runBlock({
                    self.addSpritesForLetters(self.level.shuffle())
                })
                ]))
            $0.sprite?.color = UIColor.greenColor()
            $0.sprite?.zPosition = 2
            i++
            })
    }

    
  }
