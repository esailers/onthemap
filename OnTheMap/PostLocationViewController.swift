//
//  PostLocationViewController.swift
//  OnTheMap
//
//  Created by Eric Sailers on 6/27/16.
//  Copyright © 2016 Expressive Solutions. All rights reserved.
//

import UIKit
import MapKit

class PostLocationViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Where are you studying?"
    }
    
    // MARK: - Actions
    
    @IBAction func findTapped(sender: UIButton) {
        textField.resignFirstResponder()
    }
    
    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        textField.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }

}
