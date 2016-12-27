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
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        let notificationCenter2 = NotificationCenter.default
        notificationCenter2.addObserver(self, selector: #selector(appMovedToForeGround), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
        
        
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
        
    }
    
    func appMovedToBackground() {
        print("App moved to background!")
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.downloadItems()

    }
    
    func appMovedToForeGround() {
        print("App moved to foreground!")
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.downloadItems()
        
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
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dismissKeyboard()
        seguePerformed = false
        ticketCodeField.text = nil
        
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.downloadItems()
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.downloadItems()
    }
    
     func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.downloadItems()

    }
    
    
    func itemsDownloaded(_ items: NSArray, _ items2: NSArray, _ items3: NSArray) {
        
        feedItems = items
        
        feedItems2 = items2
        
        feedItems3 = items3
    }
    
    
    @IBAction func ContinueButton(_ sender: AnyObject) {
        
        textFieldText = ticketCodeField.text!
        
        if feedItems3.contains(textFieldText) {
            let index = feedItems3.index(of: textFieldText)
            
            if !self.seguePerformed {
                
                
                let variable = (feedItems2[index] as AnyObject).description
                finalTotalInt = (Float(variable!)! + SERVICE_FEE)

                
                let checkoutViewController = CheckoutViewController(product: "Product Name",
                                                                    price: Int(finalTotalInt)*100,
                                                                    settings: self.settingsVC.settings)
                
                
                dismissKeyboard()

                let backItem = UIBarButtonItem()
                backItem.title = "Back"
                navigationItem.backBarButtonItem = backItem
                
                checkoutViewController.message = textFieldText
                checkoutViewController.feedItems = feedItems
                checkoutViewController.feedItems2 = feedItems2
                checkoutViewController.bCodeIndex = index
                
                
                
                self.navigationController?.pushViewController(checkoutViewController, animated: true)

                self.seguePerformed = true
                
                
            }
            
        } else {

        }
    }
    

    
    
 
    
    


}

