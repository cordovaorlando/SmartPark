//
//  RequestsViewController.swift
//  SmartPark
//
//  Created by Jose Cordova on 1/3/17.
//  Copyright © 2017 Jose Cordova. All rights reserved.
//

import UIKit

class RequestsViewController: UIViewController{
    
    var locationID = String()
    var locationID2 = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .default
        print("Location ID is: " + locationID)
        print("Location ID2 is: " + locationID2)
        print("Hello World")
    }
}
