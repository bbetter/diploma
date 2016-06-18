    //
//  AppDelegate.swift
//  ezlang
//
//  Created by Andriy Puhach on 11/19/15.
//  Copyright © 2015 5wheels. All rights reserved.
//

import UIKit
import RealmSwift
import Siesta


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject:AnyObject]?) -> Bool {
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 2,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: {
                migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        Realm.Configuration.defaultConfiguration = config
        
        if(NetworkUtils.isConnectedToNetwork()){
            //fetching pack
            let params = ["udid": Game.sharedInstance.player.uuid!, "language": "ENG_UKR"]
            EasyLangAPI.sharedInstance.pack
                .request(.POST, json: NSDictionary(dictionary: params))
                .onSuccess() {
                    data in
                    let response: PackResponse? = PackResponse.mappedPackResponse(data.jsonDict)
                    Game.sharedInstance.player.id = response?.userId
                    Database.sharedInstance.saveToDatabase((response?.groupsToInsert)!)
                    response?.levelsToInsert?.forEach{
                        item in
                        item.group = Database.sharedInstance.getGroupById(item.groupId!)
                        debugPrint(item.debugDescription,"\n")
                    }
                    Database.sharedInstance.saveToDatabase((response?.levelsToInsert)!)
                }
                .onFailure() {
                    error in return;
            }
        }
        else{
            let path = NSBundle.mainBundle().pathForResource("data/first_update", ofType: "json")
            let jsonData = try! NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe)
            let jsonResult: NSDictionary =  try! (NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary)!
            let response: PackResponse? = PackResponse.mappedPackResponse(jsonResult as! Dictionary<String, AnyObject>)

                Database.sharedInstance.saveToDatabase((response?.groupsToInsert)!)

                response?.levelsToInsert?.forEach{
                    item in
                    item.group = Database.sharedInstance.getGroupById(item.groupId!)
                    debugPrint(item.debugDescription,"\n")
                }
                Database.sharedInstance.saveToDatabase((response?.levelsToInsert)!)
                debugPrint(response?.groupsToInsert)
                debugPrint(response?.levelsToInsert)
            }
            return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        UserDefaultsManager.sharedInstance.saveConfig(Game.sharedInstance.config)
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        if let config = UserDefaultsManager.sharedInstance.getConfig() {
            Game.sharedInstance.config = config
        }
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

