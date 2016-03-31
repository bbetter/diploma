//
//  DictionaryCell.swift
//  ezlang
//
//  Created by mac on 20.02.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class DictionaryCell :UITableViewCell{
    
    @IBOutlet weak var wordLabel: UILabel?
    @IBOutlet weak var translationLabel: UILabel?

    @IBOutlet weak var playSoundButton: UIButton!
    
    @IBAction func buttonPressed(sender: AnyObject) {
        let speechsynt: AVSpeechSynthesizer = AVSpeechSynthesizer() //initialize the synthesizer
        
        //workaround for iOS8 Bug
        
        let beforeSpeechString : String = " "
        let beforeSpeech:AVSpeechUtterance = AVSpeechUtterance(string: beforeSpeechString)
        speechsynt.speakUtterance(beforeSpeech)
        //realstring to speak
        let speechString : String = (wordLabel?.text)!
        let nextSpeech:AVSpeechUtterance = AVSpeechUtterance(string: speechString)
        nextSpeech.rate = AVSpeechUtteranceMinimumSpeechRate; // some Configs :-)
        speechsynt.speakUtterance(nextSpeech) //let me Speak
    }
    
}