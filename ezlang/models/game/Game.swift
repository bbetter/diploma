//
// Created by mac on 20.03.16.
// Copyright (c) 2016 5wheels. All rights reserved.
//

import Foundation

enum GridSize: String {
    case Normal = "normal"
    case Big = "big"
    case iPad = "ipad"

    func getSize() -> (rows:Int, columns:Int) {
        switch (self) {
        case Normal: return (5, 5)
        case Big: return (6, 6)
        case iPad: return (7, 7)
        }
    }
}

enum Difficulty: Int {
    case Easy
    case Normal
    case Hard
    case Nightmare

    func getWrongCount() -> Int {
        switch (self) {
        case Easy: return 1
        case Normal: return 2
        case Hard: return 3
                //which means all
        case Nightmare: return -1
        }
    }
}

// from string for database

enum LevelType: String {
    case LookingForWord = "WORD"
    case GrammarExercise = "GRAMMAR"
}

enum Mode: String {
    case Training = "Training"
    case Rating = "Rating"
    //for future
    case TimeMode
}

enum TranslationDirection: String {
    case Forward = "forward"
    case Backward = "backward"
}

public class Config {
    public static let AppConfigFileName = "appconfig.json"

    var direction: TranslationDirection = .Forward
    var difficulty: Difficulty = .Easy
    var gridSize: GridSize = .Normal
    var mode: Mode = .Rating
    var type: LevelType = .LookingForWord
    var animationEnabled: Bool = true
    var soundEnabled = true
    var languages: String = "UKR_ENG"

}

public class GameDefaults {
    public static let DictionaryOverrideSoundSettings = true
    public static let TipsOverrideSoundSettings = true

    public static let GroupImageStoragePath = "assets/groups/"
    public static let DefaultLanguages = "UKR_ENG"

    public static let DatabaseUpdateFile = "FirstUpdate.json"
    public static let DatabaseName = "ELDatabase"
    public static let CurrentDatabaseVersion = 1

    public static let SuccessBonusCoefs: [Int] = [1, 2, 3, 5]
    public static let SuccessBonusLevel: [Int] = [3, 5, 7, 10]

    public static let StartTipsCount = 3
    public static let Points2TipsExchangeCourse = 300

    public static let EnglishUpperCaseLetters: [Character] =
    ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    public static let UkrainianUpperCaseCaseLetters: [Character] =
    ["А", "Б", "В", "Г", "Ґ", "Д", "Е", "Є", "Ж", "З", "И", "І", "Ї", "Й", "К", "Л", "М", "Н", "О", "П", "Р", "С", "Т", "У", "Ф", "Ч", "Ц", "Ч", "Ш", "Щ", "Ь", "Ю", "Я"]

}

public class Game {
    var config: Config = Config()
    var player: User = User()
}
