//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Eric Sailers on 6/27/16.
//  Copyright © 2016 Expressive Solutions. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    // MARK: - Properties
    
    var listDataSource: ListDataSource?
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        listDataSource = ListDataSource()
        tableView.dataSource = listDataSource
        tableView.delegate = listDataSource
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.refreshListData(_:)), name:"refreshList", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    // MARK: - Reload data
    
    func refreshListData(notification: NSNotification) {
        print("LVC - data refreshed")
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
                self.tableView.reloadData()
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
