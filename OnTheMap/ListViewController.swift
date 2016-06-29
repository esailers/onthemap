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
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        listDataSource = ListDataSource()
        tableView.dataSource = listDataSource
        tableView.delegate = listDataSource
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    // MARK: - Reload data

    func reloadData() {
        UdacityClient.sharedInstance().getStudentLocations {
            (users, error) in
            
            guard error == nil else {
                print("There was an error")
                return
            }
            
            guard let usersData = users else {
                print("No data was returned")
                return
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.appDelegate.studentsData = usersData
                self.tableView.reloadData()
            }
        }
    }
    
}
