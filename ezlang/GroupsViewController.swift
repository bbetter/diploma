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

extension GroupsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (groups == nil) {
            return 0
        }
        return (groups?.endIndex)!
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundView = nil
        cell.backgroundColor = UIColor.clearColor()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let group: Group = (groups?[indexPath.section])!
        if (!isShop() && group.levels.count == 0) {
            return 0
        } else {
            return 140.0
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let group: Group = (groups?[indexPath.section])!
        let cell: GroupCell = self.tableView!.dequeueReusableCellWithIdentifier("group_cell") as! GroupCell
        
        cell.backgroundView = nil
        cell.backgroundColor = UIColor.clearColor()
        cell.groupBackgroundImageView.layer.cornerRadius = 8.0
        cell.groupBackgroundImageView.clipsToBounds = true
        
        if (Game.sharedInstance.config.type == .LookingForWord) {
            cell.mainActionButton.tag = group.id
        } else {
            cell.mainActionButton.hidden = true
        }
        
        switch Game.sharedInstance.config.mode {
        case .Rating:
            cell.disprogress?.hidden = false
            cell.pointsLabel?.hidden = false
        case .Training:
            cell.disprogress?.hidden = true
            cell.pointsLabel?.hidden = !isShop() && true
        default:
            break;
        }
        
        cell.nameLabel?.text = group.headerSource
        if (!isShop()) {
            cell.mainActionButton.setImage(UIImage(named: "dictionary"), forState: .Normal)
            cell.pointsLabel?.text = String(group.doneForward) + "/" + String(group.levels.count)
            
            cell.disprogress.tag = group.id
            cell.tag = group.id
        } else {
            cell.pointsLabel?.text = "\(group.levelCount!)"
            cell.mainActionButton.hidden = true
            cell.disprogress.hidden = true
        }
        
        var image:String? = group.getImageUrl()
        
        cell.groupImageView?.loadImage(path: image!, contentMode: UIViewContentMode.ScaleToFill)
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let group = groups?[indexPath.row]
        
        if (isShop()) {
            EasyLangAPI.sharedInstance.groups
                .withParam("group_id", String(group?.id))
                .withParam("user_id", String(Game.sharedInstance.player.id))
                .request(.POST)
                .onSuccess {
                    data in
                    
                    if(data.jsonDict["code"] as! Int) == 501 {
                        let alert = UIAlertController(title: "Sorry!", message: "Not enough points", preferredStyle: UIAlertControllerStyle.Alert)
                        self.presentAlert(alert)
                    }
                    else{
                        let response: PackResponse? = PackResponse.mappedPackResponse(data.jsonDict)
                        if(response?.groupsToInsert == nil) {
                            Database.sharedInstance.saveToDatabase((response?.groupsToInsert)!)
                        }
                        else {
                            return
                        };
                        response?.levelsToInsert?.forEach {
                            item in
                            item.group = Database.sharedInstance.getGroupById(item.groupId!)
                            debugPrint(item.debugDescription,"\n")
                        }
                        Database.sharedInstance.saveToDatabase((response?.levelsToInsert)!)
                    }
                    
                }
                .onFailure{_ in
            }
        } else {
            
            if (group?.doneForward == group?.levels.count) {
                let alert = UIAlertController(title: "Congratulations!", message: "Drop the progress?", preferredStyle: UIAlertControllerStyle.Alert)
                disprogressWithAlert(group?.id, alert: alert)
            } else {
                self.performSegueWithIdentifier("game", sender: tableView.cellForRowAtIndexPath(indexPath))
            }
        }
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return indexPath
    }
    
}

class GroupsViewController: UIViewController {
    
    @IBOutlet weak var tabs: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var groups: [Group]?
    var shop = false
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //hide if not shop
        self.tabs.hidden = !shop
        self.updateTable()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "dictionary") {
            let controller = (segue.destinationViewController as! DictionaryViewController)
            controller.groupId = sender?.tag
        } else if (segue.identifier == "game") {
            let controller = (segue.destinationViewController as! GameViewController)
            controller.groupId = sender?.tag
        }
    }
    
    func isShop() -> Bool {
        return shop
    }
    
    
    func updateTable() {
        groups = []
        if (!isShop()) {
            groups = Database.sharedInstance.getAllGroups(Game.sharedInstance.config.type)
            tableView.reloadData()
        } else {
            EasyLangAPI.sharedInstance.groups
                .withParam("user_id", "\(Game.sharedInstance.player.id)")
                .withParam("type", shopType().rawValue)
                .request(.GET)
                .onSuccess({
                    data in
                    self.groups = Group.mappedArrayOfGroups(data.jsonArray)
                    self.tableView.reloadData()
                })
                .onFailure({
                    e in
                    print(e)
                })
        }
    }
    
    func presentAlert(alert: UIAlertController){
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
            action in
            self.updateTable()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func disprogressWithAlert(groupId: Int?, alert: UIAlertController) {
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {
            action in
            Database.sharedInstance.dropProgress(groupId!, direction: .Forward)
            self.updateTable()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
            action in
            alert.dismissViewControllerAnimated(true, completion: {})
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func shopType() -> LevelType {
        return tabs.selectedSegmentIndex == 0 ? LevelType.LookingForWord : LevelType.GrammarExercise
    }
    
    @IBAction func tabDidSelected(sender: AnyObject) {
        updateTable()
    }
    
    @IBAction func disprogress(sender: UIButton) {
        let alert = UIAlertController(title: "Warning", message: "Are you sure you wanna drop the progress", preferredStyle: UIAlertControllerStyle.Alert)
        disprogressWithAlert(sender.tag, alert: alert)
    }
    
    @IBAction func backPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
}