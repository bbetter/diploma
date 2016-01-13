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
    
    @IBAction func backButtonClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: {})
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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