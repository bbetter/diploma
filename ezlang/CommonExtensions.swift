//
//  CommonExtensions.swift
//  ezlang
//
//  Created by mac on 31.12.15.
//  Copyright © 2015 5wheels. All rights reserved.
//

import Foundation

extension String {
    static let uppercaseLetters = Array(65...90).map {
        String(UnicodeScalar($0))
    }

    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
    }
    
    static func randomLetter() -> String {
        let randomIndex = arc4random_uniform(UInt32(uppercaseLetters.count))
        return uppercaseLetters[Int(randomIndex)]
    }

    func split(separator:String) -> [String]{
        return self.componentsSeparatedByString(separator)
    }
}

