//
// Created by mac on 01.01.16.
// Copyright (c) 2016 5wheels. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class DatabaseHelper {

    internal static func getGroups() -> Results<Group>{
        let realm = try! Realm()
        return realm.objects(Group)
    }

//    public static func getLevelsForGroup(groupId: Int) -> Results<Group>{
//        let realm = try! Realm()
//        return realm.objects(Level).filter("groupId==\(groupId)")
//    }

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

    internal static func populateDatabaseFromFile(fileName: String) {
        do {
            let str = readFile(fileName)
            let data = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            let json = try NSJSONSerialization.JSONObjectWithData(data! , options: .AllowFragments)
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

                if let levelsToInsert = json["mLevelInsert"] as? [[String:AnyObject]]{
                    for level in levelsToInsert{
                        let levelObj = Level.fromJson(level)
                        realm.add(levelObj)
                    }
                }
                if let levelsTpDelete = json["mLevelDelete"] as? [[String:AnyObject]]{
                    //todo: handle ids of levels to delete
                }
            }
        } catch {
            print("error serializing JSON: \(error)")
        }
    }
}
