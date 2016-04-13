//
//  MenuViewController.swift
//  ezlang
//
//  Created by mac on 06.01.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Siesta

typealias TupleTitles = (String?, String?, String?)

enum MenuType {
    case MainMenu
    case SettingsMenu
    case TypeMenu

    func getItemsCount() -> Int {
        switch (self) {
        case .MainMenu:
            return 6
        case .SettingsMenu:
            return 3
        case .TypeMenu:
            return 2
        }
    }


    func getMenuItemsTitles() -> [TupleTitles] {
        switch (self) {
        case .MainMenu:
            return [
                    (NSLocalizedString("new_game", comment: ""), nil, nil),
                    (NSLocalizedString("profile", comment: ""), nil, nil),
                    (NSLocalizedString("settings", comment: ""), nil, nil),
                    (NSLocalizedString("help", comment: ""), nil, nil),
                    (NSLocalizedString("feedback", comment: ""), nil, nil),
                    (NSLocalizedString("rating", comment: ""), nil, nil)
            ]
        case .SettingsMenu:
            return [
                    (NSLocalizedString("field_size", comment: ""), "5x5", "6x6"),
                    (NSLocalizedString("translation_direction", comment: ""), NSLocalizedString("ukr_to_eng", comment: ""), NSLocalizedString("eng_to_ukr", comment: "")),
                    (NSLocalizedString("sound", comment: ""), NSLocalizedString("on", comment: ""), NSLocalizedString("off", comment: "")),
            ]
        case .TypeMenu:
            return [
                    (NSLocalizedString("words", comment: ""), "words_image", nil),
                    (NSLocalizedString("grammar", comment: ""), "grammar_image", nil)
            ]
        }
    }
}

class MenuViewController: UIViewController {
    lazy var app = UIApplication.sharedApplication().delegate as! AppDelegate
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var menuType: MenuType = .MainMenu

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    @IBAction func actionButtonClicked(sender: UIButton) {
        if (menuType == .SettingsMenu){
            goTo(.MainMenu)
        }
        else
        if (menuType == .TypeMenu) {
            goTo(.MainMenu)
        }
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()

    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuType.getItemsCount()
    }

    func goTo(type: MenuType) {
        menuType = type
        self.backButton.animateVisibility(menuType != .MainMenu)
        self.tableView.reloadWithFade()
    }

    func openController(name: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier(name)
//        vc.modalPresentationStyle = .FullScreen
        vc.modalTransitionStyle = .PartialCurl
        self.presentViewController(vc, animated: true, completion: nil)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let tuple = menuType.getMenuItemsTitles()[indexPath.row]

        switch (menuType) {
        case .MainMenu:
            let cell = tableView.dequeueReusableCellWithIdentifier("Button Cell", forIndexPath: indexPath) as! ButtonCell
            cell.buttonTitle = tuple.0
            switch (indexPath.row) {
            case 0:
                cell.buttonClickAction = {
                    self.goTo(.TypeMenu)
                }
                break;
            case 1:
                cell.buttonClickAction = {
                    self.openController("profileViewController")
                }
                break;
            case 2:
                cell.buttonClickAction = {
                    self.goTo(.SettingsMenu)
                }
            case 3:
                cell.buttonClickAction = {
                    self.openController("helpViewController")
                }
                break;
            case 4:
                cell.buttonClickAction = {
                    self.openController("feedbackController")
                }
                break;
            case 5:
                cell.buttonClickAction = {
                    self.openController("ratingController")
                }
                break;
            default:
                break;
            }
            return cell;
//        case .ModeMenu:
//            let cell = tableView.dequeueReusableCellWithIdentifier("Button Cell",forIndexPath: indexPath) as! ButtonCell
//            cell.buttonTitle = tuple.0
//            cell.buttonClickAction = {
//                let app = UIApplication.sharedApplication().delegate as! AppDelegate
//                app.game.config.mode = (tuple.0 == "training") ? .Training: .Rating
//                self.goTo(.TypeMenu)
//            }
//            return cell;
        case .TypeMenu:
            let cell = tableView.dequeueReusableCellWithIdentifier("Button Cell", forIndexPath: indexPath) as! ButtonCell
            cell.buttonTitle = tuple.0
            cell.buttonClickAction = {
                self.app.game.config.type = ((tuple.0 == "words") ? .LookingForWord : .GrammarExercise)
                let vc = self.getViewController("Main", controllerName: "groupsViewController", transitionStyle: .FlipHorizontal)
                self.presentViewController(vc, animated: true, completion: nil)
//                self.openController("groupsViewController")
            }
            return cell
        case .SettingsMenu:
            let cell = tableView.dequeueReusableCellWithIdentifier("Setting Cell", forIndexPath: indexPath) as! SettingCell
            let (title, left, right) = tuple

            cell.optionTitle = title!
            cell.leftTitle = left!
            cell.rightTitle = right!

            cell.segmentedControl?.setBackgroundImage(UIImage(named: "menu_button"), forState: .Normal, barMetrics: .Default)
            cell.segmentedControl?.setBackgroundImage(UIImage(named: "menu_button_clicked"), forState: .Selected, barMetrics: .Default)

            cell.segmentedControl?.setTextColorForState(UIColor.grayColor(), state: .Selected)
            cell.segmentedControl?.setTextColorForState(UIColor.blackColor(), state: .Normal)
            cell.segmentedControl?.removeDivider()
            cell.segmentedControlSelect = {
                item in
                switch (indexPath.row) {
                case 0:
                    self.app.game.config.gridSize = (item == 0) ? .Normal : .Big
                    break;
                case 1:
                    self.app.game.config.direction = (item == 0) ? .Forward : .Backward
                    break;
                case 2:
                    self.app.game.config.soundEnabled = (item == 0) ? true : false
                    break;
                default:
                    break
                }
            }
            return cell
        }
    }

}