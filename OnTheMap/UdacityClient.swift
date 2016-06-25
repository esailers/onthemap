//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Eric Sailers on 6/23/16.
//  Copyright © 2016 Expressive Solutions. All rights reserved.
//

import Foundation

class UdacityClient {

    // MARK: - Methods
    
    func urlForMethod(method: String?, withPathExtension: String?, parameters: [String: AnyObject]?) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Components.Scheme
        components.host = Components.Host
        components.path = Components.Path + (method ?? "") + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        if let parameters = parameters {
            for (key, value) in parameters {
                let queryItem = NSURLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.URL!
    }

    func logInWithUsername(username: String, password: String, completionHandler: (result: String?, error: NSError?) -> Void) {
        
        let body: [String: String] = [
            HTTPBodyKeys.Username: username,
            HTTPBodyKeys.Password: password
        ]
        
        UdacityClient.sharedInstance().taskForPOSTMethod(Methods.Session, jsonBody: body) { (result, error) in
            if error != nil {
                completionHandler(result: nil, error: error)
            }
            else {
                if let errorMsg = result.valueForKey(JSONResponseKeys.Error)  as? String {
                    completionHandler(result: nil, error: NSError(domain: "udacity login issue", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMsg]))
                }
                else {
                    let session = result["account"] as! NSDictionary
                    let key = session["key"] as! String
                    completionHandler(result: key, error: nil)
                }
            }
            
        }
    }
    
    
    func taskForPOSTMethod(method: String, jsonBody: [String: AnyObject], completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        print("Test")
        // Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: urlForMethod(method, withPathExtension: nil, parameters: nil))
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "\(jsonBody)".dataUsingEncoding(NSUTF8StringEncoding)
        
        /* 4. Make the request */
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            
            func sendError(error: String) {
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPOST(result: nil, error: NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            guard error == nil else {
                sendError("There was an error")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request")
                return
            }
            
            /* 5/6. Parse the data and use it */
            // Parse the result with existing method in this TMDBClient class
            let trimmedData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            self.convertDataWithCompletionHandler(trimmedData, completionHandlerForConvertData: completionHandlerForPOST)
            
        }
        /* 7. Start the request */
        task.resume()
        
        return task
        
    }
    
    // MARK: - Parse raw JSON
    
    // Given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
    
}
