//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Nicholas Sutanto on 9/10/17.
//  Copyright © 2017 Nicholas Sutanto. All rights reserved.
//

import UIKit

class UdacityClient : NSObject {
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: Properties
    
    // shared session

    var session = URLSession.shared
    var AccountKey : String?
    var SessionID : String?
    
 
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    // Udacity Login
    func performUdacityLogin(_ email: String,
                             _ password: String,
                             completionHandlerLogin: @escaping (_ error: NSError?)
                            -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: Constants.AuthorizationURL)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
        let _ = performRequest(request: request) { (parsedResult, error) in
            
            /* Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerLogin(error)
            } else {
                /* GUARD: Is the "account" key in our result? */
                guard let accountDictionary = parsedResult?[UdacityClient.UdacityAccountKeys.Account] as? [String:AnyObject] else {
                    return
                }
          
                /* GUARD: Is the "account registered" key in our result? */
                guard let registered = accountDictionary[UdacityClient.UdacityAccountKeys.Registered] as? Bool else {
                    return
                }

                /* GUARD: Is the "account key" key in our result? */
                guard let accountKey = accountDictionary[UdacityClient.UdacityAccountKeys.Key] as? String else {
                    return
                }
                
                /* GUARD: Is the "session" key in our result? */
                guard let sessionDictionary = parsedResult?[UdacityClient.SessionKeys.Session] as? [String:AnyObject] else {
                    return
                }
                
                /* GUARD: Is the "session id" key in our result? */
                guard let sessionID = sessionDictionary[UdacityClient.SessionKeys.ID] as? String else {
                    return
                }
                
                // Check if account is registered. If it is, then it it means we can login
                if registered {
                    self.AccountKey = accountKey
                    self.SessionID = sessionID
                    
                    completionHandlerLogin(nil)

                }
                else {
                    
                    // Account is not registered
                    let errorMsg = "Account is not registered"
                    let userInfo = [NSLocalizedDescriptionKey : errorMsg]
                    completionHandlerLogin(NSError(domain: errorMsg, code: 2, userInfo: userInfo))

                }
            }
        }
    }
    
    // Udacity Logout
    func performUdacityLogout(completionHandlerLogout: @escaping (_ error: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: Constants.AuthorizationURL)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let _ = performRequest(request: request) { (parsedResult, error) in
            
            /* Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerLogout(error)
            } else {
                
                /* GUARD: Is the "session" key in our result? */
                guard let sessionDictionary = parsedResult?[UdacityClient.SessionKeys.Session] as? [String:AnyObject] else {
                    return
                }
                
                /* GUARD: Is the "session id" key in our result? */
                guard let logoutSessionID = sessionDictionary[UdacityClient.SessionKeys.ID] as? String else {
                    return
                }
                
                // Check to make sure the session ID is the same as the one when we login
                if (logoutSessionID == self.SessionID!) {
                    completionHandlerLogout(nil)
                }
                else {
                    let errorMsg = "Difference session ID"
                    let userInfo = [NSLocalizedDescriptionKey : errorMsg]
                    completionHandlerLogout(NSError(domain: errorMsg, code: 3, userInfo: userInfo))
                }
            
            }
        }
    }
    
    private func performRequest(request: NSMutableURLRequest,
                        completionHandlerRequest: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void)
                        -> URLSessionDataTask {
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerRequest(nil, NSError(domain: "performRequest", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            self.convertDataWithCompletionHandler(newData, completionHandlerConvertData: completionHandlerRequest)
        }
        
        task.resume()
                            
        return task
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerConvertData(parsedResult, nil)
    }
}
