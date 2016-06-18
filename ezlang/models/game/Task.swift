//
// Created by mac on 21.03.16.
// Copyright (c) 2016 5wheels. All rights reserved.
//

import Foundation

class Task {
    var levelId:Int?
    var difficulty: Int?
    var group: String?
    var doneCount: Int?
    var doneAllCount: Int?
    var doneModeCount: Int?

    var specifySource: String?;
    var specifyTranslationf: String?;

    func check(answer: String, direction: TranslationDirection) -> Bool {
        return false;
    }

    func getWord(direction: TranslationDirection) -> String {
        return ""
    }

    func getTaskHeader(direction: TranslationDirection) -> String {
        return ""
    }

    func getAlternatives(direction: TranslationDirection) -> [String] {
        return [String](arrayLiteral:"")
    }

}


class WordTask: Task {
    var sourceWord: String?;
    var translationWord: String?;
    var wrongSourceWords: [String]? = [String]()
    var wrongTranslationWords: [String]? = [String]()

    override func check(answer: String?, direction: TranslationDirection) -> Bool {
            if(translationWord == nil || answer == nil) {return false}
            return translationWord?.lowercaseString == answer?.lowercaseString
    }

    override func getTaskHeader(direction: TranslationDirection) -> String {
        return (sourceWord?.uppercaseString)!
    }

    override func getWord(direction: TranslationDirection) -> String {
       return (translationWord?.uppercaseString)!
    }

    override func getAlternatives(direction: TranslationDirection) -> [String] {
        return wrongTranslationWords!
    }
}


class GrammarTask: Task {
    var question: String?
    var answer: String?
    var wrongAnswers: [String]?

    override func check(answer: String, direction: TranslationDirection) -> Bool {
        return self.answer?.lowercaseString == answer.lowercaseString
    }

    override func getTaskHeader(direction: TranslationDirection) -> String {
        if direction == .Forward {
            return question!
        } else {
            return answer!
        };
    }


    override func getWord(direction: TranslationDirection) -> String {
        if direction == .Forward {
            return answer!
        } else {
            return question!
        };
    }

    override func getAlternatives(direction: TranslationDirection) -> [String] {
        return wrongAnswers!
    }
}
