//
// Created by mac on 21.03.16.
// Copyright (c) 2016 5wheels. All rights reserved.
//

import Foundation

class Task {

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

    override func check(answer: String, direction: TranslationDirection) -> Bool {
        if direction == .Forward {
            return translationWord == answer
        } else {
            return sourceWord == answer
        }
    }

    override func getTaskHeader(direction: TranslationDirection) -> String {
        if direction == .Forward {
            return sourceWord!
        } else {
            return translationWord!
        }
    }

    override func getWord(direction: TranslationDirection) -> String {
        if direction == .Forward {
            return translationWord!.capitalizedString[Range(start:translationWord!.startIndex.advancedBy(1),end:translationWord!.endIndex)]
        } else {
            return sourceWord!.capitalizedString[Range(start:sourceWord!.startIndex.advancedBy(1),end:sourceWord!.endIndex)]
        }
    }

    override func getAlternatives(direction: TranslationDirection) -> [String] {
        if direction == .Forward {
            return wrongTranslationWords!
        } else {
            return wrongSourceWords!
        }
    }
}


class GrammarTask: Task {
    var question: String?
    var answer: String?
    var wrongAnswers: [String]?

    override func check(answer: String, direction: TranslationDirection) -> Bool {
        return self.answer == answer.uppercaseString
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
