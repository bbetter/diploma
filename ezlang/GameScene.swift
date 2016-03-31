//
//  GameScene.swift
//  ezlang
//
//  Created by Andriy Puhach on 11/25/15.
//  Copyright © 2015 5wheels. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class GameScene: SKScene {

    var grid: Grid = Grid(size: .Normal)

    let gameLayer = SKNode()
    let headerLayer = SKLabelNode()
    let lettersLayer = SKNode()

    var swipedLetters = [LetterNode]()
    var currentLetter: LetterNode?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }

    override init(size: CGSize) {
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)

        let background = SKSpriteNode(imageNamed: "background")
        lettersLayer.position = CGPoint(
        x: -70 * CGFloat(5) / 2,
                y: -70 * CGFloat(5) / 2)

        headerLayer.position = CGPoint(
            x: -70 * CGFloat(5) / 2,
            y: -70 * CGFloat(5) / 2
        )
        
        headerLayer.color = UIColor.blackColor()
        headerLayer.fontSize = UIFont.buttonFontSize()
        headerLayer.text = "test"
      //  gameLayer.addChild(headerLayer)
        gameLayer.addChild(lettersLayer)

        
        addChild(background)
        addChild(headerLayer)
        addChild(gameLayer)
        

        let task = TaskFactory.getNext(1, type: .LookingForWord, mode: .Training)
        
        grid = Grid(
                task: task,
                size: .Normal,
                difficulty: .Easy,
                direction: .Forward,
                levelType: .LookingForWord
        )

        updateLevelLetters(grid.getLetterNodes())
        headerLayer.text = task.getTaskHeader(.Forward)
    }

    func updateLevelLetters(letters: Set<LetterNode>) {
        lettersLayer.removeAllChildren()
        for letter in letters {
            lettersLayer.addChild(letter)
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        let location = touch.locationInNode(lettersLayer) as CGPoint
        let (success, row, column) = location.toPoint(lettersLayer)
        if success {
            var rowCount = grid.size?.getSize().rows
            if let letter = LetterNode(row: rowCount!-row, column: column, character: grid.charGrid[row - 1, column]) as LetterNode? {
                if (letter != currentLetter) {
                    currentLetter = letter
                    if (!swipedLetters.contains(letter)) {
                        letter.color = UIColor.yellowColor()
                        swipedLetters.append(letter)
                    } else {
                        let lettersToBeRemoved = swipedLetters[swipedLetters.indexOf(letter)! ..< swipedLetters.count]
                        lettersToBeRemoved.forEach({ x in x.color = UIColor.whiteColor() })
                        swipedLetters.removeRange(swipedLetters.indexOf(letter)! ..< swipedLetters.count)
                    }
                }
            }
        }
    }


    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        let location = touch.locationInNode(lettersLayer)
        let locationInScene = touch.locationInNode(self)
        var rowCount = grid.size?.getSize().rows
        let (success, row, column) = location.toPoint(lettersLayer)
        if success {

            if let letter =
//                lettersLayer.children.filter(<#T##includeElement: (SKNode) throws -> Bool##(SKNode) throws -> Bool#>)
                LetterNode(row: rowCount!-row, column: column, character: grid.charGrid[rowCount! - row, column]) as LetterNode? {
                if (letter != currentLetter) {

                    if (currentLetter!.isARound(letter)) {
                        currentLetter = letter
                        if (!swipedLetters.contains(letter)) {
                            letter.color = UIColor.yellowColor()
                            swipedLetters.append(letter)
                        } else {
                            let lettersToBeRemoved = swipedLetters[swipedLetters.indexOf(letter)! ..< swipedLetters.count]
                            lettersToBeRemoved.forEach({ x in x.color = UIColor.whiteColor() })
                            swipedLetters.removeRange(swipedLetters.indexOf(letter)! ..< swipedLetters.count)
                        }
                    } else {
                        swipedLetters.removeAll()

                        try! swipedLetters.forEach({ $0.color = UIColor.whiteColor() })
                    }

                }
            }
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        currentLetter = nil
        var i = 0
        try! swipedLetters.forEach({
            letter in
            var node: LetterNode = letter as LetterNode
            print("row:\(node.row);column:\(node.column);letter:\(node.character)")
            node.label?.runAction(SKAction.sequence([
                    SKAction.moveTo(CGPoint(x: 50.0 * CGFloat(i), y: 0), duration: 0.5),
                    SKAction.runBlock({
                        //
                    })
            ]))
            node.color = UIColor.greenColor()
            node.zPosition = 2
            i++
        })
    }
}
