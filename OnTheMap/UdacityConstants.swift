//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Eric Sailers on 6/23/16.
//  Copyright © 2016 Expressive Solutions. All rights reserved.
//

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

extension UdacityClient {

    // MARK: Signup
    
    struct Signup {
        static let urlForSignup = "https://www.udacity.com/account/auth#!/signup"
    }
    
    // MARK: - Constants
    
    struct Constants {
        static let parseAppId: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let parseApiKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        static let UdacityBaseURL: String = "https://www.udacity.com/api/"
        static let ParseBaseURL: String = "https://api.parse.com/1/classes/StudentLocation"
    }
    
    // MARK: - Request to server
    struct RequestToServer {
        static let udacity: String = "udacity"
        static let parse: String = "parse"
    }
    
    // MARK: Components
    
    struct Components {
        static let Scheme = "https"
        static let Host = "www.udacity.com"
        static let Path = "/api"
    }
    
    // MARK: Methods
    
    struct Methods {
        static let Session = "/session"
        static let Users = "/users"
        static let limit : String = ""
    }
    
    // MARK: Cookies
    
    struct Cookies {
        static let XSRFToken = "XSRF-TOKEN"
    }
    
    // MARK: HeaderKeys
    
    struct HeaderKeys {
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
        static let XSRFToken = "X-XSRF-TOKEN"
    }
    
    // MARK: HeaderValues
    
    struct HeaderValues {
        static let JSON = "application/json"
    }
    
    // MARK: HTTPBodyKeys
    
    struct HTTPBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        
        // Parse
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    // MARK: JSONResponseKeys
    
    struct JSONResponseKeys {
        static let Account = "account"
        static let StudentKey = "key"
        static let Status = "status"
        static let Session = "session"
        static let Error = "error"
        static let Student = "student"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MediaUrl = "mediaURL"
    }

}
