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
    typealias OnGroupFinishListener = () -> Void

    var currentGroupPoints = 0;
    var grid: Grid = Grid(size: .Normal)
    var taskHeader: SKLabelNode?

    public var groupFinished: OnGroupFinishListener?
    public var groupId: Int = 1
    
    var controller: GameViewController?

    var task: Task? = Task()
    var lettersSet: Set<LetterNode>?

    let lettersLayer = SKNode()

    var swipedLetters = [LetterNode]()
    var currentLetter: LetterNode?

    var app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }

    func shuffle() {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate

        task = TaskFactory.getNext(groupId, type: app.game.config.type, mode: app.game.config.mode)
        if (task == nil) {
            groupFinished?()
        } else {
            controller?.updatePoints(currentGroupPoints)
            grid = Grid(
            task: task!,
                    size: app.game.config.gridSize,
                    difficulty: app.game.config.difficulty,
                    direction: app.game.config.direction,
                    levelType: app.game.config.type
            )
            lettersSet = grid.getLetterNodes()
            updateLevelLetters(lettersSet!)
            currentLetter = nil
            swipedLetters.removeAll(keepCapacity: true)

            var header = task?.getTaskHeader(app.game.config.direction)
//            header.size = 
            if(app.game.config.type == LevelType.GrammarExercise){
                (taskHeader?.parent as! SKSpriteNode).size = CGSize(width:380,height:50)
            }
                taskHeader?.text = header

        }
    }

    func updateLevelLetters(letters: Set<LetterNode>) {
        lettersLayer.removeAllChildren()
        for letter in letters {
            lettersLayer.addChild(letter)
        }
    }

        override init(size:CGSize){
            super.init(size: size)
            anchorPoint = CGPoint(x: 0.5, y: 0.5)
            let background = SKSpriteNode(imageNamed: "background")
            background.name = "backrgound"
            let gameLayer = SKNode()
            gameLayer.name="game_layer"
            let headerLayer = SKSpriteNode(imageNamed: "menu_button")
            headerLayer.name = "header_layer"
            
            taskHeader = SKLabelNode(text: "")
            taskHeader?.name = "task_header"
            taskHeader?.horizontalAlignmentMode = .Center
            taskHeader?.fontColor = UIColor.blackColor()
            taskHeader?.fontSize = CGFloat(17.0)

            headerLayer.name = "task_header"
            headerLayer.size = CGSize(width: 200, height: 50)
            headerLayer.position = CGPoint(x: -10, y: 250)
            headerLayer.addChild(taskHeader!)

            var size = app.game.config.gridSize.getSize().rows
            var nodeSize = size == 5 ? 70 : 40
            lettersLayer.position = CGPoint(x: CGFloat(-nodeSize) * CGFloat(size) / 2, y: CGFloat(-nodeSize) * CGFloat(size) / 2)
            
            lettersLayer.name="lettersLayer"

            gameLayer.addChild(lettersLayer)

            addChild(background)
            addChild(gameLayer)
            addChild(headerLayer)
        }

    convenience init(size: CGSize,groupId:Int,controller:GameViewController) {
        self.init(size: size)
        self.groupId = groupId
        self.controller = controller
        shuffle();
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        let location = touch.locationInNode(lettersLayer) as CGPoint
            let (success, row, column) = location.toPoint(lettersLayer,size: (app.game.config.gridSize.getSize().rows))
            if success {

                let letter = lettersSet!.filter {
                    item in
                    item.row == row &&
                            item.column == column
                }.first
                if (letter != currentLetter) {
                    currentLetter = letter
                    if (!swipedLetters.contains(letter!)) {
                        letter?.color = UIColor.yellowColor()
                        swipedLetters.append(letter!)
                    } else {
                        let lettersToBeRemoved = swipedLetters[swipedLetters.indexOf(letter!)! ..< swipedLetters.count]
                        lettersToBeRemoved.forEach({ x in x.color = UIColor.whiteColor() })
                        swipedLetters.removeRange(swipedLetters.indexOf(letter!)! ..< swipedLetters.count)
                    }
                }
            }
    }


    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        let location = touch.locationInNode(lettersLayer)
        let locationInScene = touch.locationInNode(self)
        let (success, row, column) = location.toPoint(lettersLayer,size: (app.game.config.gridSize.getSize().rows))
        if success {

            let letter = lettersSet?.filter {
                item in item.row == row && item.column == column
            }.first
            if (letter != currentLetter) {
                if ((currentLetter?.isARound(letter!)) != nil) {
                    currentLetter = letter
                    if (!swipedLetters.contains(letter!)) {
                        letter!.color = UIColor.yellowColor()
                        swipedLetters.append(letter!)
                    } else {
                        let lettersToBeRemoved = swipedLetters[swipedLetters.indexOf(letter!)! ..< swipedLetters.count]
                        lettersToBeRemoved.forEach({ x in x.color = UIColor.whiteColor() })
                        swipedLetters.removeRange(swipedLetters.indexOf(letter!)! ..< swipedLetters.count)
                    }
                } else {
                    swipedLetters.removeAll()

                    try! swipedLetters.forEach({ $0.color = UIColor.whiteColor() })
                }

            }

        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        let location = touch.locationInNode(lettersLayer) as CGPoint


        currentLetter = nil
        let app = UIApplication.sharedApplication().delegate as! AppDelegate

        var answer = String(swipedLetters.map {
            item in item.character
        })
        if let success = task?.check(answer, direction: .Forward) {
            if (success) {
                currentGroupPoints = currentGroupPoints + task!.difficulty! * 10;
                app.game.player.points = app.game.player.points! + currentGroupPoints
                for (i, letter) in swipedLetters.enumerate() {
                    var node: LetterNode = letter as LetterNode
                    print("row:\(node.row);column:\(node.column);letter:\(node.character)")
                    node.color = UIColor.greenColor()
                    var duration: NSTimeInterval = NSTimeInterval(0.3)
                    node.label?.runAction(SKAction.sequence([
                            SKAction.moveTo(CGPoint(x: 10.0 * CGFloat(i), y: 0.2), duration: duration),
                            SKAction.customActionWithDuration(duration, actionBlock: {
                                node, elapsedTime in
                                var spriteNode = node as! SKLabelNode
                                spriteNode.colorBlendFactor = elapsedTime / CGFloat(duration);
                            })]))
                    node.color = UIColor.greenColor();
                }

                app.database.setLevelDone((task?.levelId)!, direction: .Forward)
                shuffle()
            } else {
                for (i, letter) in swipedLetters.enumerate() {
                    var node: LetterNode = letter as LetterNode
                    print("row:\(node.row);column:\(node.column);letter:\(node.character)")
                    var duration: NSTimeInterval = NSTimeInterval(0.4)
                    node.color = UIColor.redColor()
                    node.runAction(SKAction.sequence([
                            SKAction.customActionWithDuration(duration, actionBlock: {
                                node, elapsedTime in
                                var spriteNode = node as! SKSpriteNode
                                spriteNode.colorBlendFactor = elapsedTime / CGFloat(duration);
                            }),
                            SKAction.runBlock {
                                node.color = UIColor.whiteColor()
                            }]))
                    swipedLetters.removeAll()
                }
            }
        }
    }
}

