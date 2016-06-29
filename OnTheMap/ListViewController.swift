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

    func reloadData() {
        UdacityClient.sharedInstance().getStudentLocations {
            (users, error) in
            if let usersData = users {
                dispatch_async(dispatch_get_main_queue(), {
                    self.appDelegate.studentsData = usersData
                    self.tableView.reloadData()
                })
            } else {
                if error != nil {
                    print("There's an error")
                }
            }
        }
    }
    
}
