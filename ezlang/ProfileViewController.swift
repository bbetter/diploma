//
//  UserProfileController.swift
//  ezlang
//
//  Created by mac on 13.01.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController{

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
        user = User.getMockUser()
    
        rightCountLabel.text = "Пройдені завдання: " + String((user?.rightCount)!)
        pointsLabel.text = "Бали: " + String((user?.points)!)
        //TODO: remove, used only in testing purposes
        udidLabel.text = "UDID: " + String((user?.uuid)!)
        
        progressCircle.progress = CGFloat((user?.points)!)
        progressCircle.toNextLevel = 130
        progressCircle.level = String((user?.inGameLevel)!)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if let gestures = self.view.gestureRecognizers as [UIGestureRecognizer]! {
            for gesture in gestures {
                self.view.removeGestureRecognizer(gesture)
            }
        }
       
        
    }
}