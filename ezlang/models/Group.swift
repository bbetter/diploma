//
// Created by mac on 23.12.15.
// Copyright (c) 2015 5wheels. All rights reserved.
//

import Foundation
import RealmSwift

enum Type{
    
}

class Group: Object {
    dynamic var id = 0
    dynamic var key = ""
    dynamic var version = 0
    dynamic var groupType = ""
    dynamic var isOnClient = false
    dynamic var headerUkr = ""
    dynamic var headerEng = ""
    dynamic var groupLanguages = ""
    dynamic var imageUrl = ""
    dynamic var price = 0

    internal static func fromJson(json: [String:AnyObject]) -> Group {
        let groupObj = Group()

        if let id = json["mId"] as? Int {
            groupObj.id = id
        }
        if let key = json["mKey"] as? String {
            groupObj.key = key
        }
        if let version = json["mVersion"] as? Int {
            groupObj.version = version
        }
        if let groupType = json["mGroupType"] as? String {
            groupObj.groupType = groupType
        }
        if let isOnClient = json["mOnClient"] as? Bool {
            groupObj.isOnClient = isOnClient
        }
        if let header1 = json["mHeaderUkr"] as? String {
            groupObj.headerUkr = header1
        }
        if let header2 = json["mHeaderEng"] as? String {
            groupObj.headerEng = header2
        }
        if let groupLanguages = json["mGroupLanguages"] as? String {
            groupObj.groupLanguages = groupLanguages
        }
        if let imageUrl = json["mImageUrl"] as? String {
            groupObj.imageUrl = imageUrl
        }
        if let price = json["mPrice"] as? Int {
            groupObj.price = price
        }
        return groupObj
    }
}
