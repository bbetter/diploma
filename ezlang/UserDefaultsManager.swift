//
//  UserDefaultsManager.swift
//  ezlang
//
//  Created by mac on 06.04.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import Foundation

public class UserDefaultsManager{
    let ConfigKeyValue = "config"
    
    static var sharedInstance = UserDefaultsManager()
    
    lazy var preferences = NSUserDefaults.standardUserDefaults()
    public func getConfig()->Config?{

        if preferences.objectForKey(ConfigKeyValue) == nil {
            return nil
        } else {
            let json = preferences.stringForKey(ConfigKeyValue)
            if let data = json?.dataUsingEncoding(NSUTF8StringEncoding) {
                do {
                    var newConfig = Config()
                    
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
                    newConfig.gridSize = GridSize(rawValue: dictionary?["grid_size"] as! String)!
                    newConfig.direction = TranslationDirection(rawValue: dictionary?["direction"] as! String)!
                    newConfig.soundEnabled = dictionary?["soundEnabled"] as! Bool

                } catch let error as NSError {
                    print(error)
                }
            }
            return nil
        }
    }
    
    public func saveConfig(config:Config){
        let data = try! NSJSONSerialization.dataWithJSONObject(config,options:[])
        
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            //  Couldn't save (I've never seen this happen in real world testing)
        }
    }
}