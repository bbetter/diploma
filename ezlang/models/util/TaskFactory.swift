//
// Created by mac on 21.03.16.
// Copyright (c) 2016 5wheels. All rights reserved.
//

import Foundation
import UIKit

class TaskFactory {

    static let app = UIApplication.sharedApplication().delegate as! AppDelegate
    static func getNext(groupId: Int,type:LevelType,mode:Mode) -> Task? {
        let direction = app.game.config.direction
        let level:Level? = app.database.getLevel(groupId,type: type,direction: app.game.config.direction);
        return (level?.getTask(type,direction:direction))
    }
}
