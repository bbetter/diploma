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
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (groups == nil) {
            return 0
        }
        return (groups?.endIndex)!
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let group: Group = (groups?[indexPath.row])!
        if(group.levels.count == 0){
            return 0
        }
        else{
            return 140.0
        }
    }

    @IBAction func backPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: {})
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let group: Group = (groups?[indexPath.row])!
        let cell: GroupCell = self.tableView!.dequeueReusableCellWithIdentifier("Group Cell") as! GroupCell
        
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        if(app.game.config.type == .LookingForWord){
            cell.dictionary.tag = group.id
            cell.dictionary.tag = group.id
        }
        else{
            cell.dictionary.animateVisibility(false)
        }
        cell.nameLabel?.text = group.headerSource
        cell.pointsLabel?.text = String(group.doneForward) + "/" + String(group.levels.count)
        cell.groupImageView?.downloadImageFromUrl(link: group.imageUrl, contentMode: UIViewContentMode.ScaleToFill)
        cell.disprogress.tag = group.id
        cell.tag = group.id
        
        return cell;
    }

        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            var group = groups?[indexPath.row]

            if (group?.doneForward == group?.levels.count) {
                let alert = UIAlertController(title: "Congratulations!", message: "Drop the progress?", preferredStyle: UIAlertControllerStyle.Alert)
                disprogressWithAlert(group?.id, alert: alert)
            } else {
                self.performSegueWithIdentifier("goToGameSegue", sender: tableView.cellForRowAtIndexPath(indexPath))
            }
        }

    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return indexPath
    }

}

class GroupsViewController: UIViewController {

    var groups: [Group]?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        // fix margin from top
        let inset: UIEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 0)
        setBackgroundImage("groups_bg")
        tableView.contentInset = inset;
    }

    func updateGroups() {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        groups = app.database.getAllGroups(app.game.config.type)
        tableView.reloadData()
    }

    func disprogressWithAlert(groupId: Int?, alert: UIAlertController) {
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {
            action in
            let app = UIApplication.sharedApplication().delegate as! AppDelegate
            app.database.dropProgress(groupId!, direction: .Forward)
            self.updateGroups()
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
            action in
            alert.dismissViewControllerAnimated(true, completion: {})
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func disprogress(sender: UIButton) {
        let alert = UIAlertController(title: "Warning", message: "Are you sure you wanna drop the progress", preferredStyle: UIAlertControllerStyle.Alert)
        disprogressWithAlert(sender.tag, alert: alert)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.updateGroups()
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goToDictionary") {
            let controller = (segue.destinationViewController as! DictionaryViewController)
            controller.groupId = sender?.tag
        } else if (segue.identifier == "goToGameSegue") {
            let controller = (segue.destinationViewController as! GameViewController)
            controller.groupId = sender?.tag
        }
    }
}