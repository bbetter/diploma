//
//  Database.swift
//  ezlang
//
//  Created by mac on 22.02.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import Foundation
import RealmSwift

extension Array {
    func random() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

extension Realm {
    func transaction(block: () -> Void) {
        self.beginWrite()
        block()
        try! self.commitWrite()
    }
}

class Database {
    static let sharedInstance = Database()

    func getAllGroups()->[Group]?{
        let realm = try! Realm()
        let groups = realm.objects(Group.self)
        return groups.toArray()
    }

    func getGroupById(groupId:Int)-> Group?{
        let realm = try! Realm()
        return try! realm.objectForPrimaryKey(Group.self, key: groupId)
    }

    func getLevel(groupId: Int, type: LevelType) -> Level? {
        let realm = try! Realm()
        let group = getGroupById(groupId) as Group!
        var level = Level()
        return group.levels.filter {
            item in
            item.type == type.rawValue
        }.random()
    }

    func getLevelsByGroupId(groupId: Int)->[Level]? {
        let realm = try! Realm()
        let group = realm.objectForPrimaryKey(Group.self, key: groupId)
        return group?.levels
    }

    func saveToDatabase<T where T: Object>(objects: [T]) {
        let realm = try! Realm()
        realm.transaction {
            for var object in objects {
                realm.add(object, update: true)
            }
        }
    }

    private static func readFile(fileName: String) -> String {
        if let dir: NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.stringByAppendingPathComponent(fileName);

            //reading
            do {
                let text2 = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
                return text2 as String
            } catch {
                /* error handling here */
                return ""
            }
        }
        return ""
    }

    public static func readDbFromFile(fileName: String) {
        do {
            let str = readFile(fileName)
            let data = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            let realm = try! Realm()

            try! realm.write {
                if let groupsToInsert = json["mGroupInsert"] as? [[String:AnyObject]] {
                    for group in groupsToInsert {
                        let groupObj = Group.fromJson(group)
                        realm.add(groupObj)
                    }
                }

                if let groupsToDelete = json["mGroupDelete"] as? [[String:AnyObject]] {
                    //todo: handle ids of groups to delete
                }

                if let groupsToUpdate = json["mGroupUpdate"] as? [[String:AnyObject]] {
                    //todo: handle ids of groups to update
                }

                if let levelsToInsert = json["mLevelInsert"] as? [[String:AnyObject]] {
                    for level in levelsToInsert {
                        let levelObj = Level.fromJson(level)
                        realm.add(levelObj)
                    }
                }
                if let levelsTpDelete = json["mLevelDelete"] as? [[String:AnyObject]] {
                    //todo: handle ids of levels to delete
                }
            }
        } catch {
            print("error serializing JSON: \(error)")
        }
    }

}