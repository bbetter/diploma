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
    //var level: GameLevel!

    override func prefersStatusBarHidden() -> Bool {
        return true
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
        scene = GameScene(size: skView.bounds.size)
        scene!.scaleMode = .AspectFill
        
        skView.presentScene(scene)
    }

}