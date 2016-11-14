//
//  BrowseProductsViewController.swift
//  SmartPark
//
//  Created by Jose Cordova on 10/10/16.
//  Copyright © 2016 Jose Cordova. All rights reserved.
//

import UIKit

class BrowseProductsViewController: UITableViewController {

    let settingsVC = SettingsViewController()
    
    
    
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }

    func showSettings() {
        let navController = UINavigationController(rootViewController: settingsVC)
        self.present(navController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        //let product = Array(self.productsAndPrices.keys)[(indexPath as NSIndexPath).row]
        let price = 100
        let theme = self.settingsVC.settings.theme
        cell.backgroundColor = theme.secondaryBackgroundColor
        cell.textLabel?.text = "Payment"
        cell.textLabel?.font = theme.font
        cell.textLabel?.textColor = theme.primaryForegroundColor
        //cell.detailTextLabel?.text = "$\(price/100).00"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = "Item Name"
        let price = 100
        
        
            //self.paymentContext.pushPaymentMethodsViewController()
        
        let checkoutViewController = CheckoutViewController(product: product,
                                                            price: price,
                                                            settings: self.settingsVC.settings)
        self.navigationController?.pushViewController(checkoutViewController, animated: true)
        
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

    
    @IBAction func sliderChange(_ sender: UISlider) {
        
        var currentValue = Int(sender.value)
        
        tipAmount.text = "$\(currentValue)"
        tip.text = "\(currentValue).00"
        let newTotal = finalTotalInt + Float(currentValue)
        finalTotal.text = String(format: "%.2f", newTotal)
    }
    
}
