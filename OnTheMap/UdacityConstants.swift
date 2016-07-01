//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Eric Sailers on 6/23/16.
//  Copyright © 2016 Expressive Solutions. All rights reserved.
//

extension UdacityClient {

    // MARK: Signup
    
    struct Signup {
        static let urlForSignup = "https://www.udacity.com/account/auth#!/signup"
    }
    
    // MARK: - Request to server
    
    struct RequestToServer {
        static let udacity: String = "udacity"
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
        static let limit = ""
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
    }
    
    // MARK: JSONResponseKeys
    
    struct JSONResponseKeys {
        static let Account = "account"
        static let StudentKey = "key"
        static let Status = "status"
        static let Session = "session"
        static let SessionID = "id"
        static let Error = "error"
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
    }

}
