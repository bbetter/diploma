//
//  EasyLangAPI.swift
//  ezlang
//
//  Created by mac on 13.04.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import Foundation
import Siesta
import ObjectMapper

class EasyLangAPI: Service {
    static var sharedInstance: EasyLangAPI = EasyLangAPI()
    #if SERVER
    let baseUrl = "http://ezlang.herokuapp.com/"
    #else
    let baseUrl = "http://b12dc0e3.ngrok.io/"
    #endif
    
    init() {
        super.init(baseURL: baseUrl)
        Siesta.enabledLogCategories = LogCategory.detailed
        
    }
    
    var groups: Resource {
        return resource("api/groups")
    }
    
    var pack: Resource {
        return resource("api/pack")
    }
    
    var me: Resource {
        return resource("api/me")
    }
    
    var levels: Resource {
        return resource("api/levels")
    }
}