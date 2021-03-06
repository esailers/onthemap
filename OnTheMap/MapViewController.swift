//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Eric Sailers on 6/27/16.
//  Copyright © 2016 Expressive Solutions. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    
    let pinIdentifier = "pinIdentifier"
    
    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.refreshMapData(_:)), name:"refreshMap", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    // MARK: - Reload data
    
    func refreshMapData(notification: NSNotification) {
        print("MVC - data refreshed")
        reloadData()
    }
    
    func reloadData() {
        ParseClient.sharedInstance().getStudentLocations {
            (users, error) in
            
            guard error == nil else {
                self.alertForError("There was an error.")
                return
            }
            
            guard let usersData = users else {
                self.alertForError("No data was returned.")
                return
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                StudentInformation.studentsArray = usersData
                self.createAnnotations(usersData, mapView: self.mapView)
            }
        }
    }
    
    // MARK: - Set pin locations
    
    func createAnnotations(users: [StudentInformation], mapView: MKMapView) {
        for user in users {
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = CLLocationCoordinate2DMake(user.latitude, user.longitude)
            annotation.title = user.fullName()
            annotation.subtitle = user.mediaURL
            
            mapView.addAnnotation(annotation)
        }
    }

    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(pinIdentifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdentifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {

            if let urlToOpen = view.annotation?.subtitle, urlForAnnotation = NSURL(string: urlToOpen!) {
                UIApplication.sharedApplication().openURL(urlForAnnotation)
            } else {
                alertForError(Errors.CannotOpenURL)
            }
        }
    }
 
    // MARK: - Alert
    
    private func alertForError(message: String) {
        dispatch_async(dispatch_get_main_queue()) {
            let alertController = UIAlertController(title: "", message: message, preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

}
