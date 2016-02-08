//
//  NetworkManager.swift
//  ezlang
//
//  Created by mac on 30.12.15.
//  Copyright © 2015 5wheels. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager{
    let host:String = "ezlang.herokuapp.com/api/"
    let session:NSURLSession = NSURLSession.sharedSession()
    
    enum Method:String{
        case Post = "POST"
        case Get = "GET"
    }
    
    static let sharedInstance = NetworkManager()
    
    private func prepareRequest(method:Method,path:String,params:[String:String]?)->NSMutableURLRequest{
        let request = NSMutableURLRequest()
        request.HTTPMethod = method.rawValue
        var url = path
        switch method{
            case .Post:
                if let params = params{
                    request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions())
                }
            case .Get:
                url.appendContentsOf("?")
                params?.forEach({(k,v) in
                        url.appendContentsOf(k)
                        url.appendContentsOf("=")
                        url.appendContentsOf(v)
                        url.appendContentsOf("&")
                    })
                url.removeAtIndex(url.endIndex)
        }
        request.URL = NSURL(string: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
  
    func update(params:[String:String]?=[:],resultCallback:(NSData?,NSURLResponse?,NSError?)->Void){
        let request = prepareRequest(.Get,path: "update", params: params);
        let dataTask = session.dataTaskWithRequest(request,completionHandler: resultCallback)
        dataTask.resume()
    }
    
    func getGroups(resultCallback:(NSData?,NSURLResponse?,NSError?)->Void){
        let request = prepareRequest(.Get,path:"groups", params:nil)
        
        let dataTask = session.dataTaskWithRequest(request,completionHandler: resultCallback)
        dataTask.resume()
    }
}