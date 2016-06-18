//
// Created by mac on 21.03.16.
// Copyright (c) 2016 5wheels. All rights reserved.
//

import Foundation
import UIKit

class TaskFactory {

    static let app = UIApplication.sharedApplication().delegate as! AppDelegate

    static func getNext(groupId: Int) -> Task? {
        let direction = Game.sharedInstance.config.direction
        let type = Game.sharedInstance.config.type
        //just in case
        let level:Level? = try! Database.sharedInstance.getLevel(groupId,type: type,direction: direction);
        return (level?.getTask(type,direction:direction))
    }

    static func getCount(groupId: Int) -> (all:Int,done:Int) {
        let direction = Game.sharedInstance.config.direction

        do {
            if let levels = try! Database.sharedInstance.getLevelsByGroupId(groupId){
                return (levels.count, levels.filter {
                    item in
                    if (direction == .Forward) {
                        return item.doneForward
                    } else {
                        return item.doneBackward
                    }
                }.count)
            }
            else {
                return (0, 0)
            }
        }
        catch{
            return (0,0)
        }
    }
}
