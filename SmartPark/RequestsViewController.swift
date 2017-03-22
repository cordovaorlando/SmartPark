//
//  RequestsViewController.swift
//  SmartPark
//
//  Created by Jose Cordova on 1/3/17.
//  Copyright © 2017 Jose Cordova. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging


class RequestsViewController: UIViewController{
    
    @IBOutlet weak var totalDaily: UILabel!
    
    var locationID = String()
    var token = String()
    weak var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // var token = FIRInstanceID.instanceID().token()
        print(locationID)
        token = FIRInstanceID.instanceID().token()!
        print(token)
        postData()
        //downloadData()
       // startTimer()
        
        

        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startTimer()
        
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: Selector("downloadData"), userInfo: nil, repeats: true)
        
    }
    
    
    func postData(){
        
        
        
       // var jsonElement: NSDictionary = NSDictionary()
        
        
        let myUrl = URL(string: "http://spvalet.com/tokens.php");
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"// Compose a query string
        //let postString = "email=\(userEmail)&password=\(userPassword)";
        let postString = "token=\(token)&locationID=\(locationID)";
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
    
    
    
    func downloadData(){
        
        
        
        var jsonElement: NSDictionary = NSDictionary()
        
        
        let myUrl = URL(string: "http://spvalet.com/request.php");
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"// Compose a query string
        //let postString = "email=\(userEmail)&password=\(userPassword)";
        let postString = "locationID=\(locationID)";
        request.httpBody = postString.data(using: String.Encoding.utf8);
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray
                
                
                var firstNameArray = [String]()
                var lastNameArray = [String]()
                var phoneNumberArray = [String]()
                var licensePlateArray = [String]()
                var makeArray = [String]()
                var modelArray = [String]()
                var colorArray = [String]()
                var priceArray = [String]()
                var tipArray = [String]()
                var ticketNumberArray = [String]()
                
                var sumOfTips = 0
                var sumOfSales = 0
                var finalTotal = 0
                
                for i in (0..<json!.count){
                    
                    jsonElement = json![i] as! NSDictionary
                    
                    
                    if let firstName = jsonElement["FirstName"] as? String,
                        let lastName = jsonElement["LastName"] as? String,
                        let phoneNumber = jsonElement["PhoneNumber"] as? String,
                        let licensePlate = jsonElement["LicensePlate"] as? String,
                        let make = jsonElement["Make"] as? String,
                        let model = jsonElement["Model"] as? String,
                        let color = jsonElement["Color"] as? String,
                        let price = jsonElement["Price"] as? String,
                        let tip = jsonElement["Tip"] as? String,
                        let ticketNumber = jsonElement["TicketNumber"] as? String
                    {
                        firstNameArray.append(firstName)
                        lastNameArray.append(lastName)
                        phoneNumberArray.append(phoneNumber)
                        licensePlateArray.append(licensePlate)
                        makeArray.append(make)
                        modelArray.append(model)
                        colorArray.append(color)
                        priceArray.append(price)
                        tipArray.append(tip)
                        ticketNumberArray.append(ticketNumber)
                    }
                }
                
                
                
                
                
                
                //finalTotal = (sumOfTips + sumOfSales)
                //self.tipsLabel.text = sumOfTips.description
                print("First Name: " + firstNameArray.description)
                print("Last Name : " + lastNameArray.description)
                print("Phone Number: " + phoneNumberArray.description)
                print("License Plate: " + licensePlateArray.description)
                print("Make: " + makeArray.description)
                print("Model: " + modelArray.description)
                print("Color: " + colorArray.description)
                print("Price: " + priceArray.description)
                print("Tip: " + tipArray.description)
                print("Ticket Number: " + ticketNumberArray.description)
                
                DispatchQueue.main.async(execute: { () -> Void in                    // Do stuff to UI
                    
                    
                   // self.salesLabel.text = "$" + sumOfSales.description + ".00"
                   // self.tipsLabel.text = "$" + sumOfTips.description + ".00"
                   // self.totalsLabel.text = "$" + finalTotal.description + ".00"
                    
                })
                
           /*     print("")
                print("Tips Total Array: " + tipsTotalArray.description)
                print("Restaurant Total Array: " + pricesTotalArray.description)
                print("Location Ids: " + locIdArray.description)
                print("Order Ids: " + idArrays.description)
                */
                
            } catch {
                print(error)
                print("Requests View Something's bad!")
            }
            
            
        }
        task.resume()
        
        
        
        
    }
    

    
    
    
    



    
    
    
    
    
    
       
    
}
