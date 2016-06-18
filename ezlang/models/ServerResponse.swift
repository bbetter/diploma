//
//  ServerResponse.swift
//  ezlang
//
//  Created by mac on 22.05.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import Foundation
import ObjectMapper

struct PackResponse : Mappable {
    
    var code: Int?
    var userId : Int?
    var groupsToDelete : [Int]?
    var groupsToUpdate : [Group]?
    var groupsToInsert : [Group]?
    var levelsToInsert : [Level]?
    
    init?(_ map: Map) {
        
    }
    
    static func mappedPackResponse(dict: Dictionary<String,AnyObject>) -> PackResponse{
        return Mapper<PackResponse>().map(dict)! as PackResponse
    }
    
    mutating func mapping(map: Map) {
        userId <- map["userId"]
        groupsToDelete <- map["groupsToDelete"]
        groupsToUpdate <- map["groupsToUpdate"]
        groupsToInsert <- map["groupsToInsert"]
        levelsToInsert <- map["levelsToInsert"]
        
    }
}