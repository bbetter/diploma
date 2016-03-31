//
//  BackController.swift
//  ezlang
//
//  Created by mac on 29.02.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import Foundation
import UIKit


protocol Navigation{
    func backPressed()
    func navigateTo(nextControllerName:String)
}

class BackViewController: UIViewController,Navigation{
    func backPressed() {
        <#code#>
    }
    func navigateTo(name:String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier(name)
        vc.modalPresentationStyle = .FullScreen
        vc.modalTransitionStyle = .PartialCurl
        self.presentViewController(vc, animated: true, completion: nil)
    }

}