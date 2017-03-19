//
//  DailyReportViewController.swift
//  SmartPark
//
//  Created by Jose Cordova on 2/11/17.
//  Copyright © 2017 Jose Cordova. All rights reserved.
//

import UIKit

class DailyReportViewController : UIViewController{
    
    var locationID = String()
    
    @IBOutlet weak var salesLabel: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var totalsLabel: UILabel!
    
    var currentDate = Date()
    var date = String()
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 248.0/255, green: 146.0/255, blue: 35.0/255, alpha: 1.0)
        
        self.navigationItem.title = "Daily Reports"
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        date = formatter.string(from: currentDate)
        
        //print("'" + date + "'")

        downloadData()
        

        
    }
    
    
    
    func downloadData(){
        
        
        
        var jsonElement: NSDictionary = NSDictionary()
        
        
        let myUrl = URL(string: "http://spvalet.com/DailyReport.php");
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"// Compose a query string
      //let postString = "email=\(userEmail)&password=\(userPassword)";
        let postString = "date=\(date)&locationID=\(locationID)";
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
                
                var sumOfTips = 0
                var sumOfSales = 0
                var finalTotal = 0
                
                for i in (0..<json!.count){
                    
                    jsonElement = json![i] as! NSDictionary
                    
                    
                    if let id = jsonElement["orderId"] as? String,
                        let totalTips = jsonElement["Tip"] as? String,
                        let totalPrices = jsonElement["Price"] as? String,
                        let locID = jsonElement["LocationID"] as? String
                    {
                        tipsTotalArray.append(totalTips)
                        pricesTotalArray.append(totalPrices)
                        locIdArray.append(locID)
                        idArrays.append(id)
                    }
                }
                
                
                for i in (0..<tipsTotalArray.count){
                    //sumOfTips += 2
                    sumOfTips  += (tipsTotalArray[i] as NSString).integerValue
                    sumOfSales += (pricesTotalArray[i] as NSString).integerValue
                    
                }
                
            
                
               
                finalTotal = (sumOfTips + sumOfSales)
                //self.tipsLabel.text = sumOfTips.description
                print("Tips: " + sumOfTips.description + ".00")
                print("Sales: " + sumOfSales.description + ".00")
                print("Total: " + finalTotal.description + ".00")
                
                
                DispatchQueue.main.async(execute: { () -> Void in                    // Do stuff to UI
                
                
                self.salesLabel.text = "$" + sumOfSales.description + ".00"
                self.tipsLabel.text = "$" + sumOfTips.description + ".00"
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
    
    
    
    
    @IBAction func datePicker(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        date = formatter.string(from: sender.date)

        print(date)
        
        
        downloadData()

    }
    
    
    

    
    
}
