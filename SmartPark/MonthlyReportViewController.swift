//
//  MonthlyReportViewController.swift
//  SmartPark
//
//  Created by Jose Cordova on 2/11/17.
//  Copyright © 2017 Jose Cordova. All rights reserved.
//

import UIKit

class MonthlyReportViewController : UIViewController{
    
    var locationID = String()
    var currentDate = Date()
    var year = String()
    var month = String()
    
    @IBOutlet weak var salesLabel: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var totalsLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 248.0/255, green: 146.0/255, blue: 35.0/255, alpha: 1.0)
        
        self.navigationItem.title = "Monthly Reports"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "MM"
        
        year = formatter.string(from: currentDate)
        month = formatter2.string(from: currentDate)
        
        print(year)
        print(month)
        
        downloadData()


    }
    
    
    func downloadData(){
        
        
        
        var jsonElement: NSDictionary = NSDictionary()
        
        
        let myUrl = URL(string: "http://spvalet.com/MonthlyReport.php");
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"// Compose a query string
        //let postString = "email=\(userEmail)&password=\(userPassword)";
        let postString = "month=\(month)&year=\(year)&locationID=\(locationID)";
        request.httpBody = postString.data(using: String.Encoding.utf8);
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray
                
                
                var tipsTotalArray = [String]()
                var pricesTotalArray = [String]()
                var idArrays = [String]()
                var locIdArray = [String]()
                var ticketsNumber = [String]()
                var orderDates = [String]()
                
                var sumOfTips = 0
                var sumOfSales = 0
                var finalTotal = 0
                
                for i in (0..<json!.count){
                    
                    jsonElement = json![i] as! NSDictionary
                    
                    
                    if let id = jsonElement["orderId"] as? String,
                        let totalTips = jsonElement["Tip"] as? String,
                        let totalPrices = jsonElement["Price"] as? String,
                        let locID = jsonElement["LocationID"] as? String,
                        let ticketNo = jsonElement["TicketNumber"] as? String,
                        let ordersDate = jsonElement["OrderDate"] as? String
                    {
                        tipsTotalArray.append(totalTips)
                        pricesTotalArray.append(totalPrices)
                        locIdArray.append(locID)
                        idArrays.append(id)
                        ticketsNumber.append(ticketNo)
                        orderDates.append(ordersDate)
                    }
                }
                
                
                for i in (0..<tipsTotalArray.count){
                    //sumOfTips += 2
                    sumOfTips  += (tipsTotalArray[i] as NSString).integerValue
                    sumOfSales += (pricesTotalArray[i] as NSString).integerValue
                    
                }
                
                
                
                
                finalTotal = (sumOfTips + sumOfSales)
                //self.tipsLabel.text = sumOfTips.description
                print("Tickets Number: " + ticketsNumber.description)
                print("Orders Date: " + orderDates.description)
                print("Tips: " + sumOfTips.description + ".00")
                print("Sales: " + sumOfSales.description + ".00")
                print("Total: " + finalTotal.description + ".00")
                
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    
                    self.salesLabel.text  = "$" + sumOfSales.description + ".00"
                    self.tipsLabel.text   = "$" + sumOfTips.description + ".00"
                    self.totalsLabel.text = "$" + finalTotal.description + ".00"
                    
                })
                
                print("")
                print("Tips Total Array: " + tipsTotalArray.description)
                print("Restaurant Total Array: " + pricesTotalArray.description)
                print("Location Ids: " + locIdArray.description)
                print("Order Ids: " + idArrays.description)
                
                
            } catch {
                print(error)
                print("DailyReport Something's bad!")
            }
            
        }
        task.resume()
        
    }
    
    
    @IBAction func monthly(_ sender: UIDatePicker) {
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "MM"
        
        year = formatter.string(from: sender.date)
        month = formatter2.string(from: sender.date)
        
        
        downloadData()
        
    }
    


    
}
