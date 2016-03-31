//
//  GroupsTableController.swift
//  ezlang
//
//  Created by mac on 07.02.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

extension GroupsViewController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(groups == nil){
            return 0
        }
        return (groups?.endIndex)!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let group: Group = (groups?[indexPath.row])!
        let cell:GroupCell = self.tableView!.dequeueReusableCellWithIdentifier("Group Cell") as! GroupCell
        
        cell.nameLabel?.text = group.headerSource
        cell.groupImageView?.downloadImageFromUrl(link: group.imageUrl, contentMode: UIViewContentMode.ScaleToFill)
        
        cell.tag = group.id
        cell.dictionary.tag = group.id
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("goToGameSegue", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return indexPath
    }

}

class GroupsViewController : UIViewController{
    
    var groups: [Group]?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        // fix margin from top
        let inset: UIEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 0)
        tableView.contentInset = inset;
        tableView.backgroundView = UIImageView(image: UIImage(named: "groups_bg"))
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
//        UINavigationBar.appearance().hidden = false
//        UINavigationBar.appearance().backgroundColor = UIColor.clearColor()
        groups = app.database.getAllGroups()
        tableView.reloadData()
    }

    
    @IBAction func disprogress(sender: AnyObject) {
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goToDictionary") {
            let controller = (segue.destinationViewController as! DictionaryViewController)
            controller.groupId = sender?.tag
        }
        else if(segue.identifier == "goToGameSegue"){
            let controller = (segue.destinationViewController as! GameViewController)
            controller.groupId = sender?.tag

        }
    }
}