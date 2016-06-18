//
//  CommonExtensions.swift
//  ezlang
//
//  Created by mac on 31.12.15.
//  Copyright © 2015 5wheels. All rights reserved.
//

import Foundation
import AVFoundation

extension Int{

    static func rand(min:UInt32,max:UInt32) -> Int{
        return Int(arc4random_uniform(min+max) + min);
    }
}

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
        return substringWithRange(startIndex.advancedBy(r.startIndex)..<startIndex.advancedBy(r.endIndex))
    }
    
    static func randomLetter() -> String {
        let randomIndex = arc4random_uniform(UInt32(uppercaseLetters.count))
        return uppercaseLetters[Int(randomIndex)]
    }

    func split(separator:String) -> [String]{
        return self.componentsSeparatedByString(separator)
    }

    func removeHalfOfTheLetters() -> String{
        return ""
    }
}

extension Array {
    func splitBy(subSize: Int) -> [[Element]] {
        return 0.stride(to: self.count, by: subSize).map { startIndex in
            let endIndex = startIndex.advancedBy(subSize, limit: self.count)
            return Array(self[startIndex ..< endIndex])
        }
    }
}


extension AVSpeechSynthesizer {
    static func wordToSound(str:String?){
        let speechsynt: AVSpeechSynthesizer = AVSpeechSynthesizer() //initialize the synthesizer

        //workaround for iOS8 Bug

        let beforeSpeechString : String = " "
        let beforeSpeech:AVSpeechUtterance = AVSpeechUtterance(string: beforeSpeechString)
        speechsynt.speakUtterance(beforeSpeech)
        //realstring to speak
        let nextSpeech:AVSpeechUtterance = AVSpeechUtterance(string: str!)
        nextSpeech.rate = AVSpeechUtteranceMinimumSpeechRate; // some Configs :-)
        speechsynt.speakUtterance(nextSpeech) //let me Speak
    }
}
