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
    @IBOutlet weak var mapView: MKMapView!
    var rightBarButton: UIBarButtonItem!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var geocoder: CLGeocoder? = nil
    var activityIndicator: UIActivityIndicatorView? = nil
    
    var mapString: String = ""
    var location: CLLocation?
    
    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicator?.color = UIColor.blackColor()
        activityIndicator?.center = view.center
        view.addSubview(activityIndicator!)
        
        rightBarButton = UIBarButtonItem(title: "Find", style: .Plain, target: self, action: #selector(self.rightBarButtonTapped(_:)))
        navigationItem.rightBarButtonItem = rightBarButton

        navigationItem.title = "Where are you studying?"
    }
    
    // MARK: - Actions
    
    func rightBarButtonTapped(sender: UIBarButtonItem) {
        textField.resignFirstResponder()
        
        if rightBarButton.title == "Find" {
            
            if let text = textField.text {
                
                if text.isEmpty {
                    alertForError(Errors.MapStringEmpty)
                    return
                }
                
                mapString = text
                
                configureActivityState(.Active, activityIndicator: activityIndicator!)
                
                delay(1.5) {
                    if self.geocoder == nil {
                        self.geocoder = CLGeocoder()
                    }
                    
                    self.geocoder?.geocodeAddressString(text, completionHandler: {
                        (placemarks, error) in
                        
                        guard error == nil else {
                            self.alertForError(Errors.CouldNotGeocode)
                            return
                        }
                        
                        if let placemark = placemarks?.first {
                            self.location = placemark.location
                            configureActivityState(.Inactive, activityIndicator: self.activityIndicator!)
                            self.mapView.showAnnotations([MKPlacemark(placemark: placemark)], animated: true)
                        }
                    })
                    self.rightBarButton.title = "Submit"
                    self.textField.text = ""
                    self.textField.placeholder = "Enter a link"
                    self.navigationItem.title = "Ready to submit?"
                }
            }
        } else {
            
            if let text = textField.text {
                
                if text.isEmpty {
                    alertForError(Errors.MapStringEmpty)
                    return
                }
                
                let link = text
                
                if let location = location {
                    
                    let studentInformation = StudentInformation(dictionary: [
                        ParseClient.HTTPBodyKeys.FirstName: appDelegate.firstName,
                        ParseClient.HTTPBodyKeys.LastName: appDelegate.lastName,
                        ParseClient.HTTPBodyKeys.Latitude: location.coordinate.latitude,
                        ParseClient.HTTPBodyKeys.Longitude: location.coordinate.longitude,
                        ParseClient.HTTPBodyKeys.MapString: mapString,
                        ParseClient.HTTPBodyKeys.MediaURL: link
                        ])
                    
                    ParseClient.sharedInstance().postStudentLocation(studentInformation, completion: {
                        (success, errorMessage) in
                        dispatch_async(dispatch_get_main_queue()) {
                            if success {
                                print("Success")
                                self.dismissViewControllerAnimated(true, completion: nil)
                            } else {
                                self.alertForError(errorMessage!)
                            }
                            
                        }
                    })
                }
            }
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
        dispatch_async(dispatch_get_main_queue()) {
            configureActivityState(.Inactive, activityIndicator: self.activityIndicator!)
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Delay
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

}
