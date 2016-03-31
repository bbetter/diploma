//
//  LevelFabric.swift
//  ezlang
//
//  Created by mac on 06.03.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import Foundation

class LevelFactory{
    
    internal static var sharedInstance:LevelFactory?
    
    internal func getNextLevel()->Level{
        return Level()
    }
}