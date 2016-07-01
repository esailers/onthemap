//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Eric Sailers on 6/30/16.
//  Copyright © 2016 Expressive Solutions. All rights reserved.
//

import UIKit

class ParseClient {
    
    var firstName = ""
    var lastName = ""

    // MARK: - Start request to get student locations
    
    private func taskForGETMethod(completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let parameters: [String: AnyObject] = [
            ParameterKeys.Limit: ParameterValues.OneHundred,
            ParameterKeys.Order: ParameterValues.MostRecentlyUpdated
        ]
        let url = urlFromComponents(parameters: parameters)
        
        let request = NSMutableURLRequest(URL: url)
        request.addValue(HeaderValues.AppId, forHTTPHeaderField: HeaderKeys.AppId)
        request.addValue(HeaderValues.APIKey, forHTTPHeaderField: HeaderKeys.APIKey)
        request.addValue(HeaderValues.JSON, forHTTPHeaderField: HeaderKeys.ContentType)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, downloadError) in
            
            guard downloadError == nil else {
                return completionHandler(result: nil, error: downloadError)
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                return completionHandler(result: nil, error: downloadError)
            }
            
            guard let data = data else {
                return completionHandler(result: nil, error: downloadError)
            }
            
            self.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        
        return task
    }
    
    // MARK: - Parse JSON
    
    private func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsingError: NSError? = nil
        
        let parsedResult: AnyObject?
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch let error as NSError {
            parsingError = error
            parsedResult = nil
        }
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
    // MARK: - Get student locations
    
    func getStudentLocations(completionHandler: (result: [StudentInformation]?, error: NSError?) -> Void) {
        
        let task = self.taskForGETMethod {
            (result, error) in
            
            guard error == nil else {
                return completionHandler(result: nil, error: error)
            }
            
            guard let result = result else {
                return completionHandler(result: nil, error: error)
            }
            
            let locations = result as? [NSObject: NSObject]
            let usersResult = locations!["results"] as? [[String: AnyObject]]
            let studentsData = StudentInformation.convertFromDictionaries(usersResult!)
            completionHandler(result: studentsData, error: nil)
        }
        task.resume()
    }
    
    // MARK: - Post student location
    
    func postStudentLocation(latitude: Double, longitude: Double, mediaURL: String, mapString: String, completion: (success: Bool, errorMessage: String?) -> Void) {
        
        let url = urlFromComponents()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = HTTPMethod.POST.rawValue
        request.addValue(HeaderValues.AppId, forHTTPHeaderField: HeaderKeys.AppId)
        request.addValue(HeaderValues.APIKey, forHTTPHeaderField: HeaderKeys.APIKey)
        request.addValue(HeaderValues.JSON, forHTTPHeaderField: HeaderKeys.ContentType)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let bodyString = "{\"uniqueKey\": \"\(appDelegate.studentKey)\", \"firstName\": \"\(self.firstName)\", \"lastName\": \"\(self.lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
        request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            
            guard error == nil else {
                print("There was an error")
                return completion(success: false, errorMessage: "There was an error.")
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("There was a response other than 2XX")
                return completion(success: false, errorMessage: "There was a response other than 2XX.")
            }
            
            guard let data = data else {
                print("No data was returned by the request")
                return completion(success: false, errorMessage: "No data was returned by the request.")
            }
            
            let success = self.parseStudentData(data)
            
            completion(success: success, errorMessage: nil)
        }
        task.resume()

    }
    
    // MARK: - Parse student data
    
    private func parseStudentData(data: NSData) -> Bool {
        var success = true
        
        var studentData = [String: AnyObject]()
        do {
            studentData = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String: AnyObject]
        } catch {
            success = false
        }

        //
        
        return success
    }
    
    // MARK: - Construct URL
    
    private func urlFromComponents(withPathExtension: String? = nil, parameters: [String: AnyObject]? = nil) -> NSURL {
        
        let components = NSURLComponents()
        let objects = Objects.StudentLocation
        components.scheme = Components.Scheme
        components.host = Components.Host
        components.path = Components.Path + (withPathExtension ?? "") + objects
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
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
}
