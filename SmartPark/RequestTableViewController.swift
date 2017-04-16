//
//  RequestTableViewController.swift
//  SmartPark
//
//  Created by Jose Cordova on 3/22/17.
//  Copyright © 2017 Jose Cordova. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

class RequestTableViewController: UITableViewController {

    var locationID = String()
    var token = String()
    weak var timer: Timer?
    
    var orderIDArray = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    var ticketIDArray = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    var phoneNumberArray = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    var licensePlateArray = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    var makeArray = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    var modelArray = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    var colorArray = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    var priceArray = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    var tipArray = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    var ticketNumberArray = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var tokensArray = [String]()
    
    

    
    
    override func viewDidLoad() {
        token = FIRInstanceID.instanceID().token()!
        super.viewDidLoad()

        postData()
        print("View Did Load")
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.downloadData()
        super.viewWillAppear(animated)
        print("View Will Appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View Did Appear")
        
    }
    
    
    func reloadData(){
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.tableView.reloadData()
            print("reloadData function called")
        })
        
    }
    
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func postData(){
        

        let myUrl = URL(string: "http://spvalet.com/tokens.php");
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"
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
    
        
        self.orderIDArray.removeAll()
        self.ticketIDArray.removeAll()
        self.phoneNumberArray.removeAll()
        self.licensePlateArray.removeAll()
        self.makeArray.removeAll()
        self.modelArray.removeAll()
        self.colorArray.removeAll()
        self.priceArray.removeAll()
        self.tipArray.removeAll()
        self.ticketNumberArray.removeAll()

        

        var jsonElement: NSDictionary = NSDictionary()
        
        
        
        let myUrl = URL(string: "http://spvalet.com/request.php");
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"// Compose a query string
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

                for i in (0..<json!.count){
                    
                    jsonElement = json![i] as! NSDictionary
                    
                    
                 /*   if let firstName = jsonElement["FirstName"] as? String,
                        let lastName = jsonElement["LastName"] as? String,
                        let phoneNumber = jsonElement["PhoneNumber"] as? String,
                        let licensePlate = jsonElement["LicensePlate"] as? String,
                        let make = jsonElement["Make"] as? String,
                        let model = jsonElement["Model"] as? String,
                        let color = jsonElement["Color"] as? String,
                        let price = jsonElement["Price"] as? String,
                        let tip = jsonElement["Tip"] as? String,
                        let ticketNumber = jsonElement["TicketNumber"] as? String,
                        let tokenID = jsonElement["tokenID"] as? String
                    {
                */
                    
                    if let orderID = jsonElement["orderId"] as? String,
                        let price = jsonElement["Price"] as? String,
                        let tip = jsonElement["Tip"] as? String,
                        let ticketNumber = jsonElement["TicketNumber"] as? String,
                        let tokenID = jsonElement["tokenID"] as? String,
                        let ticketID = jsonElement["TicketID"] as? String
                    {
                        
                        
                        
                        self.orderIDArray.append(orderID)
                        self.ticketIDArray.append(ticketID)
                        //self.phoneNumberArray.append(phoneNumber)
                        //self.licensePlateArray.append(licensePlate)
                        //self.makeArray.append(make)
                        //self.modelArray.append(model)
                        //self.colorArray.append(color)
                        self.priceArray.append(price)
                        self.tipArray.append(tip)
                        self.ticketNumberArray.append(ticketNumber)
                        self.tokensArray.append(tokenID)
                        self.reloadData()
                        
                    
                    }
                }
                
                /*
                print("First Name: " + self.firstNameArray.description)
                print("Last Name : " + self.ticketIDArray.description)
                print("Phone Number: " + self.phoneNumberArray.description)
                print("License Plate: " + self.licensePlateArray.description)
                print("Make: " + self.makeArray.description)
                print("Model: " + self.modelArray.description)
                print("Color: " + self.colorArray.description)
                print("Price: " + self.priceArray.description)
                print("Tip: " + self.tipArray.description)
                print("Ticket Number: " + self.ticketNumberArray.description)
                print("TokenID: " + self.tokensArray.description)
                */


            } catch {
                print(error)
        }
            
            
        }
        task.resume()

    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Requests"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.orderIDArray.count
    }
    
    

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath)

        cell.textLabel?.text = "#" + self.ticketNumberArray[indexPath.row]
        //cell.detailTextLabel?.text = self.priceArray[indexPath.row] + " " + self.tipArray[indexPath.row] + " " +  self.firstNameArray[indexPath.row]
        
        cell.detailTextLabel?.text = ""
        
        return cell

    }
    

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let index = tableView.indexPathForSelectedRow?.row;

        if segue.identifier == "detail" {
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.orderID = orderIDArray[index!]
            //destinationVC.lastName = ticketIDArray[index!]
            //destinationVC.phoneNumber = phoneNumberArray[index!]
            //destinationVC.licensePlate = licensePlateArray[index!]
            //destinationVC.make = makeArray[index!]
            //destinationVC.model = modelArray[index!]
            //destinationVC.color = colorArray[index!]
            destinationVC.price = priceArray[index!]
            destinationVC.tip = tipArray[index!]
            destinationVC.ticketNumber = ticketNumberArray[index!]
            destinationVC.token = tokensArray[index!]
            destinationVC.ticketID = ticketIDArray[index!]
           
            
            
            
            
        }
    }

}
