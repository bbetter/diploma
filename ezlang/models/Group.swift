//
// Created by mac on 23.12.15.
// Copyright (c) 2015 5wheels. All rights reserved.
//

import Foundation
import RealmSwift

class Group: Object {
    dynamic var id = 0
    var levels: [Level] {
        return linkingObjects(Level.self, forProperty: "group")
    }
    //  dynamic var key = ""
//    dynamic var version = 0
    dynamic var groupType = ""
    //dynamic var isOnClient = false
    dynamic var headerSource = ""
    dynamic var headerTranslation = ""
    dynamic var imageUrl = ""
    dynamic var price = 0

    override static func primaryKey() -> String? {
        return "id"
    }

    internal static func fromJson(json: [String:AnyObject]) -> Group {
        let groupObj = Group()

        if let id = json["mId"] as? Int {
            groupObj.id = id
        }
        if let key = json["mKey"] as? String {
            var group = key.split("_")[1]
            groupObj.imageUrl = group + ".png"
        }
        if let groupType = json["mGroupType"] as? String {
            groupObj.groupType = groupType
        }
//        if let isOnClient = json["mOnClient"] as? Bool {
//            groupObj.isOnClient = isOnClient
//        }
        if let header1 = json["mHeaderSource"] as? String {
            groupObj.headerSource = header1
        }
        if let header2 = json["mHeaderDestination"] as? String {
            groupObj.headerTranslation = header2
        }
//        if let groupLanguages = json["mGroupLanguages"] as? String {
//            groupObj.groupLanguages = groupLanguages
//        }
        if let imageUrl = json["mImageUrl"] as? String {
            groupObj.imageUrl = imageUrl
        }
        if let price = json["mPrice"] as? Int {
            groupObj.price = price
        }
        return groupObj
    }

    var doneForward : Int {
        get{
            return levels.filter{$0.doneForward == true}.count
        }
    }

    var doneBackward : Int {
        //get{
            return levels.filter{$0.doneBackward == true}.count
        //}
    }
}
