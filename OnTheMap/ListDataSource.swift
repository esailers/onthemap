//
//  ListDataSource.swift
//  OnTheMap
//
//  Created by Eric Sailers on 6/27/16.
//  Copyright © 2016 Expressive Solutions. All rights reserved.
//

import UIKit

class ListDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    
    let CellIdentifier = "StudentLocationCell"
    let pinImageName = "pin"
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInformation.studentsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath)
        
        let fullName = StudentInformation.studentsArray[indexPath.row].fullName()
        let mediaURL = StudentInformation.studentsArray[indexPath.row].mediaURL
        
        cell.textLabel?.text = fullName
        cell.detailTextLabel?.text = mediaURL
        cell.imageView?.image = UIImage(named: pinImageName)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let mediaURL = NSURL(string: StudentInformation.studentsArray[indexPath.row].mediaURL) {
            UIApplication.sharedApplication().openURL(mediaURL)
        }
    }
    
}

