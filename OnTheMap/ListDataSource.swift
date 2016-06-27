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
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = "Student"
        cell.detailTextLabel?.text = "url"
        cell.imageView?.image = UIImage(named: pinImageName)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        print("Row \(indexPath.row) selected")
        if let urlForSignup = NSURL(string: UdacityClient.Signup.urlForSignup) {
            UIApplication.sharedApplication().openURL(urlForSignup)
        }
    }
    
}

