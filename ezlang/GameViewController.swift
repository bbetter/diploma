//
//  GameViewController.swift
//  ezlang
//
//  Created by Andriy Puhach on 11/25/15.
//  Copyright © 2015 5wheels. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import RealmSwift

class GameViewController: UIViewController {
    var scene: GameScene?
    var taskFactory:TaskFactory?
    var groupId:Int?

    let app = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var backButton: UIButton?
    @IBOutlet weak var pointsLabel: UILabel?

    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func skipItem(sender: AnyObject) {
            scene?.shuffle()
    }
    
    @IBAction func backPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: {
            self.app.database.saveUser(self.app.game.player)
            
            var allgroupslevels = self.app.database
                .getAllGroups(self.app.game.config.type)
                .flatMap{
                    $0.flatMap{$0.levels
                    }
            }
            var frwd = allgroupslevels?.filter{$0.doneForward == true}.count
            var dnba = allgroupslevels?.filter{$0.doneBackward == true}.count
            var pointsForward = allgroupslevels?.filter{$0.doneForward == true}.map{$0.difficulty * 10}.reduce(0, combine: +)
            var pointsBackward = allgroupslevels?.filter{$0.doneBackward == true}.map{$0.difficulty * 10}.reduce(0, combine: +)
            
            var points = pointsForward! + pointsBackward!
            var solvedCount = frwd!+dnba!
        
            if(self.app.game.player.uuid == nil) { return };
            self.app.api.updateUser(self.app.game.player.uuid!, points: points, count: solvedCount, handler: {_,_ in
                
            })
        })
    }
    
    override func shouldAutorotate() -> Bool {
        return (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.AllButUpsideDown
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure the view.
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        skView.showsFPS = true
        skView.showsNodeCount = true

        // Create and configure the scene.
        scene = GameScene(size:skView.bounds.size,groupId:groupId!,controller: self)
        scene!.groupId = groupId!
        scene!.scaleMode = .AspectFill

        scene!.groupFinished = {
            self.dismissViewControllerAnimated(true,completion: {
                self.app.database.saveUser(self.app.game.player)
            })
        }
        
    
        var groupPoints = app.database.getLevelsByGroupId(groupId!)?.filter{
            if(app.game.config.direction == .Forward){
                return $0.doneForward == true
            }
            else{
                return $0.doneBackward == true
            }
        }
            .map{$0.difficulty * 10}
            .reduce(0, combine: +)
        updatePoints(groupPoints!)
        skView.presentScene(scene)
    }
    
    func updatePoints(points:Int){
        pointsLabel?.text = String(points)
    }
}