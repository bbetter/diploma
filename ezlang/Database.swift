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

    func getAllGroups(type:LevelType) -> [Group]? {
        let realm = try! Realm()
        let groups = realm.objects(Group.self).filter{item in return item.groupType == type.rawValue}
        return  groups
    }

    func getGroupById(groupId: Int) -> Group? {
        let realm = try! Realm()
        return try! realm.objectForPrimaryKey(Group.self, key: groupId)
    }

    func getUser(udid:String) -> User? {
        let realm = try! Realm()
        return try! realm.objectForPrimaryKey(User.self,key:udid)
    }

    func updateUserInfo(user:User){
        let realm = try! Realm()

        realm.transaction{
            realm.add(user,update: true)
        }
    }

    func getLevel(groupId: Int, type: LevelType, direction: TranslationDirection) -> Level? {
        let realm = try! Realm()
        let group = getGroupById(groupId) as Group!
        var filteredLevels = group.levels.filter {
            item in
            item.type == type.rawValue &&
                    (direction == .Forward) ? item.doneForward == false
                    : item.doneBackward == false
        };
        if (filteredLevels.count > 0) {
            return filteredLevels.random()
        } else {
            return nil
        }
    }

    func getLevelsByGroupId(groupId: Int) -> [Level]? {
        let realm = try! Realm()
        let group = realm.objectForPrimaryKey(Group.self, key: groupId)
        return group?.levels
    }

    func saveToDatabase<T where T: Object>(objects: [T]) {
        let realm = try! Realm()
        realm.transaction {
            for var object in objects {
                if (object is Level) {
                    if (realm.objectForPrimaryKey(Level.self, key: (object as! Level).id) != nil) {
                        continue
                    }
                }
                realm.add(object, update: true)
            }
        }
    }

    func setLevelDone(id: Int, direction: TranslationDirection) {
        let realm = try! Realm()
        realm.transaction {
            var level = realm.objectForPrimaryKey(Level.self, key: id)
            if (direction == .Forward) {
                level?.doneForward = true
            } else {
                level?.doneBackward = true
            }
            if (level == nil) {
                return;
            }
            realm.add(level!, update: true)
//            realm.create(Level.self, value: ["id": levelObj.id, "doneForward": levelObj.doneForward], update: true)
        }
    }
    
    func saveUser(user:User){
        let realm = try! Realm()
        realm.transaction{
            realm.add(user, update: true)
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

    func dropProgress(groupId: Int, direction: TranslationDirection) {
        let realm = try! Realm()
        var group = realm.objectForPrimaryKey(Group.self, key: groupId)
        realm.transaction {
            group?.levels.forEach {
                if (direction == .Forward) {
                    $0.doneForward = false
                } else {
                    $0.doneBackward = false
                }
                realm.add($0, update: true)
            }
        }
    }

}