        //
//  NetworkManager.swift
//  ezlang
//
//  Created by mac on 30.12.15.
//  Copyright © 2015 5wheels. All rights reserved.
//

import Foundation
import UIKit


class Api{
    let host: String = "http://192.168.212.101.xip.io:3000/"
    let session: NSURLSession = NSURLSession.sharedSession()

    typealias Response = (data:NSData?, response:NSURLResponse?, error:NSError?)

    static let sharedInstance = Api()

    private func dataTask<T>(request: NSMutableURLRequest, method: String, handler: (success:Bool, object:T?) -> ()) {
        request.HTTPMethod = method

        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            if let error = error {
                print(error.code)
              return;
            }
            if let data = data {
                let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                if let response = response as? NSHTTPURLResponse where 200 ... 299 ~= response.statusCode {
                    handler(success: true, object: json as! T?)
                } else {
                    handler(success: false, object: json as! T?)
                }
            }
        }.resume()
    }

    private func post<T>(request: NSMutableURLRequest, handler: (success:Bool, object:T?) -> ()) {
        dataTask(request, method: "POST", handler: handler)
    }

    private func put<T>(request: NSMutableURLRequest, handler: (success:Bool, object:T?) -> ()) {
        dataTask(request, method: "PUT", handler: handler)
    }

    private func get<T>(request: NSMutableURLRequest, handler: (success:Bool, object:T?) -> ()) {
        dataTask(request, method: "GET", handler: handler)
    }

    private func clientURLRequest(path: String, params: Dictionary<String, AnyObject>? = nil) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: host + path)!)
        if let params = params {
            var paramString = ""
            for (key, value) in params {
                let escapedKey = key.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
                let escapedValue = String(value).stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
                paramString += "\(escapedKey)=\(escapedValue)&"
            }

            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        }
        return request
    }
    
    func fetchPack(handler: (success: Bool, jsonResponse: [String : AnyObject]?) -> ()) {
        let request = clientURLRequest("api/pack",params:[
            "udid":(UIDevice.currentDevice().identifierForVendor?.UUIDString)!,
            "language":"ENG_UKR"
            ])
        post(request,handler: handler)
    }

    func fetchUser(handler:(success:Bool, [String:AnyObject]?)->()){
        let request = clientURLRequest("api/user?udid="+(UIDevice.currentDevice().identifierForVendor?.UUIDString)!,params:nil)
        get(request,handler: handler)
    }
    
    func getLevels(handler: (success: Bool, levels: [Level]?) -> ()) {
        let request = clientURLRequest("api/levels",params: nil)
        get(request,handler: handler)
    }
    
    func getGroups(handler: (success: Bool, groups: [Group]?) -> ()) {
        let request = clientURLRequest("api/groups",params:nil)
        get(request,handler: handler)
    }
    
    func updateUser(udid:String,points:Int,count:Int,handler: (success: Bool,user:User?) -> ()){
        let request = clientURLRequest("api/user",params: ["udid":udid,"points":points,"count":count])
        post(request,handler: handler)
    }
}