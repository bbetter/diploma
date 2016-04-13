//
//  EasyLangAPI.swift
//  ezlang
//
//  Created by mac on 13.04.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import Foundation
import Siesta
import Alamofire

class EasyLangAPI: Service {
    var sharedInstance: EasyLangAPI = EasyLangAPI()
    init(){
        super.init(baseURL:"http://192.168.212.101.xip.io:3000")
    }
    
    var groups : Resource { resource("groups") }
    var pack : Resource { resource("pack") }
}