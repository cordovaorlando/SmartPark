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
    
    //var firstNameArray = [String]()
    /*var lastNameArray = [String]()
    var phoneNumberArray = [String]()
    var licensePlateArray = [String]()
    var makeArray = [String]()
    var modelArray = [String]()
    var colorArray = [String]()
    var priceArray = [String]()
    var tipArray = [String]()
    var ticketNumberArray = [String]()*/
    
    
    var firstNameArray = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    var lastNameArray = [String]() {
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
        downloadData()
        super.viewDidLoad()
        // var token = FIRInstanceID.instanceID().token()
        print(locationID)
        
        print(token)
        postData()
        

        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //DispatchQueue.main.async(execute: { () -> Void in
            //self.downloadData()
          //  print("View Did Load")
        
        //print("View will Appear")
        //downloadData()
        //self.tableView.reloadData()
        //timer?.invalidate()
        
        //})
    }
    
    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)
        //DispatchQueue.main.async(execute: { () -> Void in
        //    self.downloadData()
            
       // })
       // self.tableView.reloadData()
        //startTimer()
        
    
    }
    
        

        
        //
        
    
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(RequestTableViewController.downloadData), userInfo: nil, repeats: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        
        
        self.firstNameArray.removeAll()
        self.lastNameArray.removeAll()
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
                        let ticketNumber = jsonElement["TicketNumber"] as? String,
                        let tokenID = jsonElement["tokenID"] as? String
                    {

                        
                        
                        
                        self.firstNameArray.append(firstName)
                        self.lastNameArray.append(lastName)
                        self.phoneNumberArray.append(phoneNumber)
                        self.licensePlateArray.append(licensePlate)
                        self.makeArray.append(make)
                        self.modelArray.append(model)
                        self.colorArray.append(color)
                        self.priceArray.append(price)
                        self.tipArray.append(tip)
                        self.ticketNumberArray.append(ticketNumber)
                        self.tokensArray.append(tokenID)
                    
                    }
                }
                
                
                
                
                
                
                //finalTotal = (sumOfTips + sumOfSales)
                //self.tipsLabel.text = sumOfTips.description
                print("First Name: " + self.firstNameArray.description)
                print("Last Name : " + self.lastNameArray.description)
                print("Phone Number: " + self.phoneNumberArray.description)
                print("License Plate: " + self.licensePlateArray.description)
                print("Make: " + self.makeArray.description)
                print("Model: " + self.modelArray.description)
                print("Color: " + self.colorArray.description)
                print("Price: " + self.priceArray.description)
                print("Tip: " + self.tipArray.description)
                print("Ticket Number: " + self.ticketNumberArray.description)
                print("TokenID: " + self.tokensArray.description)
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Requests"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.firstNameArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath)
        

        //cell = UITableViewCell(style: UITableViewCellStyle.subtitle,
                              // reuseIdentifier: "id")
        cell.textLabel?.text = self.ticketNumberArray[indexPath.row]
        cell.detailTextLabel?.text = self.colorArray[indexPath.row] + " " + self.makeArray[indexPath.row] + " " +  self.modelArray[indexPath.row]
        
        //cell.backgroundColor = UIColor.red
        //cell.backgroundColor = color(red: 135, green: 223, blue: 238, alpha: 0)
        //cell.textLabel?.font = UIFont(name: "Georgia-BoldItalic", size: 18.0)
        
        return cell

    }
    

    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let index = tableView.indexPathForSelectedRow?.row;

        if segue.identifier == "detail" {
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.firstName = firstNameArray[index!]
            destinationVC.lastName = lastNameArray[index!]
            destinationVC.phoneNumber = phoneNumberArray[index!]
            destinationVC.licensePlate = licensePlateArray[index!]
            destinationVC.make = makeArray[index!]
            destinationVC.model = modelArray[index!]
            destinationVC.color = colorArray[index!]
            destinationVC.price = priceArray[index!]
            destinationVC.tip = tipArray[index!]
            destinationVC.ticketNumber = ticketNumberArray[index!]
            destinationVC.token = tokensArray[index!]
            
            
            
            
        }
    }

}
