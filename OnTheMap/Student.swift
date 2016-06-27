//
//  Student.swift
//  OnTheMap
//
//  Created by Eric Sailers on 6/23/16.
//  Copyright © 2016 Expressive Solutions. All rights reserved.
//

struct Student {
    
    // MARK: - Properties
    
    var firstName: String = ""
    var lastName: String = ""
    var mediaURL: String = ""

    // MARK: - Methods
    
    func fullName() -> String {
        return firstName + " " + lastName
    }
    
}
