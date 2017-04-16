//
//  DetailReportViewController.swift
//  SmartPark
//
//  Created by Jose Cordova on 2/11/17.
//  Copyright © 2017 Jose Cordova. All rights reserved.
//

import UIKit

class DetailReportViewController : UIViewController{
    
    var locationID = String()
    
    var currentDate = Date()
    
    var startDate = String()
    var endDate = String()
    
    @IBOutlet weak var salesLabel: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var totalsLabel: UILabel!
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 248.0/255, green: 146.0/255, blue: 35.0/255, alpha: 1.0)
        
        self.navigationItem.title = "Detail Reports"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        startDate = formatter.string(from: currentDate)
        endDate = formatter.string(from: currentDate)
        downloadData()

    }
    
    func downloadData(){
    
        var jsonElement: NSDictionary = NSDictionary()
        
        
        let myUrl = URL(string: "http://spvalet.com/DetailReport.php");
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"// Compose a query string
        let postString = "startDate=\(startDate)&endDate=\(endDate)&locationID=\(locationID)";
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
                    sumOfTips  += (tipsTotalArray[i] as NSString).integerValue
                    sumOfSales += (pricesTotalArray[i] as NSString).integerValue
                    
                }
                
                finalTotal = (sumOfTips + sumOfSales)
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    self.salesLabel.text  = "$" + sumOfSales.description + ".00"
                    self.tipsLabel.text   = "$" + sumOfTips.description + ".00"
                    self.totalsLabel.text = "$" + finalTotal.description + ".00"
                    
                })

            } catch {
                print(error)
            }
            
        }
        task.resume()
        
    }
    
    
    
    @IBAction func startDate(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        startDate = formatter.string(from: sender.date)
        downloadData()

    }
    
    
    @IBAction func endDate(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        endDate = formatter.string(from: sender.date)
        downloadData()
    }
    


}
    
    
