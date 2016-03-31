//
//  UiExtensions.swift
//  ezlang
//
//  Created by mac on 13.01.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import Foundation
import UIKit

/**
*
*/
extension UIView{
    
    func animateVisibility(visible:Bool) {
        UIView.animateWithDuration(0.7,
            animations:{
                self.alpha = CGFloat(visible ? 1 : 0)
            },completion: {
                success in
                if(success){
                    self.alpha = CGFloat(visible ? 1 : 0)
                }
        })
    }
}

extension UIViewController{
    
    func getViewController(storyBoardName:String,controllerName:String,transitionStyle:UIModalTransitionStyle)->UIViewController{
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier(controllerName)
        vc.modalPresentationStyle = .FullScreen
        vc.modalTransitionStyle = transitionStyle
        return vc
    }
    
    func openController(storyBoardName:String,controllerName:String,transitionStyle:UIModalTransitionStyle){
        let vc = getViewController(storyBoardName, controllerName: controllerName, transitionStyle: transitionStyle)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func openWithCurl(controllerName:String){
        openController("Main", controllerName: controllerName,transitionStyle: .PartialCurl)
    }
    
}

extension UIImageView {
    func downloadImageFromUrl(link link:String, contentMode mode: UIViewContentMode) {
        guard
            let url = NSURL(string: link)
            else {return}
        contentMode = mode
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            guard
                let httpURLResponse = response as? NSHTTPURLResponse where httpURLResponse.statusCode == 200,
                let mimeType = response?.MIMEType where mimeType.hasPrefix("image"),
                let data = data where error == nil,
                let image = UIImage(data: data)
                else { return }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.image = image
            }
        }).resume()
    }
}

extension UITableView{
    func reloadWithFade(){
        self.alpha = 0
        UIView.animateWithDuration(0.7) { () -> Void in
            self.reloadData()
            self.alpha = 1
        }
    }
}

extension UISegmentedControl{
    func removeDivider(){
        self.setDividerImage(imageWithColor(UIColor.clearColor()), forLeftSegmentState: .Normal, rightSegmentState: .Normal, barMetrics: .Default)
    }
    
    func setTextColorForState(color:UIColor,state:UIControlState)->Void{
        let attr = NSDictionary(object: color,forKey: NSForegroundColorAttributeName)
        self.setTitleTextAttributes(attr as [NSObject : AnyObject], forState: state)
    }
    
    // create a 1x1 image with color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image
    }
}
