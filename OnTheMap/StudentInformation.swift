//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Eric Sailers on 6/29/16.
//  Copyright © 2016 Expressive Solutions. All rights reserved.
//

import MapKit

struct StudentInformation {
    var firstName = ""
    var lastName = ""
    var latitude = CLLocationDegrees()
    var longitude =  CLLocationDegrees()
    var mediaURL = ""
    var studentId = ""
    
    init(dictionary: [String: AnyObject]) {
        firstName = dictionary[UdacityClient.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[UdacityClient.JSONResponseKeys.LastName] as! String
        latitude = dictionary[UdacityClient.JSONResponseKeys.Latitude] as! CLLocationDegrees
        longitude = dictionary[UdacityClient.JSONResponseKeys.Longitude] as! CLLocationDegrees
        mediaURL = dictionary[UdacityClient.JSONResponseKeys.MediaUrl] as! String
    }
    
    static func convertFromDictionaries(array: [[String : AnyObject]]) -> [StudentInformation] {
        var resultArray = [StudentInformation]()
        
        for dictionary in array {
            resultArray.append(StudentInformation(dictionary: dictionary))
        }
        
        return resultArray
    }
    
    func fullName() -> String {
        return "\(firstName) \(lastName)"
    }
}