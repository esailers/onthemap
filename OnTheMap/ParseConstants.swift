//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Eric Sailers on 6/30/16.
//  Copyright © 2016 Expressive Solutions. All rights reserved.
//

extension ParseClient {

    // MARK: - Request to server
    
    struct RequestToServer {
        static let parse: String = "parse"
    }
    
    // MARK: Components
    
    struct Components {
        static let Scheme = "https"
        static let Host = "api.parse.com"
        static let Path = "/1/classes"
    }
    
    // MARK: Methods
    
    struct Methods {
        static let Session = "/session"
        static let Users = "/users"
        static let limit = ""
    }

    // MARK: Objects
    
    struct Objects {
        static let StudentLocation = "/StudentLocation"
    }
    
    // MARK: ParameterKeys
    
    struct ParameterKeys {
        static let Limit = "limit"
        static let Order = "order"
        static let Where = "where"
        static let UniqueKey = "uniqueKey"
    }
    
    // MARK: ParameterValues
    
    struct ParameterValues {
        static let OneHundred = 100
        static let TwoHundred = 200
        static let MostRecentlyUpdated = "-updatedAt"
        static let MostRecentlyCreated = "-createdAt"
    }
    
    // MARK: HeaderKeys
    
    struct HeaderKeys {
        static let AppId = "X-Parse-Application-Id"
        static let APIKey = "X-Parse-REST-API-Key"
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
    }
    
    // MARK: HeaderValues
    
    struct HeaderValues {
        static let AppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let JSON = "application/json"
    }
    
    // MARK: BodyKeys
    
    struct HTTPBodyKeys {
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
    }
    
    // MARK: JSONResponseKeys
    
    struct JSONResponseKeys {
        static let Error = "error"
        static let Results = "results"
        static let ObjectID = "objectId"
        static let UpdatedAt = "updatedAt"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
    }

}
