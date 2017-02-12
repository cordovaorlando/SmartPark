//
//  RequestsViewController.swift
//  SmartPark
//
//  Created by Jose Cordova on 1/3/17.
//  Copyright © 2017 Jose Cordova. All rights reserved.
//

import UIKit

class RequestsViewController: UIViewController, HomeModelProtocal{
    
    @IBOutlet weak var totalDaily: UILabel!
    var locationID = String()
    var locationID2 = String()
    
    var feedItems: NSArray = NSArray()
    var feedItems2: NSArray = NSArray()
    var feedItems3: NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UIApplication.shared.statusBarStyle = .default
        print("Passed Data " + locationID)
        print("Thanks Jesus!! " + locationID2)
        
        //self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 248.0/255, green: 146.0/255, blue: 35.0/255, alpha: 1.0)
        
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.downloadItems()
        
    }
    
    func itemsDownloaded(_ items: NSArray, _ items2: NSArray, _ items3: NSArray) {
        
        feedItems = items
        
        feedItems2 = items2
        
        feedItems3 = items3
        
        //print(feedItems2[0])
        
    }
    

    
    
    
    
    
    
       
    
}
