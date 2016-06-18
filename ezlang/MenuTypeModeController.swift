//
//  TypeController.swift
//  ezlang
//
//  Created by mac on 15.04.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import Foundation
import UIKit

//
//  MenuModeController.swift
//  ezlang
//
//  Created by mac on 15.04.16.
//  Copyright © 2016 5wheels. All rights reserved.
//


class MenuTypeModeController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var controllerTitle: UILabel!

    @IBAction func backPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    var isType = false

    var menuItems: [(title:String, image:String, action:SimpleButtonAction)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        controllerTitle.text = isType ? "Game Type" : "Game mode"
        menuItems = !isType ? [
            (
                title: "Training",
                image: "training_mode_ic",
                action: {
                    Game.sharedInstance.config.mode = .Training
                    self.performSegueWithIdentifier("type", sender: nil)
            }),
            (
                title: "Rating",
                image: "rating_mode_ic",
                action: {
                    Game.sharedInstance.config.mode = .Rating
                    self.performSegueWithIdentifier("type", sender: nil)
            }),
]
            :
            [
                (title: "Words",
                        image: "word_level_ic",
                        action: {
                            Game.sharedInstance.config.type = .LookingForWord
                            self.performSegueWithIdentifier("groups", sender: nil)
                        }),
                (title: "Grammar",
                        image: "grammar_level_ic",
                        action: {
                            Game.sharedInstance.config.type = .GrammarExercise
                            self.performSegueWithIdentifier("groups", sender: nil)
                        }),
        ]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "type"){
           (segue.destinationViewController as! MenuTypeModeController).isType = true
        }
    }
}

extension MenuTypeModeController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(UIDevice.currentDevice().userInterfaceIdiom == .Pad){
            return 300
        }
        else{
            return 200
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("button_cell", forIndexPath: indexPath) as! ButtonCell
        let item = menuItems[indexPath.row];
        cell.cellButtonTitle = item.title
        cell.cellImageValue = UIImage(named: item.image)
        cell.buttonClickAction = item.action
        return cell;
    }
}