//
// Created by mac on 23.12.15.
// Copyright (c) 2015 5wheels. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import ObjectMapper

class Group: Object , Mappable{
    
    dynamic var id = 0
    dynamic var key = ""
    let levels = LinkingObjects(fromType: Level.self,property: "group")
    
    dynamic var groupType = ""
    
    dynamic var headerSource = ""
    dynamic var headerTranslation = ""
    dynamic var imageUrl = ""
    dynamic var price = 0
    
    var levelCount:Int?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func mappedArrayOfGroups(array:[AnyObject]) -> [Group]?{
        return Mapper<Group>().mapArray(array)
    }
    
    static func mappedGroup(dict: Dictionary<String,AnyObject>) -> Group?{
        return Mapper<Group>().map(dict)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        key <- map["key"]
        imageUrl <- map["imageUrl"]
        groupType <- map["groupType"]
        headerSource <- map["headerSource"]
        headerTranslation <- map["headerTranslation"]
        price <- map["price"]
        levelCount <- map["levelCount"]
    }
    
    func getImageUrl() -> String{
        if(imageUrl == "local"){
            var arr = key.split("_")
            if(arr[0] == "") { return ""; }
            return (key+".png").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        else{
            return imageUrl
        }
    }

    override var debugDescription :String {
        return "{ id=\(id)\n" +
                "key=\(key)\n" +
                "imageUrl=\(imageUrl)\n" +
                "groupType=\(groupType)\n" +
                "headerSource=\(headerSource)\n" +
                "headerTranslation=\(headerTranslation)\n" +
                "price=\(price)\n" +
                "levelCount=\(levelCount)"
    }
    
    var doneForward : Int {
        return try! levels.filter{$0.doneForward == true}.count
    }
    
    var doneBackward : Int {
        return try! levels.filter{$0.doneBackward == true}.count
    }

    func levelsArray()->[Level]?{
        return levels.reverse()
    }
}
