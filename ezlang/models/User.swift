//
// Created by mac on 01.01.16.
// Copyright (c) 2016 5wheels. All rights reserved.
//

import Foundation

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
    var points:Int?
    var rightCount:Int?
    var wrongCount:Int?

    func getMockUserLevel()->ULevel{
        return .Beginner
    }
}
