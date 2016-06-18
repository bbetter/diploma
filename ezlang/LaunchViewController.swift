//
//  LaunchViewController.swift
//  ezlang
//
//  Created by mac on 01.06.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import Foundation
import UIKit

class LaunchViewController:UIViewController {
    @IBOutlet weak var logo: UIImageView!
    override func viewDidLoad() {
        logo.animateVisibility(true)
    }
}