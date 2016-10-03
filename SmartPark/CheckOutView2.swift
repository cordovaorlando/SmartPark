//
//  CheckOutView2.swift
//  SmartPark
//
//  Created by Jose Cordova on 9/5/16.
//  Copyright © 2016 Jose Cordova. All rights reserved.
//

import UIKit

class CheckOutView2: UITableViewController {
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var tipAmount: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var subtotal: UILabel!
    
    @IBOutlet weak var fee: UILabel!
    
    @IBOutlet weak var tip: UILabel!
    
    @IBOutlet weak var finalTotal: UILabel!
    
    var initialTip = 0
    
    
    
    
    var totalInt = Float()
    var subtotalInt = Float()
    var feeInt = Float()
    var tipInt = Float()
    var finalTotalInt = Float()
    
    var SERVICE_FEE:Float = 2.00
    
    
    var feedItems: NSArray = NSArray()
    var feedItems2: NSArray = NSArray()
    
    var bCodeIndex = Int()
    
    var message = String()
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initializeLabels()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    func initializeLabels(){
        
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 248.0/255, green: 146.0/255, blue: 35.0/255, alpha: 1.0)
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white]
        self.navigationItem.title = "#" + message
        
        restaurantName.text = (feedItems[bCodeIndex] as AnyObject).description
        restaurantName.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        totalLabel.text = (feedItems2[bCodeIndex] as AnyObject).description
        totalLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        subtotal.text = totalLabel.text
        fee.text = String(format: "%.2f", SERVICE_FEE)
        
      
        tip.text = String(format: "%.2f", initialTip)
        
        let variable = (feedItems2[bCodeIndex] as AnyObject).description
        finalTotalInt = (Float(variable!)! + SERVICE_FEE)
        
        finalTotal.text = String(format: "%.2f", finalTotalInt)
        
        tipAmount.text = "$\(initialTip)"
        
    }
    
    
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        
        var currentValue = Int(sender.value)
        
        tipAmount.text = "$\(currentValue)"
        tip.text = "\(currentValue).00"
        let newTotal = finalTotalInt + Float(currentValue)
        finalTotal.text = String(format: "%.2f", newTotal)
    }
    
    func totalPrice(){
        //finalTotal
    }
    
    
    
    
    

}
