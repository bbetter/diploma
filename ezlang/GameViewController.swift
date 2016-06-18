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
    var taskFactory: TaskFactory?
    var groupId: Int?

    let app = UIApplication.sharedApplication().delegate as! AppDelegate

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func countPoints()->(Int,Int){
        let allgroupslevels =
            Database.sharedInstance
                .getAllGroups(Game.sharedInstance.config.type)
                .flatMap {
                    $0.flatMap {
                        $0.levels
                    }
        }
        let frwd = allgroupslevels?.filter {
                $0.doneForward == true
            }.count
        let dnba = allgroupslevels?.filter {
                $0.doneBackward == true
            }.count
        let pointsForward = try! allgroupslevels?.filter {
                $0.doneForward == true
            }.map {
                $0.difficulty * 10
            }.reduce(0, combine: +)
        let pointsBackward = try! allgroupslevels?.filter {
                $0.doneBackward == true
            }.map {
                $0.difficulty * 10
            }.reduce(0, combine: +)
        
        let points = pointsForward! + pointsBackward!
        let solvedCount = frwd! + dnba!
        
        return (points,solvedCount)
    }

    @IBAction func backPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: {
            if(Game.sharedInstance.config.mode == .Rating) {
                
                Database.sharedInstance.saveUser(Game.sharedInstance.player)
                
                let (points,solvedCount) = self.countPoints()
                
                if (Game.sharedInstance.player.uuid == nil) {
                    return
                };
                
                EasyLangAPI.sharedInstance.me
                    .request(.POST, json: ["udid": Game.sharedInstance.player.uuid!, "points": points, "count": solvedCount])
                    .onSuccess({
                        e in print(e)
                    });
                }
        });
    }

    override func viewWillLayoutSubviews() {
        let skView = view as! SKView
    
        skView.multipleTouchEnabled = false
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size, groupId: groupId!, controller: self)
        scene?.groupId = groupId!
        scene?.scaleMode = .Fill
        
        scene?.groupFinished = {
            self.dismissViewControllerAnimated(true, completion: {
                if(Game.sharedInstance.config.mode == .Rating){
                    Database.sharedInstance.saveUser(Game.sharedInstance.player)
                }
            })
        }
        
        
        let groupPoints = try! Database.sharedInstance.getLevelsByGroupId(groupId!)?.filter {
            if (Game.sharedInstance.config.direction == .Forward) {
                return $0.doneForward == true
            } else {
                return $0.doneBackward == true
            }
            }
            .map {
                $0.difficulty * 10
            }
            .reduce(0, combine: +)
//        if(Game.sharedInstance.config.mode == .Rating){
//            updatePoints(groupPoints!)
//        }
//        else{
//            pointsLabel?.animateVisibility(false)
//        }
        skView.presentScene(scene)
    }

//    func updatePoints(points: Int) {
//        pointsLabel?.text = String(points)
//    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let gestures = self.view.gestureRecognizers as [UIGestureRecognizer]! {
            for gesture in gestures {
                self.view.removeGestureRecognizer(gesture)
            }
        }
    }
}