//
//  UserProgressControl.swift
//  ezlang
//
//  Created by mac on 30.01.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import UIKit

@IBDesignable class CustomProgressView: UIView {
    
    @IBInspectable var progress: CGFloat = 0 { didSet { setNeedsDisplay() } }
    @IBInspectable var toNextLevel: CGFloat = 0 { didSet { setNeedsDisplay() } }
    
    @IBInspectable var lineColor: UIColor = UIColor.whiteColor() { didSet { setNeedsDisplay() } }
    @IBInspectable var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay() } }
    
    @IBInspectable var progressLineColor: UIColor = UIColor.orangeColor() { didSet { setNeedsDisplay() } }
    
    @IBInspectable var color : UIColor = UIColor.greenColor() { didSet { setNeedsDisplay() } }
    
    @IBInspectable var scale: CGFloat = 0.90 { didSet { setNeedsDisplay() } }
    
    @IBOutlet weak var levelLabel: UILabel?
    
    var circleCenter : CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
    var circleRadius : CGFloat {
         return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    var level : String{
        set{
            levelLabel?.text = newValue;
        }
        get{
            return (levelLabel?.text)!
        }
    }

    override func drawRect(rect: CGRect) {
        
        let circlePath = UIBezierPath(arcCenter: circleCenter, radius: circleRadius-(lineWidth/2), startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        
        color.setFill()
        circlePath.fill()

        
        let allPath = UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        allPath.lineWidth = lineWidth
        lineColor.setStroke()
        allPath.stroke()
        
        
        let progressPath = UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle: 0,endAngle: (2.0 * progress/toNextLevel * CGFloat(M_PI)), clockwise: true)
        
        progressPath.lineWidth = lineWidth
        progressLineColor.setStroke()
        progressPath.stroke()

    }
}
