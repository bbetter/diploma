//
//  DictionaryTableViewController.swift
//  ezlang
//
//  Created by mac on 18.02.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


extension DictionaryViewController:
        UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (levels?.endIndex)!
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dictionary_cell", forIndexPath: indexPath) as! DictionaryCell
        let (word, _, translation, _) = levels![indexPath.row].parseLevel()
        cell.wordLabel?.text = translation
        cell.translationLabel?.text = word
        return cell
    }
}

class DictionaryViewController: UIViewController {

    var groupId: Int? = 1

    var levels: [Level]?

    @IBOutlet weak var tableView: UITableView!

    @IBAction func backPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion:{})
    }

    override func viewDidLoad() {
        self.tableView.dataSource = self
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "groups_bg"))
        levels = Database.sharedInstance.getLevelsByGroupId(groupId!)
        tableView.reloadData()
    }
}
    

