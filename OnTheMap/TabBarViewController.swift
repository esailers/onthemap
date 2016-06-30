//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by Eric Sailers on 6/23/16.
//  Copyright © 2016 Expressive Solutions. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: - Properties
    
    
    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "On the Map"
    }

    // MARK: - Actions
    
    @IBAction func logoutTapped(sender: UIBarButtonItem) {
        UdacityClient.logOut() {
            success in
            success ? self.dismissViewControllerAnimated(true, completion: nil) : print("There was a logout error")
        }
    }
    
    @IBAction func pinTapped(sender: UIBarButtonItem) {
        if let storyboard = storyboard {
            let postLocationVC = storyboard.instantiateViewControllerWithIdentifier("PostLocationViewController")
            let navController = UINavigationController(rootViewController: postLocationVC)
            presentViewController(navController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func refreshTapped(sender: UIBarButtonItem) {
        selectedIndex == 0 ? postNotificationName("refreshMap") : postNotificationName("refreshList")
    }
    
    // MARK: - Helpers
    
    func postNotificationName(name: String) {
        NSNotificationCenter.defaultCenter().postNotificationName(name, object: nil)
    }

}
