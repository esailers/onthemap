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

        // Do any additional setup after loading the view.
    }

    // MARK: - Actions
    
    @IBAction func logoutTapped(sender: UIBarButtonItem) {
        
        UdacityClient.logOut() {
            success in
            success ? self.dismissViewControllerAnimated(true, completion: nil) : print("There was a logout error")
        }
    }

}
