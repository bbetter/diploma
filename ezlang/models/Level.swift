//
//  Level.swift
//  ezlang
//
//  Created by mac on 23.12.15.
//  Copyright © 2015 5wheels. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Level: Object, Mappable{
    dynamic var id = 0
    dynamic var group: Group?
    
    var groupId : Int?

    dynamic var type:String = LevelType.LookingForWord.rawValue

    dynamic var rawLevel = ""
    dynamic var difficulty = 0
    dynamic var doneForward = false
    dynamic var doneBackward = false

    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    static func mappedLevel(dict: Dictionary<String,AnyObject>){
        Mapper<Level>().map(dict)! as Level
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        difficulty <- map["difficulty"]
        groupId <- map["groupId"]
        type <- map["levelType"]
        rawLevel <- map["level"]
        difficulty <- map["difficulty"]
    }

    func getTask(levelType:LevelType,direction:TranslationDirection) -> Task {
        
        let (word, alts, translation, translationAlts) = parseLevel()
        var task:Task
        if(levelType == .LookingForWord){
            let wordTask = WordTask()
            wordTask.sourceWord = (direction == .Forward) ? word.uppercaseString : translation.uppercaseString
            wordTask.translationWord =  (direction == .Forward) ? translation.uppercaseString : word.uppercaseString
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
        task.levelId = id
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

        let s = sourceParts[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let r = resParts[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())

        var sourceAlts: [String] = [String]()
        var resAlts:[String] = [String]()

        if(sourceParts.count > 1){
            sourceAlts = sourceParts[1].split(";")
        }
        if(resParts.count > 1) {
            resAlts = resParts[1].split(";")
        }

        for(index,_) in sourceAlts.enumerate(){
            sourceAlts[index] = sourceAlts[index].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        }

        for(index,_) in resAlts.enumerate(){
            resAlts[index] = resAlts[index].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        }

        print("{word = \(s)(\(sourceAlts.joinWithSeparator(",")))-\(r)(\(resAlts.joinWithSeparator(","))}")
        return (s, sourceAlts, r, resAlts)
    }

    override var debugDescription :String {
        return "{ id=\(id);;;" +
                "difficulty=\(difficulty);;;" +
                "rawLevel=\(rawLevel);;; }"
    }

}