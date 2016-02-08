//
// Created by mac on 01.01.16.
// Copyright (c) 2016 5wheels. All rights reserved.
//

import Foundation
//TODO: remove from here
import UIKit

enum ULevel{
    case Beginner
    case PreIntermediate
    case Intermediate
    case UpperIntermediate
    case Advanced
}

class User {
    var name:String?
    var surname:String?
    var uuid:String?
    var points:Int?
    var rightCount:Int?
    var wrongCount:Int?
    var engLevel:ULevel?
    var inGameLevel:Int?
    
    init(){
    
    }
    
    static func getMockUser()->User{
        let user:User = User()
        user.name = "Mocking"
        user.surname = "Jay"
        user.points = 80
        user.rightCount = 11
        user.wrongCount = 20
        user.engLevel = ULevel.Beginner
        user.inGameLevel = 3;
        user.uuid = UIDevice.currentDevice().identifierForVendor!.UUIDString
        return user;
    }
}
