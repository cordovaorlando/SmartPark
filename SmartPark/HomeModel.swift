//
//  HomeModel.swift
//  SmartPark
//
//  Created by Jose Cordova on 9/5/16.
//  Copyright © 2016 Jose Cordova. All rights reserved.
//

import Foundation

protocol HomeModelProtocal: class {
    func itemsDownloaded(_ items: NSArray, _ items2: NSArray, _ items3: NSArray)
}


class HomeModel: NSObject, URLSessionDataDelegate {
    
    //properties
    
    weak var delegate: HomeModelProtocal!
    
    var data : NSMutableData = NSMutableData()
    
    let urlPath: String = "http://spvalet.com/service.php"    
    var restaurantNamesArray = [String]()
    var restaurantPricesArray = [String]()
    var qrCodeArray = [String]()
    
    func downloadItems() {
        
        let url: URL = URL(string: urlPath)!
        var session: Foundation.URLSession!
        let configuration = URLSessionConfiguration.default
        
        
        session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        let task = session.dataTask(with: url)
        
        task.resume()
        
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.data.append(data);
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            print("Failed to download data")
        }else {
            self.parseJSON()
        }
    }
    
    
    func parseJSON() {
        
        var jsonResult: NSArray = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: self.data as Data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement: NSDictionary = NSDictionary()
        //let locations: NSMutableArray = NSMutableArray()
        
        for i in (0..<jsonResult.count){
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            
            if let id = jsonElement["ID"] as? String,
                let restaurantName = jsonElement["RestaurantName"] as? String,
                let qrCode = jsonElement["QRCode"] as? String,
                let price = jsonElement["Price"] as? String
            {

                
                restaurantNamesArray.append(restaurantName)
                restaurantPricesArray.append(price)
                qrCodeArray.append(qrCode)
                
            }
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.itemsDownloaded(self.restaurantNamesArray as NSArray, self.restaurantPricesArray as NSArray, self.qrCodeArray as NSArray)
          
        })
    }
    
    
}
