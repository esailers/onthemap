//
//  PostLocationViewController.swift
//  OnTheMap
//
//  Created by Eric Sailers on 6/27/16.
//  Copyright © 2016 Expressive Solutions. All rights reserved.
//

import UIKit

class PostLocationViewController: UIViewController {
    
    // MARK: - Properties
    
    var cancelBarButton: UIBarButtonItem!
    
    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        cancelBarButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(self.cancelTapped(_:)))
        navigationItem.leftBarButtonItem = cancelBarButton
        
        navigationItem.title = "Where are you studying?"
    }

    // MARK: - Dismiss view controller
    
    func cancelTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
