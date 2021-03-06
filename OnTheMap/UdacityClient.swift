//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Eric Sailers on 6/23/16.
//  Copyright © 2016 Expressive Solutions. All rights reserved.
//

import UIKit

class UdacityClient {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    // MARK: - Login
    
    class func logIn(username: String, password: String, completion: (success: Bool, errorMessage: String?) -> Void) {
        
        let url = sharedInstance().urlForMethod(Methods.Session)
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = HTTPMethod.POST.rawValue
        request.addValue(HeaderValues.JSON, forHTTPHeaderField: HeaderKeys.Accept)
        request.addValue(HeaderValues.JSON, forHTTPHeaderField: HeaderKeys.ContentType)
        let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            
            guard error == nil else {
                print("There was an error")
                return completion(success: false, errorMessage: "Cannot connect. Please check your Internet connection.")
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("There was a response other than 2XX")
                return completion(success: false, errorMessage: "The email or password was not valid.")
            }
            
            guard let data = data else {
                print("No data was returned by the request")
                return
            }
            
            let trimmedData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            let success = sharedInstance().parseStudentData(trimmedData)
            
            completion(success: success, errorMessage: nil)
        }
        task.resume()
    }
    
    // MARK: - Logout
    
    class func logOut(completion: (success: Bool) -> Void) {
        
        let url = sharedInstance().urlForMethod(Methods.Session)
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = HTTPMethod.DELETE.rawValue
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! as [NSHTTPCookie] {
            if cookie.name == Cookies.XSRFToken { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value, forHTTPHeaderField: HeaderKeys.XSRFToken)
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            
            guard error == nil else {
                print("There was an error")
                completion(success: false)
                return
            }
            
            guard let data = data else {
                print("No data was returned by the request")
                return
            }
            
            data.subdataWithRange(NSMakeRange(5, data.length - 5))
            completion(success: true)
        }
        task.resume()
    }
    
    // MARK: - Parse JSON
    
    private func parseStudentData(data: NSData) -> Bool {
        var success = true
        
        var studentData = [String: AnyObject]()
        do {
            studentData = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String: AnyObject]
        } catch {
            success = false
        }
        
        let account = studentData[JSONResponseKeys.Account] as! [String: AnyObject]
        let session = studentData[JSONResponseKeys.Session] as! [String: AnyObject]
        
        appDelegate.key = account[JSONResponseKeys.Key] as! String
        appDelegate.sessionID = session[JSONResponseKeys.SessionID] as! String
        getStudentData(appDelegate.key) { (success, errorMessage) in
            print("firstName: \(self.appDelegate.firstName), lastName: \(self.appDelegate.lastName)")
        }
        
        return success
    }
    
    // MARK: - Get student data
    
    private func getStudentData(key: String, completion: (success: Bool, errorMessage: String?) -> Void) {
        
        let url = urlForMethod(Methods.Users, withPathExtension: "/\(key)")
        let request = NSMutableURLRequest(URL: url)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            
            guard error == nil else {
                print("There was an error")
                return completion(success: false, errorMessage: "There was an error.")
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("There was a response other than 2XX")
                return completion(success: false, errorMessage: "There was a response other than 2XX")
            }
            
            guard let data = data else {
                print("No data was returned by the request")
                return
            }

            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            var studentData = [String: AnyObject]()
            do {
                studentData = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as! [String: AnyObject]
            } catch {
                completion(success: false, errorMessage: "Error")
            }
            
            let user = studentData[JSONResponseKeys.User] as! [String: AnyObject]
            let firstName = user[JSONResponseKeys.FirstName] as! String
            let lastName = user[JSONResponseKeys.LastName] as! String
        
            self.appDelegate.firstName = firstName
            self.appDelegate.lastName = lastName
            completion(success: true, errorMessage: "Error message goes here.")
 
        }
        task.resume()
    }

    // MARK: - Construct URL
    
    private func urlForMethod(method: String?, withPathExtension: String? = nil, parameters: [String: AnyObject]? = nil) -> NSURL {
        
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
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
    
}
