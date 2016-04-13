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
        let url = NSURL (string: "http://192.168.212.101.xip.io:3000/api/rating?udid="+(UIDevice.currentDevice().identifierForVendor?.UUIDString)!);
        let requestObj = NSURLRequest(URL: url!);
        webView?.loadRequest(requestObj);
    }
}
