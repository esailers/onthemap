//
//  PostLocationViewController.swift
//  OnTheMap
//
//  Created by Eric Sailers on 6/27/16.
//  Copyright © 2016 Expressive Solutions. All rights reserved.
//

import UIKit
import MapKit

class PostLocationViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var mapView: MKMapView!
    
    var geocoder: CLGeocoder? = nil
    
    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self

        navigationItem.title = "Where are you studying?"
    }
    
    // MARK: - Actions
    
    @IBAction func findTapped(sender: UIButton) {
        textField.resignFirstResponder()
        
        if geocoder == nil {
            geocoder = CLGeocoder()
        }
        
        if let text = textField.text {
            geocoder?.geocodeAddressString(text, completionHandler: {
                (placemarks, error) in
                
                guard error == nil else {
                    print("There was an error")
                    return
                }
                
                let placemark = placemarks?.first
                let latitude = placemark?.location?.coordinate.latitude
                let longitude = placemark?.location?.coordinate.longitude
                if let latitude = latitude, longitude = longitude {
                    let locationString = "\(latitude), \(longitude)"
                    print(locationString)
                }
            })
        }
    }
    
    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        textField.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
