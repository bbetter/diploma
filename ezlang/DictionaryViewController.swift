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
        let cell = tableView.dequeueReusableCellWithIdentifier("DictionaryCell", forIndexPath: indexPath) as! DictionaryCell
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

    override func viewDidLoad() {
        self.tableView.dataSource = self
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "groups_bg"))
        UINavigationBar.appearance().hidden = false
        UINavigationBar.appearance().backgroundColor = UIColor.clearColor()
        
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        // fix margin from top
        let inset: UIEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 0)
        self.tableView.contentInset = inset;
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back_Button")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back_button")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        levels = app.database.getLevelsByGroupId(groupId!)
        tableView.reloadData()
    }
}
    

