//
//  SettingCell.swift
//  ezlang
//
//  Created by mac on 06.01.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import Foundation
import UIKit

typealias SettingSelectAction = (Int) -> Void

class SettingCell: UITableViewCell{
    @IBOutlet weak var segmentedControl: UISegmentedControl?
    @IBOutlet weak var label: UILabel?
    
    @IBAction func valueChanged(sender: UISegmentedControl) {
        segmentedControlSelect!(selectedIndex)
    }
    
    var segmentedControlSelect: SettingSelectAction?

    var selectedIndex: Int {
        get{ return segmentedControl!.selectedSegmentIndex }
        set{ segmentedControl!.selectedSegmentIndex = newValue }
    }
    
    var optionTitle: String{
        get{return label!.text!}
        set{label!.text = newValue}
    }
    
    var leftTitle: String{
        get{ return segmentedControl!.titleForSegmentAtIndex(0)! }
        set{ segmentedControl!.setTitle(newValue, forSegmentAtIndex: 0) }
    }
    
    var rightTitle: String{
        get{ return segmentedControl!.titleForSegmentAtIndex(1)! }
        set{ segmentedControl!.setTitle(newValue, forSegmentAtIndex: 1) }
    }
    
    
    
   
}