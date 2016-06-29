//
//  Macros.swift
//  Percentally
//
//  Created by Eric Sailers on 3/14/16.
//  Copyright © 2016 Expressive Solutions. All rights reserved.
//

import UIKit

let kColorOrange = UIColor(red: 1.00, green: 0.46, blue: 0.00, alpha: 1.0)
let kColorYellowOrange = UIColor(red: 1.00, green: 0.58, blue: 0.04, alpha: 1.0)

// MARK: Errors

struct Errors {
    static let UserPassEmpty = "Username or password empty."
    static let URLEmpty = "Must enter a URL."
    static let StudentAndPlacemarkEmpty = "Student and placemark not initialized."
    static let MapStringEmpty = "Must enter a location."
    static let CouldNotGeocode = "Could not geocode the string."
    static let NoLocationFound = "No location found."
    static let PostStudentLocationFailed = "Student location could not be posted."
    static let CannotOpenURL = "Cannot open URL."
    static let CouldNotUpdateStudentLocations = "Could not update student locations."
}

// MARK: Activity State

enum ActivityState { case Inactive, Active }

// MARK: Configure activity state

func configureActivityState(state: ActivityState, activityIndicator: UIActivityIndicatorView) {
    
    switch state {
    case .Inactive:
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    case .Active:
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
    }
}