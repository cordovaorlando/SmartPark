//
//  HomeScreen.swift
//  SmartPark
//
//  Created by Jose Cordova on 8/6/16.
//  Copyright © 2016 Jose Cordova. All rights reserved.
//

import UIKit

class HomeScreen: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var ticketCodeField: UITextField!
    
    let settingsVC = SettingsViewController()
    
    var seguePerformed = false
    //var feedItems: NSArray = NSArray()
    //var feedItems2: NSArray = NSArray()
    //var feedItems3: NSArray = NSArray()
    var textFieldText = String()
    
    var finalTotalInt = Float()
    var SERVICE_FEE:Float = 2.00
    
    var LocationNamesArray = String()
    var LocationPricesArray = String()
    var qrCodeArray = String()
    var LocationIDArray = String()
    
    var LocationNamesString = String()
    var LocationPricesString = String()
    var qrCodeString = String()
    var LocationIDString = String()

    @IBAction func testButton(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        let notificationCenter2 = NotificationCenter.default
        notificationCenter2.addObserver(self, selector: #selector(appMovedToForeGround), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
        
        
        dismissKeyboard()
      //  let homeModel = HomeModel()
      //  homeModel.delegate = self
      //  homeModel.downloadItems()
        
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
        
      //  let homeModel = HomeModel()
     //   homeModel.delegate = self
     //   homeModel.downloadItems()

    }
    
    func appMovedToForeGround() {
        print("App moved to foreground!")
     //   let homeModel = HomeModel()
   //     homeModel.delegate = self
   //     homeModel.downloadItems()
        
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
        
     //   let homeModel = HomeModel()
    //    homeModel.delegate = self
    //    homeModel.downloadItems()
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     //   let homeModel = HomeModel()
     //   homeModel.delegate = self
     //   homeModel.downloadItems()
    }
    
     func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     //   let homeModel = HomeModel()
     //   homeModel.delegate = self
     //   homeModel.downloadItems()

    }
    
    
   /* func itemsDownloaded(_ items: NSArray, _ items2: NSArray, _ items3: NSArray) {
        
        feedItems = items
        
        feedItems2 = items2
        
        feedItems3 = items3
    }*/
    
    
    func downloadData(){
        
        /*  textFieldText = ticketCodeField.text!
         
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
         
         }*/
        
        var jsonElement: NSDictionary = NSDictionary()
        
        textFieldText = ticketCodeField.text!
        
        let index = textFieldText.index(textFieldText.startIndex, offsetBy: 1)
        var locationID = textFieldText.substring(to: index)
        
        
        let index2 = textFieldText.index(textFieldText.startIndex, offsetBy: 1)
        var ticketNumber = textFieldText.substring(from: index2)
        
        
        
        let myUrl = URL(string: "http://spvalet.com/Locations.php");
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"// Compose a query string
        let postString = "id=\(locationID)&ticket=\(ticketNumber)";
        request.httpBody = postString.data(using: String.Encoding.utf8);
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            // You can print out response object
            // print("response = \(response!)")
            //Let's convert response sent from a server side script to a NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray
                
                jsonElement = json?[0] as! NSDictionary
                
                if let id = jsonElement["LocationID"] as? String,
                    let restaurantName = jsonElement["LocationName"] as? String,
                    let qrCode = jsonElement["TicketNumber"] as? String,
                    let price = jsonElement["Price"] as? String
                    
                {
                    //  self.LocationNamesArray.append(restaurantName)
                    //  self.LocationPricesArray.append(price)
                    //  self.qrCodeArray.append(qrCode)
                    //  self.LocationIDArray.append(id)
                    
                    self.LocationNamesString = restaurantName
                    self.LocationPricesString = price
                    self.qrCodeString = qrCode
                    self.LocationIDString = id
                    
                    
                    
                    
                    //  self.pushToCheckOut()
                    
                    
                }
                
                print("Location Name:\(self.LocationNamesString)")
                print("Location Price: \(self.LocationPricesString)")
                print("Ticket Number: \(self.qrCodeString)")
                print("Location ID: \(self.LocationIDString)")
                print()
                
//                self.performSegue(withIdentifier: "continueButton", sender: self)
                
                
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    //let variable = (feedItems2[index] as AnyObject).description
                    self.finalTotalInt = (Float(self.LocationPricesString)! + self.SERVICE_FEE)
                    
                    let checkoutViewController = CheckoutViewController(product: "SmartPark",
                                                                        price: Int(self.finalTotalInt)*100,
                                                                        settings: self.settingsVC.settings)
                    
                    self.dismissKeyboard()
                    
                    print("Test inside the if statement")
                    
                    checkoutViewController.message = self.qrCodeString
                    checkoutViewController.feedItems = self.LocationNamesString
                    checkoutViewController.feedItems2 = self.LocationPricesString
                    checkoutViewController.locationId = self.LocationIDString
                    //checkoutViewController.bCodeIndex = index
                    
                    
                    
                    self.navigationController?.pushViewController(checkoutViewController, animated: true)
                    
                    //seguePerformed = true;
                    

                    
                 
                    
                })
              
                
                
                

                
                
            } catch {
                print(error)
                print("Home Screen Something's bad!")
            }
            
            
        }
        task.resume()
        
        
        
        
        
    }

    
    
    @IBAction func ContinueButton(_ sender: AnyObject) {
        
        downloadData()
        
        
    }
    
    
    
    
    
    func pushToCheckOut(){
        
        
        if !self.seguePerformed {
            
        let checkoutViewController = CheckoutViewController(product: "SmartPark",
                                                            price: 100,
                                                            settings: self.settingsVC.settings)
        
        
        print("Test inside the if statement")
        
        checkoutViewController.message = self.qrCodeString
        checkoutViewController.feedItems = self.LocationNamesString
        checkoutViewController.feedItems2 = self.LocationPricesString
        //checkoutViewController.bCodeIndex = index
        
        
        
        self.navigationController?.pushViewController(checkoutViewController, animated: true)
         
            seguePerformed = true;
            
        }

    }
    
    
    
}

