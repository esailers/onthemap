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
                    self.alertForError("Please input a location.")
                    return
                }
                
                if let placemark = placemarks?.first {
                    self.mapView.showAnnotations([MKPlacemark(placemark: placemark)], animated: true)
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
    
    // MARK: - Alert
    
    private func alertForError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
