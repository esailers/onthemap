//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Eric Sailers on 6/29/16.
//  Copyright © 2016 Expressive Solutions. All rights reserved.
//

import MapKit

struct StudentInformation {
    
    // MARK: - Properties
    
    var firstName = ""
    var lastName = ""
    var latitude = CLLocationDegrees()
    var longitude =  CLLocationDegrees()
    var mapString = ""
    var mediaURL = ""
    
    static var studentsArray = [StudentInformation]()
    
    // MARK: - Initializer
    
    init(dictionary: [String: AnyObject]) {
        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as! String
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as! CLLocationDegrees
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as! CLLocationDegrees
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as! String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as! String
    }
    
    // MARK: - Methods
    
    static func convertFromDictionaries(array: [[String: AnyObject]]) -> [StudentInformation] {
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