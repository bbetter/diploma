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
    let host: String = "http://localhost:3000/"
    let session: NSURLSession = NSURLSession.sharedSession()

    typealias Response = (data:NSData?, response:NSURLResponse?, error:NSError?)

    static let sharedInstance = Api()

    private func dataTask<T>(request: NSMutableURLRequest, method: String, handler: (success:Bool, object:T?) -> ()) {
        request.HTTPMethod = method

        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())

        session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            if let error = error {
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
                let escapedValue = value.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
                paramString += "\(escapedKey)=\(escapedValue)&"
            }

            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        }
        return request
    }
    
    func fetchPack(handler: (success: Bool, jsonResponse: [String : AnyObject]?) -> ()) {
        let request = clientURLRequest("pack",params:[
            "udid":(UIDevice.currentDevice().identifierForVendor?.UUIDString)!,
            "language":"ENG_UKR"
            ])
        post(request,handler: handler)
    }
    
    func getLevels(handler: (success: Bool, levels: [Level]?) -> ()) {
        let request = clientURLRequest("levels",params: nil)
        get(request,handler: handler)
    }
    
    func getGroups(handler: (success: Bool, groups: [Group]?) -> ()) {
        let request = clientURLRequest("groups",params:nil)
        get(request,handler: handler)
    }
}