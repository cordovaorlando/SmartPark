//
//  DetailViewController.swift
//  SmartPark
//
//  Created by Jose Cordova on 3/23/17.
//  Copyright © 2017 Jose Cordova. All rights reserved.
//
//
//  AccountSettingsViewController.swift
//  SmartPark
//
//  Created by Jose Cordova on 1/3/17.
//  Copyright © 2017 Jose Cordova. All rights reserved.
//

import UIKit



class DetailViewController: UIViewController{
    
    var firstName = String()
    var lastName = String()
    var phoneNumber = String()
    var licensePlate = String()
    var make = String()
    var model = String()
    var color = String()
    var price = String()
    var tip = String()
    var ticketNumber = String()
    var token = String()
    
    
    
    @IBOutlet weak var ticketNumberLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var platesLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 248.0/255, green: 146.0/255, blue: 35.0/255, alpha: 1.0)
        
        
        ticketNumberLabel.text = ticketNumber
        priceLabel.text = "$" + price
        tipLabel.text = "$" + tip
        makeLabel.text = make
        modelLabel.text = model
        colorLabel.text = color
        platesLabel.text = licensePlate
        nameLabel.text = firstName + " " + lastName
        phoneLabel.text = phoneNumber
        print(token)
        
        
        
        
        
    }
    

    
}
