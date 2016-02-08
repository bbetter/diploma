//
//  HelpViewController.swift
//  ezlang
//
//  Created by mac on 31.01.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import UIKit

class HelpViewController : UIViewController{
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var infoView: UITextView?
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        titleLabel!.text = NSLocalizedString("helptext_title",comment:"")
        infoView!.text = NSLocalizedString("helptext",comment:"")
    }

    @IBAction func backPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
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
