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
        if(Game.sharedInstance.config.soundEnabled){
            AVSpeechSynthesizer.wordToSound(wordLabel!.text)
        }
    }
    
}