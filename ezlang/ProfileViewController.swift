//
//  UserProfileController.swift
//  ezlang
//
//  Created by mac on 13.01.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var progressCircle: CustomProgressView!

    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var rightCountLabel: UILabel!
    @IBOutlet weak var udidLabel: UILabel!

    @IBOutlet weak var dropProgressButton: UIButton!
    @IBAction func backButtonClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: {})
    }

    @IBOutlet weak var dropProgressView: UIButton!
    
    @IBAction func dropProgress() {
        Database.sharedInstance.clearProgress()
        EasyLangAPI.sharedInstance.me.request(.POST)
    }
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let allgroupslevels = try! Database.sharedInstance
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
        EasyLangAPI.sharedInstance.me.request(.POST, json: ["udid": Game.sharedInstance.player.uuid!, "points": points, "count": solvedCount]).onSuccess({
            _ in return;
        });

        self.rightCountLabel.text = "Пройдені завдання: " + String(solvedCount);
        self.pointsLabel.text = "Бали: " + String(points)
        let levels = Int(points / 100)
        self.progressCircle.progress = CGFloat(points - levels * 100)

        self.progressCircle.level = String(levels + 1)
        self.progressCircle.toNextLevel = CGFloat(100 - (points - levels * 100))
    }

//        app.api.fetchUser {
//            success, json in
//            if (success == true && json != nil) {
//                self.user = User.parseUser(json!)
//
//                self.rightCountLabel.text = "Пройдені завдання: " + String((self.user?.rightCount)!)
//                self.pointsLabel.text = "Бали: " + String((self.user?.points)!)
//
//                self.progressCircle.progress = CGFloat((self.user?.points)!)
//                self.progressCircle.toNextLevel = 130
//                self.progressCircle.level = String((self.user?.inGameLevel)!)
//            }
//        }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let gestures = self.view.gestureRecognizers as [UIGestureRecognizer]! {
            for gesture in gestures {
                self.view.removeGestureRecognizer(gesture)
            }
        }
    }

}