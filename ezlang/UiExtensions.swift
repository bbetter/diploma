//
//  UiExtensions.swift
//  ezlang
//
//  Created by mac on 13.01.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    func animateVisibility(visible:Bool){
        UIView.animateWithDuration(0.7, animations:{
            self.alpha = CGFloat(visible ? 1 : 0)
            },completion: {
                success in
                if(success){
                    self.alpha = CGFloat(visible ? 1 : 0)
                }
        })
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
    
    // create a 1x1 image with this color
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
