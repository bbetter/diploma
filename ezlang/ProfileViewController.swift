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

    @IBAction func backButtonClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: {})
    }

    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        var allgroupslevels = app.database
            .getAllGroups(app.game.config.type)
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
        app.api.updateUser(app.game.player.uuid!, points: points, count: solvedCount, handler: {
            success,user in
          
        })
        self.rightCountLabel.text = "Пройдені завдання: " + String(solvedCount);
        self.pointsLabel.text = "Бали: " + String(points)
        var levels = Int(points/100)
        self.progressCircle.progress = CGFloat(points - levels*100)
        
        self.progressCircle.level = String(levels+1)
        self.progressCircle.toNextLevel = CGFloat(100 - (points - levels*100))
       

        
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