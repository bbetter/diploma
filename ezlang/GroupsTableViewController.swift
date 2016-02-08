//
//  GroupsTableController.swift
//  ezlang
//
//  Created by mac on 07.02.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import Foundation
import UIKit

class GroupsTableViewController : UITableViewController{
    
    var groups: [Group] = [Group]()
    
    override func viewDidLoad() {
        NetworkManager.sharedInstance.getGroups { (data, urlResponse, error) -> Void in
            NSLog((urlResponse?.MIMEType)!)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let group: Group = groups[indexPath.row]
        let cell:GroupCell = self.tableView!.dequeueReusableCellWithIdentifier("groupCell") as! GroupCell
        
        let disprogressTap:UITapGestureRecognizer = UITapGestureRecognizer()
        disprogressTap.addTarget(self, action: "disprogressGroup")
        cell.disprogress.addGestureRecognizer(disprogressTap)
        
        let dictionaryTap:UITapGestureRecognizer = UITapGestureRecognizer()
        dictionaryTap.addTarget(self, action: "dictionaryGroup")
        cell.dictionary.addGestureRecognizer(dictionaryTap)
        
        cell.nameLabel?.text = group.headerEng
        cell.groupImageView?.downloadImageFromUrl(link: group.imageUrl, contentMode: UIViewContentMode.ScaleToFill)
        return cell;
    }
    
    func disprogressGroup(recogniser:UITapGestureRecognizer){
        NSLog("logging disprogress")
    }
    
    func openDictionary(recogniser:UITapGestureRecognizer){
        NSLog("logging dictionary")
    }
}
