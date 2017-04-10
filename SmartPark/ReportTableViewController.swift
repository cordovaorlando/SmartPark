//
//  ReportTableViewController.swift
//  SmartPark
//
//  Created by Jose Cordova on 2/11/17.
//  Copyright © 2017 Jose Cordova. All rights reserved.
//

import UIKit

class ReportTableViewController: UITableViewController {
    
    var locationID = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(locationID)
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 248.0/255, green: 146.0/255, blue: 35.0/255, alpha: 1.0)
        self.navigationItem.title = "Reports"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "daily" {
            let destinationVC = segue.destination as! DailyReportViewController
            destinationVC.locationID = locationID
            
        }else if segue.identifier == "detail" {
            let destinationVC = segue.destination as! DetailReportViewController
            destinationVC.locationID = locationID
            
        }else if segue.identifier == "monthly" {
            let destinationVC = segue.destination as! MonthlyReportViewController
            destinationVC.locationID = locationID
            
        }else if segue.identifier == "yearly" {
            let destinationVC = segue.destination as! YearlyReportViewController
            destinationVC.locationID = locationID
            
        }

    }
    
}
