//
//  GameScene.swift
//  ezlang
//
//  Created by Andriy Puhach on 11/25/15.
//  Copyright © 2015 5wheels. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    //var level: GameLevel!

    let gameLayer = SKNode()
    let lettersLayer = SKNode()

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

        gameLayer.addChild(lettersLayer)
        addChild(background)
        addChild(gameLayer)
    }

    func updateLevelLetters(letters: Set<LetterNode>) {
        for letter in letters {
            let sprite = LetterNode(row:0, column:0, character: "C")
            lettersLayer.addChild(sprite)
        }
    }

    func pointForColumn(column: Int, row: Int) -> CGPoint {
        return CGPoint(
        x: CGFloat(column) * 70 + 70 / 2,
                y: CGFloat(row) * 70 + 70 / 2)
    }

    func convertPoint(point: CGPoint) -> (success:Bool, row:Int, column:Int) {
        if point.x >= 0 && point.x < CGFloat(5) * 70 &&
                point.y >= 0 && point.y < CGFloat(5) * 70 {
            var rect = lettersLayer.frame

            return (true, Int((point.y - rect.origin.y) / 70), Int(point.x / 70))
        } else {
            return (false, 0, 0)  // invalid location
        }
    }

    var swipedLetters = [LetterNode]()
    var currentLetter: LetterNode?

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        let location = touch.locationInNode(lettersLayer)
        let (success, row, column) = convertPoint(location)
        if success {
//            if let letter = level.letterAtColumn(row, column: column) {
//                if (letter != currentLetter) {
//                    currentLetter = letter
//                    if (!swipedLetters.contains(letter)) {
//                        letter.sprite?.color = UIColor.yellowColor()
//                        swipedLetters.append(letter)
//                    } else {
//                        let allLetters = try! swipedLetters.map({ $0.sprite })
//                        let lettersToBeRemoved = allLetters[swipedLetters.indexOf(letter)! ..< swipedLetters.count]
//                        lettersToBeRemoved.forEach({ x in x!.color = UIColor.whiteColor() })
//                        swipedLetters.removeRange(swipedLetters.indexOf(letter)! ..< swipedLetters.count)
//                    }
//                }
//            }
//        }
        }
    }

//        func isARound(letter: Letter) -> Bool {
//            return (letter.row - 1 == currentLetter!.row - 1 || letter.row + 1 == currentLetter!.row + 1) ||
//                    (letter.column - 1 == currentLetter!.column - 1 || letter.column + 1 == currentLetter!.column + 1)
//        }

        override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
            let touch = touches.first as UITouch!
            let location = touch.locationInNode(lettersLayer)
            let locationInScene = touch.locationInNode(self)
            let (success, row, column) = convertPoint(location)
            if success {

//            if let letter = level.letterAtColumn(row, column: column) {
//                if (letter != currentLetter) {
//
//                    if (isARound(letter)) {
//                        currentLetter = letter
//                        if (!swipedLetters.contains(letter)) {
//                            letter.color = UIColor.yellowColor()
//                            swipedLetters.append(letter)
//                        } else {
//                            let allLetters = try! swipedLetters.map({ $0.sprite })
//                            let lettersToBeRemoved = allLetters[swipedLetters.indexOf(letter)! ..< swipedLetters.count]
//                            lettersToBeRemoved.forEach({ x in x!.color = UIColor.whiteColor() })
//                            swipedLetters.removeRange(swipedLetters.indexOf(letter)! ..< swipedLetters.count)
//                        }
//                    } else {
//                        swipedLetters.removeAll()
//
//                        let allLetters = try! swipedLetters.map({ $0.sprite })
//                        try! allLetters.forEach({ $0?.color = UIColor.whiteColor() })
//                    }
//
//                }
//            }
            }
        }

        override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
            //     currentLetter = nil
            //     var i = 0
//        try! swipedLetters.forEach({
//            letter in
//            print("row:\(letter.row);column:\(letter.column);letter:\(letter.letter)")
//            letter.sprite?.runAction(SKAction.sequence([
//                    SKAction.moveTo(CGPoint(x: 50.0 * CGFloat(i), y: 0), duration: 0.5),
//                    SKAction.runBlock({
//                        self.updateLevelLetters(self.level.shuffle())
//                    })
//            ]))
//            letter.sprite?.color = UIColor.greenColor()
//            letter.sprite?.zPosition = 2
//            i++
//        }
        }
    }
