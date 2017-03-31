//
//  HomeScreen.swift
//  SmartPark
//
//  Created by Jose Cordova on 8/6/16.
//  Copyright © 2016 Jose Cordova. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

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
    
    var token = String()

    
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
        //FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
        //token = FIRInstanceID.instanceID().token()!
        //postToken()
        
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
        
        if self.ticketCodeField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your ticket number.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        }else{
            textFieldText = ticketCodeField.text!
            let index = textFieldText.index(textFieldText.startIndex, offsetBy: 1)
            var locationID = textFieldText.substring(to: index)
            let index2 = textFieldText.index(textFieldText.startIndex, offsetBy: 1)
            var ticketNumber = textFieldText.substring(from: index2)
            let myUrl = URL(string: "http://spvalet.com/locs.php");
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
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    if let parseJSON = json {
                        let resultValue = parseJSON["status"] as? String
                        let id = parseJSON["LocationID"] as? String
                        let restaurantName = parseJSON["LocationName"] as? String
                        let qrCode = parseJSON["TicketNumber"] as? String
                        let price = parseJSON["Price"] as? String
                        print("Status: \(resultValue!)")
                        if(resultValue == "Success"){
                            //self.locationID = resultValue3!
                            print("It Works yes, go in!")
                            self.LocationNamesString = restaurantName!
                            self.LocationPricesString = price!
                            self.qrCodeString = qrCode!
                            self.LocationIDString = id!
                            DispatchQueue.main.async(execute: { () -> Void in

                                self.finalTotalInt = (Float(self.LocationPricesString)! + self.SERVICE_FEE)
                                
                                let checkoutViewController = CheckoutViewController(product: "SmartPark",
                                                                                    price: Int(self.finalTotalInt)*100,
                                                                                    settings: self.settingsVC.settings)
                                self.dismissKeyboard()
                                checkoutViewController.message = self.qrCodeString
                                checkoutViewController.feedItems = self.LocationNamesString
                                checkoutViewController.feedItems2 = self.LocationPricesString
                                checkoutViewController.locationId = self.LocationIDString
                                self.navigationController?.pushViewController(checkoutViewController, animated: true)
                            })
                        }else{
                            
                            OperationQueue.main.addOperation {
                                let alertController = UIAlertController(title: "Error", message: "Invalid Ticket Number.", preferredStyle: .alert)
                                
                                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alertController.addAction(defaultAction)
                                
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    }
                } catch {
                    print(error)
                    print("Sorry, you need to register first!")
                }
            }
            task.resume()
        }
        
        
        
        
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
    
    @IBAction func handleLogTokenTouch(_ sender: UIButton) {
        // [START get_iid_token]
        let token = FIRInstanceID.instanceID().token()
        print("InstanceID token: \(token!)")
        ticketCodeField.text = token
        // [END get_iid_token]
    }
    
    @IBAction func handleSubscribeTouch(_ sender: UIButton) {
        // [START subscribe_topic]
        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
        print("Subscribed to news topic")
        // [END subscribe_topic]
    }
    
    
    func postToken(){
        
        
        let myUrl = URL(string: "http://spvalet.com/customerToken.php");
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"// Compose a query string
        let postString = "token=\(token)";
        request.httpBody = postString.data(using: String.Encoding.utf8);
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
        }
        task.resume()
        
    }

    
    
    
}

