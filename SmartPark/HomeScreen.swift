//
//  HomeScreen.swift
//  SmartPark
//
//  Created by Jose Cordova on 8/6/16.
//  Copyright © 2016 Jose Cordova. All rights reserved.
//

import UIKit

class HomeScreen: UIViewController, UITextFieldDelegate, HomeModelProtocal {
    
    @IBOutlet weak var ticketCodeField: UITextField!
    
    let settingsVC = SettingsViewController()
    
    var seguePerformed = false
    var feedItems: NSArray = NSArray()
    var feedItems2: NSArray = NSArray()
    var feedItems3: NSArray = NSArray()
    var textFieldText = String()
    
    var finalTotalInt = Float()
    var SERVICE_FEE:Float = 2.00
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        dismissKeyboard()
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.downloadItems()
        
        seguePerformed = false
        
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 248.0/255, green: 146.0/255, blue: 35.0/255, alpha: 1.0)
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white]
        self.navigationItem.title = "Request Vehicle"
        
        self.ticketCodeField.delegate = self;
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeScreen.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        ticketCodeField.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dismissKeyboard()
        seguePerformed = false
        ticketCodeField.text = nil
        
    }
    
    
    func itemsDownloaded(_ items: NSArray, _ items2: NSArray, _ items3: NSArray) {
        
        feedItems = items
        //print(feedItems)
        
        feedItems2 = items2
        //print(feedItems2)
        
        feedItems3 = items3
        //print(feedItems3)
    }
    
    
    @IBAction func ContinueButton(_ sender: AnyObject) {
        
        textFieldText = ticketCodeField.text!
        
        if feedItems3.contains(textFieldText) {
            let index = feedItems3.index(of: textFieldText)
            //print("Found ticket Number at index:  \(index)")
            //print("We've got apples!")
            
            if !self.seguePerformed {
                
                
                let variable = (feedItems2[index] as AnyObject).description
                finalTotalInt = (Float(variable!)! + SERVICE_FEE)

                
                let checkoutViewController = CheckoutViewController(product: "Product Name",
                                                                    price: Int(finalTotalInt)*100,
                                                                    settings: self.settingsVC.settings)
                
                
                dismissKeyboard()
                //let destViewController = self.storyboard?.instantiateViewController(withIdentifier: "destView") as! BrowseProductsViewController
                
                let backItem = UIBarButtonItem()
                backItem.title = "Back"
                navigationItem.backBarButtonItem = backItem
                
                checkoutViewController.message = textFieldText
                checkoutViewController.feedItems = feedItems
                checkoutViewController.feedItems2 = feedItems2
                checkoutViewController.bCodeIndex = index
                
                
                
                self.navigationController?.pushViewController(checkoutViewController, animated: true)
                //self.navigationController?.pushViewController(destViewController, animated: true)
                
                self.seguePerformed = true
                
                //self.performSegue(withIdentifier: "sampleSegue", sender: self)
                
            }
            
        } else {
            //print("No apples here – sorry!")
            //print(textFieldText)
            //messageLabel.text = "Not a valid QRCode - sorry"
        }
    }
    

    
    
 
    
    


}

