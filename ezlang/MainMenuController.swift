//
//  MenuViewController.swift
//  ezlang
//
//  Created by mac on 06.01.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import Foundation
import UIKit
import Siesta


class MainMenuController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var menuItems : [(title:String,action:SimpleButtonAction)] = [];
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "shop"){
            let controller:GroupsViewController = segue.destinationViewController as! GroupsViewController
            controller.shop = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.clearColor()
    
        menuItems =  [
            (title: NSLocalizedString("new_game", comment: ""), action: { self.performSegueWithIdentifier("mode", sender: nil) }),
            (title: NSLocalizedString("profile", comment: ""), action: { self.performSegueWithIdentifier("profile", sender: nil) }),
            (title: NSLocalizedString("settings", comment: ""), action: { self.performSegueWithIdentifier("settings", sender: nil) }),
            (title: NSLocalizedString("help", comment: ""), action: { self.performSegueWithIdentifier("help", sender: nil) }),
            (title: NSLocalizedString("feedback", comment: ""), action: { self.performSegueWithIdentifier("feedback", sender: nil) }),
            (title: NSLocalizedString("rating", comment: ""), action: { self.performSegueWithIdentifier("rating", sender: nil) })
        ]
        
        if(NetworkUtils.isConnectedToNetwork()){
            menuItems.append( (title: NSLocalizedString("shop", comment: ""), action: { self.performSegueWithIdentifier("shop", sender: nil) }))
        }

        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}

extension MainMenuController: UITableViewDataSource, UITableViewDelegate {

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("button_cell", forIndexPath: indexPath) as! ButtonCell
        let item = menuItems[indexPath.row]
        cell.cellButtonTitle = item.title
        cell.buttonClickAction = item.action
        return cell;
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
}
