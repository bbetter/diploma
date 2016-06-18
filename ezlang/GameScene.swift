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
import CoreGraphics
import AVFoundation

class GameScene: SKScene {
    
    typealias OnGroupFinishListener = () -> Void
    
    var currentGroupPoints = 0;
    var tasksCount = (all: -1, done: -1);
    
    //region ui
    let taskHeader: SKLabelNode? = SKLabelNode(text: "")
    let lettersLayer = SKNode()
    let solvedLabel = SKLabelNode(text: "0/0")
    let pointsLabel = SKLabelNode(text: "0")
    
    //endregion
    internal var groupFinished: OnGroupFinishListener?
    internal var groupId: Int = 1
    
    var controller: GameViewController?
    
    var task: Task? = Task()
    var lettersSet: Set<LetterNode>?
    
    var swipedLetters = [LetterNode]()
    
    var lineCount = 0
    
    var path = CGPathCreateMutable()
    var currentLetter: LetterNode?
    
    var screenWidth: CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
    
    var gridSize: CGFloat {
        return CGFloat(Game.sharedInstance.config.gridSize.getSize().rows)
    }
    
    var letterNodeSize: CGFloat {
        get {
            return CGFloat(Game.sharedInstance.config.gridSize.getSize().rows == 5 ? 70 : 40)
        }
    }
    
    var nodeSize: CGFloat {
        get {
            return CGFloat(Game.sharedInstance.config.gridSize.getSize().rows == 5 ? 40 : 30)
        }
    }
    
    var isRating: Bool {
        get {
            return Game.sharedInstance.config.mode == .Rating
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    func shuffle() {
        if (tasksCount == (all: -1, done: -1)) {
            tasksCount = TaskFactory.getCount(groupId)
        }
        task = TaskFactory.getNext(groupId)
        if (task == nil) {
            groupFinished?()
        } else {
            
            pointsLabel.text = String(currentGroupPoints)
            solvedLabel.text = String(tasksCount.done) + "/" + String(tasksCount.all)
            tasksCount.done = tasksCount.done + 1
            
            let grid = Grid(
                task: task!,
                size: Game.sharedInstance.config.gridSize,
                difficulty: Game.sharedInstance.config.difficulty,
                direction: Game.sharedInstance.config.direction,
                levelType: Game.sharedInstance.config.type
            )
            lettersSet = grid.getLetterNodes()
            updateLevelLetters(lettersSet!)
            currentLetter = nil
            swipedLetters.removeAll(keepCapacity: true)
            
            let header = task?.getTaskHeader(Game.sharedInstance.config.direction)
            if (Game.sharedInstance.config.type == LevelType.GrammarExercise) {
                (taskHeader?.parent as! SKSpriteNode).size = CGSize(width: 380, height: 50)
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
    
    func createTopMenu() {
        
        let topLayer = SKNode()
        let xPos = -4 * nodeSize
        
        topLayer.name = "top_layer"
        topLayer.position = CGPoint(x: xPos, y: 310)
        
        var lastXPos: CGFloat = CGFloat(0)
        let back = SKSpriteNode(imageNamed: "arr24")
        back.name = "back"
        back.size = CGSize(width: nodeSize / 2, height: nodeSize / 2)
        topLayer.addChild(back)
        
        if (!isRating) {
            let skip = SKSpriteNode(imageNamed: "skip_level_ic")
            skip.name = "skip"
            lastXPos = lastXPos + (nodeSize + 10)
            skip.position = CGPoint(x: lastXPos, y: 0)
            skip.size = CGSize(width: nodeSize / 2, height: nodeSize / 2)
            topLayer.addChild(skip)
        }
        
        let help = SKSpriteNode(imageNamed: "help_circle_ic")
        help.name = "help"
        lastXPos = lastXPos + (nodeSize + 10)
        help.position = CGPoint(x: lastXPos, y: 0)
        help.size = CGSize(width: nodeSize / 2, height: nodeSize / 2)
        topLayer.addChild(help)
        
        if (isRating) {
            solvedLabel.name = "solved"
            solvedLabel.fontSize = CGFloat(18)
            solvedLabel.fontColor = UIColor.blackColor()
            solvedLabel.fontName = "System-Bold"
            solvedLabel.position = CGPoint(x: screenWidth - nodeSize - 50, y: -7)
            topLayer.addChild(solvedLabel)
            
            pointsLabel.name = "points"
            pointsLabel.fontSize = CGFloat(18)
            pointsLabel.fontName = "System-Bold"
            pointsLabel.fontColor = UIColor.blackColor()
            pointsLabel.position = CGPoint(x: screenWidth - 2 * nodeSize - 60, y: -7)
            topLayer.addChild(pointsLabel)
            
        }
        addChild(topLayer)
    }
    
    func createHeader() {
        let headerLayer = SKSpriteNode(imageNamed: "menu_button")
        headerLayer.name = "header_layer"
        
        taskHeader?.name = "task_header"
        taskHeader?.horizontalAlignmentMode = .Center
        taskHeader?.fontColor = UIColor.blackColor()
        taskHeader?.fontSize = CGFloat(17.0)
        
        headerLayer.name = "task_header"
        headerLayer.size = CGSize(width: 200, height: 50)
        headerLayer.position = CGPoint(x: -10, y: 250)
        headerLayer.addChild(taskHeader!)
        addChild(headerLayer)
    }
    
    func createGameField() {
        let gameLayer = SKNode()
        gameLayer.name = "game_layer"
        lettersLayer.position = CGPoint(x: -letterNodeSize * gridSize / 2, y: -letterNodeSize * gridSize / 2)
        lettersLayer.name = "lettersLayer"
        gameLayer.addChild(lettersLayer)
        addChild(gameLayer)
    }
    
    func createBottom() {
        let bottomLayer = SKNode()
        
        bottomLayer.name = "bottom_layer"
        
        let allNodesWidth = gridSize * nodeSize
            + CGFloat(60)
        // 20 + 20 + 20
        
        let xPos = -allNodesWidth / 3
        bottomLayer.position = CGPoint(x: xPos, y: -7.0 * nodeSize)
        
        let home = SKSpriteNode(imageNamed: "menu_button")
        let homeIn = SKSpriteNode(imageNamed: "home")
        homeIn.size = CGSize(width: nodeSize / 2, height: nodeSize / 2)
        homeIn.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        homeIn.name = "home"
        home.size = CGSize(width: nodeSize, height: nodeSize)
        home.addChild(homeIn)
        bottomLayer.addChild(home)
        
        
        let info = SKSpriteNode(imageNamed: "menu_button")
        info.position = CGPoint(x: nodeSize + 20, y: 0)
        let infoIn = SKSpriteNode(imageNamed: "info")
        infoIn.size = CGSize(width: nodeSize / 2, height: nodeSize / 2)
        infoIn.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        infoIn.name = "info"
        info.size = CGSize(width: nodeSize, height: nodeSize)
        info.addChild(infoIn)
        bottomLayer.addChild(info)
        
        let share = SKSpriteNode(imageNamed: "menu_button")
        share.position = CGPoint(x: nodeSize * 2 + 40, y: 0)
        let shareIn = SKSpriteNode(imageNamed: "share")
        shareIn.size = CGSize(width: nodeSize / 2, height: nodeSize / 2)
        shareIn.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        shareIn.name = "share"
        share.size = CGSize(width: nodeSize, height: nodeSize)
        share.addChild(shareIn)
        bottomLayer.addChild(share)
        
        addChild(bottomLayer)
    }
    
    func showHelpDialog() {
        let str = self.task?.getWord(Game.sharedInstance.config.direction) as String?
        let alertController = UIAlertController(title: "Choose Hint", message: "Choose one of three possible hints", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Sound the word", style: .Default, handler: {
            action in
            if(Game.sharedInstance.config.soundEnabled){
                AVSpeechSynthesizer.wordToSound(self.task?.getWord(Game.sharedInstance.config.direction))
            }
        }))
        alertController.addAction(UIAlertAction(title: "Half of the letters", style: .Default, handler: {
            action in
            let str2 = str?.removeHalfOfTheLetters()
            let resultAlert = UIAlertController(title: "Here you are", message: str2, preferredStyle: .ActionSheet)
            resultAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in }))
            self.controller?.presentViewController(resultAlert, animated: true, completion: {})
        }))
        alertController.addAction(UIAlertAction(title: "Show me the word", style: .Default, handler: {
            action in
            let resultAlert = UIAlertController(title: "Here you are", message: str, preferredStyle: .ActionSheet)
            resultAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in }))
            self.controller?.presentViewController(resultAlert, animated: true, completion: {})
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in }))
        self.controller?.presentViewController(alertController, animated: true, completion: {})
    }
    
    //handle special sprite touches, if not, use default func
    func onSpriteTouched(touch: UITouch, defaultBody: () -> Void) {
        let location = touch.locationInNode(self)
        if (self.nodeAtPoint(location).name == nil) {
            defaultBody()
            return;
        }
        switch (self.nodeAtPoint(location).name!) {
        case "home":
            self.controller?.view.window!.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
            return;
        case "info":
            self.controller?.performSegueWithIdentifier("game_help", sender: nil)
            return;
        case "skip":
            self.shuffle()
            return;
        case "help":
            showHelpDialog()
            return;
        case "share":
            let objectsToShare = [snapshot] as [AnyObject]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
            self.controller?.presentViewController(activityVC, animated: true, completion: nil)
            return;
        case "back":
            self.controller?.dismissViewControllerAnimated(true, completion: {})
            return;
        default:
            defaultBody()
            return;
        }
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let background = SKSpriteNode(imageNamed: "background")
        background.size = CGSize(width: CGRectGetWidth(UIScreen.mainScreen().bounds),
                                 height: CGRectGetHeight(UIScreen.mainScreen().bounds))
        background.name = "background"
        
        addChild(background)
        createTopMenu()
        createHeader()
        createGameField()
        createBottom()
    }
    
    convenience init(size: CGSize, groupId: Int, controller: GameViewController) {
        self.init(size: size)
        self.groupId = groupId
        self.controller = controller
        shuffle();
    }
    
    //MARK: touch interactions
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        
        onSpriteTouched(touch) {
            let location = touch.locationInNode(self.lettersLayer) as CGPoint
            
            let (success, row, column) = location.toPoint(self.lettersLayer, size: (Game.sharedInstance.config.gridSize.getSize().rows))
            if success {
                let letter = self.lettersSet!.filter {
                    item in
                    item.row == row &&
                        item.column == column
                    }.first
                //CGPathMoveToPoint(self.path, nil, (letter?.position.x)!, (letter?.position.y)!)
                if (letter != self.currentLetter) {
                    self.currentLetter = letter
                    if (!self.swipedLetters.contains(letter!)) {
                        letter?.color = UIColor.yellowColor()
                        self.swipedLetters.append(letter!)
                    } else {
                        let lettersToBeRemoved = self.swipedLetters[self.swipedLetters.indexOf(letter!)! ..< self.swipedLetters.count]
                        lettersToBeRemoved.forEach({ x in x.color = UIColor.whiteColor() })
                        self.swipedLetters.removeRange(self.swipedLetters.indexOf(letter!)! ..< self.swipedLetters.count)
                    }
                } else {
                    print("debug")
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        let location = touch.locationInNode(lettersLayer)
        let (success, row, column) = location.toPoint(lettersLayer, size: Int(gridSize))
        if success {
            let letter = lettersSet?.filter {
                item in item.row == row && item.column == column
                }.first
            if (letter != currentLetter) {
                if ((currentLetter?.isARound(letter!)) != nil) {
                    
                    currentLetter = letter
                    //                    let touchedItem = lettersLayer.children.filter {
                    //                        item in item == currentLetter
                    //                    }.first;
                    //                    lettersLayer.removeChildrenInArray(lettersLayer.children.filter {
                    //                        item in item is SKShapeNode
                    //                    })
                    //                   let line = createLine()
                    //                   CGPathMoveToPoint(path, nil, (touchedItem?.position.x)!, (touchedItem?.position.y)!)
                    if (!swipedLetters.contains(letter!)) {
                        letter!.color = UIColor.yellowColor()
                        swipedLetters.append(letter!)
                        //   CGPathAddLineToPoint(path, nil, (touchedItem?.position.x)!, (touchedItem?.position.y)!)
                        // lettersLayer.addChild(line)
                    } else {
                        //CGPathCloseSubpath(path)
                        let lettersToBeRemoved = swipedLetters[swipedLetters.indexOf(letter!)! ..< swipedLetters.count]
                        lettersToBeRemoved.forEach {
                            letter in
                            letter.color = UIColor.whiteColor()
                        }
                        swipedLetters.removeRange(swipedLetters.indexOf(letter!)! ..< swipedLetters.count)
                    }
                } else {
                    swipedLetters.removeAll()
                    swipedLetters.forEach({ $0.color = UIColor.whiteColor() })
                }
            }
        }
    }
    
    func createLine() -> SKShapeNode {
        let line = SKShapeNode()
        line.path = path
        line.strokeColor = UIColor.blueColor()
        line.lineWidth = 6
        line.lineCap = CGLineCap.Square
        return line
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(currentLetter == nil) {
            return;
        }
        if(!swipedLetters.contains(currentLetter!)){
            swipedLetters.append(currentLetter!)
        }
        currentLetter = nil
        let answer = String(swipedLetters.map {
            item in item.character
            })
        
        path = CGPathCreateMutable()
        
        lettersLayer.removeChildrenInArray(lettersLayer.children.filter {
            item in item is SKShapeNode
            })
        if let success = task?.check(answer, direction: .Forward) {
            if (success) {
                
                let wordLength = answer.characters.count
                
                let startY: CGFloat = 220.0
                let startX: CGFloat = 30.0
                
                let wordSize = startX + CGFloat((wordLength + 3) * 40)
                var rowCount: Int = Int(ceil(wordSize / screenWidth))
                
                currentGroupPoints = currentGroupPoints + task!.difficulty! * 10;
                
                if isRating {
                    Game.sharedInstance.player.points = Game.sharedInstance.player.points! + currentGroupPoints
                    Database.sharedInstance.setLevelDone((self.task?.levelId)!)
                }
                if (rowCount == 0) {
                    rowCount = 1
                }
                let rows = swipedLetters.splitBy(Int(swipedLetters.count / rowCount))
                
                for rowIndex in 0 ..< rowCount {
                    let letters = rows[rowIndex]
                    lettersLayer.runAction(SKAction.sequence([
                        SKAction.runBlock {
                            for (i, letter) in letters.enumerate() {
                                
                                let node: LetterNode = letter as LetterNode
                                print("row:\(node.row);column:\(node.column);letter:\(node.character)")
                                node.color = UIColor.greenColor()
                                node.zPosition = 10
                                let duration: NSTimeInterval = NSTimeInterval(0.4)
                                node.runAction(SKAction.sequence([
                                    SKAction.moveTo(CGPoint(
                                        x: CGFloat(node.size.width + node.size.width * CGFloat(i)),
                                        y: CGFloat(startY - (node.size.width * CGFloat(rowIndex)))
                                        ), duration: duration),
                                    SKAction.colorizeWithColor(UIColor.greenColor(), colorBlendFactor: 1, duration: duration),
                                    ]))
                            }
                        },
                        SKAction.waitForDuration(1.0),
                        
                        SKAction.runAction(SKAction.sequence([
                            SKAction.fadeInWithDuration(0.2),
                            SKAction.scaleBy(1.15, duration: 0.2),
                            SKAction.waitForDuration(0.2),
                            SKAction.scaleBy(1.0, duration: 0.2),
                            SKAction.fadeOutWithDuration(0.2),
                            ]),onChildWithName: "points_plus"),
                        
                        SKAction.runBlock {
                            self.shuffle()
                        }
                        ]))
                }
            } else {
                for (_, letter) in swipedLetters.enumerate() {
                    let node: LetterNode = letter as LetterNode
                    print("row:\(node.row);column:\(node.column);letter:\(node.character)")
                    node.runAction(
                        SKAction.sequence([
                            SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1, duration: 0.4),
                            SKAction.shake(0.4, amplitudeX: 5, amplitudeY: 5),
                            SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1, duration: 0.4)
                            ])
                    )
                    swipedLetters.removeAll()
                }
            }
        }
    }
    
}

