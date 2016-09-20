////
////  ViewController.swift
////  Xcode7 DB Example
////
////  Created by Jose Cordova on 9/18/16.
////  Copyright © 2016 Jose Cordova. All rights reserved.
////
//
//import UIKit
//
//class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HomeModelProtocal  {
//    
//    //Properties
//    
//    var feedItems: NSArray = NSArray()
//    var selectedLocation : LocationModel = LocationModel()
//    @IBOutlet weak var listTableView: UITableView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        //set delegates and initialize homeModel
//        
//        self.listTableView.delegate = self
//        self.listTableView.dataSource = self
//        
//        let homeModel = HomeModel()
//        homeModel.delegate = self
//        homeModel.downloadItems()
//        
//        print(feedItems.count)
//        
//    }
//    
//    func itemsDownloaded(_ items: NSArray) {
//        
//        feedItems = items
//        self.listTableView.reloadData()
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // Return the number of feed items
//        return feedItems.count
//        
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // Retrieve cell
//        let cellIdentifier: String = "BasicCell"
//        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
//        // Get the location to be shown
//        let item: LocationModel = feedItems[(indexPath as NSIndexPath).row] as! LocationModel
//        // Get references to labels of cell
//        myCell.textLabel!.text = item.address
//        
//        return myCell
//    }
//    
//}
