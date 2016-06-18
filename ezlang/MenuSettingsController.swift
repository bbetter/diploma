//
//  SettingsController.swift
//  ezlang
//
//  Created by mac on 15.04.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import Foundation
import UIKit

class MenuSettingsController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBAction func backPressed() {
        self.dismissViewControllerAnimated(true, completion: {
          //  UserDefaultsManager.sharedInstance.saveConfig(Game.sharedInstance.config)
        })
    }
    @IBOutlet weak var tableView: UITableView!
    
    var menuItems = [(title:String,options:[String])]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        menuItems = [
            (title: "Grid size",
                options: [
                    "Normal", "Big"
                ]),
            (title: "Translation direction",
                options: [
                    "ENG->UKR", "UKR->ENG"
                ]),
            (title: "Sound",
                options: [
                    "On","Off"
                ])
        ]
    }
}

extension MenuSettingsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(UIDevice.currentDevice().userInterfaceIdiom == .Pad){
            return 300
        }
        else{
            return 150
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("setting_cell", forIndexPath: indexPath) as! SettingCell
        let tuple = menuItems[indexPath.row]
        
        cell.optionTitle = tuple.title
        
        var items = tuple.options
        
        for i in 0 ..< items.count {
            cell.titleForIndex(i,title:items[i])
        }
        
        cell.segmentedControl?.setFont("Helvetica", newFontSize: 18)
        
        cell.segmentedControl?.setBackgroundImage(UIImage(named: "menu_button"), forState: .Normal, barMetrics: .Default)
        cell.segmentedControl?.setBackgroundImage(UIImage(named: "menu_button_clicked"), forState: .Selected, barMetrics: .Default)
        
        cell.segmentedControl?.setTextColorForState(UIColor.grayColor(), state: .Selected)
        cell.segmentedControl?.setTextColorForState(UIColor.blackColor(), state: .Normal)
        cell.segmentedControl?.removeDivider()
        
        
        cell.segmentedControlSelect = {
            item in
            switch (indexPath.row) {
            case 0:
                Game.sharedInstance.config.gridSize = (item == 0) ? .Normal : .Big
                break;
            case 1:
                Game.sharedInstance.config.direction = (item == 0) ? .Forward : .Backward
                break;
            case 2:
                Game.sharedInstance.config.soundEnabled = (item == 0) ? true : false
                break;
            default:
                break
            }
        }
        
        switch indexPath.row {
        case 0:
            cell.segmentedControl?.selectedSegmentIndex = (Game.sharedInstance.config.gridSize == .Normal) ? 0 : 1
            break;
        case 1:
            cell.segmentedControl?.selectedSegmentIndex = (Game.sharedInstance.config.direction == .Forward) ? 0 : 1
            break;
        case 2:
            cell.segmentedControl?.selectedSegmentIndex = (Game.sharedInstance.config.soundEnabled == true) ? 0 : 1
            break;
        default:
            break;
        }
        return cell
    }
    
}