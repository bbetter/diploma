//
// Created by mac on 21.03.16.
// Copyright (c) 2016 5wheels. All rights reserved.
//

import Foundation
import UIKit

class TaskFactory {
    static let app = UIApplication.sharedApplication().delegate as! AppDelegate
    static func getNext(groupId: Int,type:LevelType,mode:Mode) -> Task {
        let direction = app.game.config.direction
        let languages = app.game.config.languages
        var level = app.database.getLevel(groupId,type: type) as Level!
        return level.getTask(type,direction:direction)
    }
}
