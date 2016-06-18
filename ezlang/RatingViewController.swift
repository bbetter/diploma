//
// Created by mac on 06.04.16.
// Copyright (c) 2016 5wheels. All rights reserved.
//

import Foundation
import UIKit

class RatingViewController: UIViewController {
    
    @IBOutlet weak var webView:UIWebView?
    
    @IBAction func backPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL (string: "http://b12dc0e3.ngrok.io/api/rating?udid="+(UIDevice.currentDevice().identifierForVendor?.UUIDString)!);
        let requestObj = NSURLRequest(URL: url!);
        webView?.loadRequest(requestObj);
    }
}
