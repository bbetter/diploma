//
//  Level.swift
//  ezlang
//
//  Created by mac on 23.12.15.
//  Copyright © 2015 5wheels. All rights reserved.
//

import Foundation
import RealmSwift

class Level: Object {
    dynamic var id = 0
    dynamic var group: Group?

    dynamic var type:String = LevelType.LookingForWord.rawValue

    dynamic var rawLevel = ""
    dynamic var difficulty = 0
    dynamic var doneForward = false
    dynamic var doneBackward = false

    override static func primaryKey() -> String? {
        return "id"
    }

    static func fromJson(json: [String:AnyObject]) -> Level {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let levelObj = Level()
        if let id = json["mId"] as? Int {
            levelObj.id = id
        }
        if let difficulty = json["mDifficulty"] as? Int {
            levelObj.difficulty = difficulty
        }
//        if let levelLanguage = json["mLevelLanguage"] as? String {
//            levelObj.language = levelLanguage
//        }
        if let groupId = json["mGroupId"] as? Int {
            let group = app.database.getGroupById(groupId)
            levelObj.group = group
        }
//        if let levelGroup = json["mLevelGroup"] as? String {
//            levelObj.levelGroup = levelGroup
//        }
        if let levelType = json["mLevelType"] as? String {
            levelObj.type = levelType
        }
        if let level = json["mLevel"] as? String {
            levelObj.rawLevel = level
        }
        if let doneForward = json["mDoneForward"] as? Bool {
            levelObj.doneForward = doneForward
        }
        if let doneBackward = json["mDoneBackward"] as? Bool {
            levelObj.doneBackward = doneBackward
        }
        return levelObj
    }

    func getTask(levelType:LevelType,direction:TranslationDirection) -> Task {
        let (word, alts, translation, translationAlts) = parseLevel()
        var task:Task
        if(levelType == .LookingForWord){
            let wordTask = WordTask()
            wordTask.sourceWord = (direction == .Forward) ? word : translation
            wordTask.translationWord =  (direction == .Forward) ? translation : word
            wordTask.wrongSourceWords = (direction == .Forward) ? alts : translationAlts
            wordTask.wrongTranslationWords = (direction == .Forward) ? translationAlts : alts
            task = wordTask
        }
        else{
            let grammarTask = GrammarTask()
            grammarTask.question = word
            grammarTask.answer = translation
            grammarTask.wrongAnswers = translationAlts
            task = grammarTask
        }

        task.difficulty = self.difficulty
        task.group = (direction == .Forward) ? group?.headerSource : group?.headerTranslation
        return task
    }

    internal func parseLevel() -> (String,[String],String,[String]) {
        let parts = rawLevel.split("=>")
        let source:String = parts[0]
        let res:String = parts[1]

        let sourceParts:[String] = source.split(" || ")
        let resParts:[String] = res.split(" || ")

        let s = sourceParts[0]
        let r = resParts[0]

        let sourceAlts:[String] = sourceParts[1].split(";")
        let resAlts:[String] = resParts[1].split(";")

        return (s, sourceAlts, r, resAlts)
    }

}