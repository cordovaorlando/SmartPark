//
//  RequestsViewController.swift
//  SmartPark
//
//  Created by Jose Cordova on 1/3/17.
//  Copyright © 2017 Jose Cordova. All rights reserved.
//

import UIKit

class RequestsViewController: UIViewController{
    
    @IBOutlet weak var totalDaily: UILabel!
    
    var locationID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UIApplication.shared.statusBarStyle = .default
        print(locationID)
        
        downloadData()
        

        
    }
    
    
    
    func downloadData(){
        
        
        
        var jsonElement: NSDictionary = NSDictionary()
        
        
        let myUrl = URL(string: "http://spvalet.com/DailyReport.php");
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
                
                
                var tipsTotalArray = [String]()
                var pricesTotalArray = [String]()
                var idArrays = [String]()
                var locIdArray = [String]()
                
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
                
                
                print("Tips Total Array: " + tipsTotalArray.description)
                print("Restaurant Total Array: " + pricesTotalArray.description)
                print("Location Ids: " + locIdArray.description)
                print("Order Ids: " + idArrays.description)
                
                
            } catch {
                print(error)
                print("Something's bad!")
            }
            
            
        }
        task.resume()
        
        
        
        
    }




    
    
    
    
    
    
       
    
}
