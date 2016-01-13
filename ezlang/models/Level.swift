//
//  Level.swift
//  ezlang
//
//  Created by mac on 23.12.15.
//  Copyright © 2015 5wheels. All rights reserved.
//

import Foundation
import RealmSwift

class Level: Object{
    dynamic var id = 0
    dynamic var group:Group?
    dynamic var levelLanguage = ""
    dynamic var levelGroup = ""
    dynamic var levelType = ""
    dynamic var level = ""
    dynamic var difficulty = 0

    required init() {
        super.init()
    }

    static func fromJson(json:[String:AnyObject])->Level{
        let levelObj = Level()
        if let id = json["mId"] as? Int{
            levelObj.id = id
        }
        if let difficulty = json["mDifficulty"] as? Int{
            levelObj.difficulty = difficulty
        }
        if let levelLanguage = json["mLevelLanguage"] as? String{
            levelObj.levelLanguage = levelLanguage
        }
        if let levelGroup = json["mLevelGroup"] as? String{
            levelObj.levelGroup = levelGroup
        }
        if let levelType = json["mLevelType"] as? String{
            levelObj.levelType = levelType
        }
        if let level = json["mLevel"] as? String{
            levelObj.level = level
        }
        return levelObj
    }
}