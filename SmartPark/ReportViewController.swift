//
//  ReportViewController.swift
//  SmartPark
//
//  Created by Jose Cordova on 12/28/16.
//  Copyright © 2016 Jose Cordova. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,HomeModelProtocal {
    
    var reportTypes: [String] = ["Daily", "Detail", "Monthly", "Yearly"]
    
    var locationID = String()
    var locationID2 = String()
    
    var feedItems: NSArray = NSArray()
    var feedItems2: NSArray = NSArray()
    var feedItems3: NSArray = NSArray()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("Passed Data " + locationID)
        print("Thanks Jesus!! " + locationID2)
        //self.navigationController!.navigationBar.tintColor = UIColor.white
        //self.navigationController!.navigationBar.titleTextAttributes =
          //  [NSForegroundColorAttributeName: UIColor.white]
        //self.navigationItem.title = "Reports"
        //UIApplication.shared.statusBarStyle = .default
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 248.0/255, green: 146.0/255, blue: 35.0/255, alpha: 1.0)
        
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.downloadItems()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "daily", for: indexPath)
        
        let type = reportTypes[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Georgia", size: 19.0)
        cell.textLabel?.text = type
    
        return cell
    }
    
    func itemsDownloaded(_ items: NSArray, _ items2: NSArray, _ items3: NSArray) {
        
        feedItems = items
        
        feedItems2 = items2
        
        feedItems3 = items3
        
        //print(feedItems2[0])
        
    }

    
}


