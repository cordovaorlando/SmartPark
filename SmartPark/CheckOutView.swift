//
//  CheckOutView.swift
//  SmartPark
//
//  Created by Jose Cordova on 8/7/16.
//  Copyright © 2016 Jose Cordova. All rights reserved.
//

import UIKit

class CheckOutView: UIViewController {
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    
    var message = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 248.0/255, green: 146.0/255, blue: 35.0/255, alpha: 1.0)
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white]
        self.navigationItem.title = "#" + message
        print( "Message Print: "  + message)
        print("Testing View Did Load")
        
        restaurantName.font = UIFont.boldSystemFont(ofSize: 20.0)
        totalLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        totalAmount.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}

