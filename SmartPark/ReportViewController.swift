//
//  ReportViewController.swift
//  SmartPark
//
//  Created by Jose Cordova on 12/28/16.
//  Copyright © 2016 Jose Cordova. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var reportTypes: [String] = ["Daily", "Detail", "Monthly", "Yearly"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white]
        self.navigationItem.title = "Reports"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reports", for: indexPath)
        
        let type = reportTypes[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Georgia", size: 19.0)
        cell.textLabel?.text = type
    
        return cell
    }
    
}


