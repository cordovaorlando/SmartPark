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
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // var token = FIRInstanceID.instanceID().token()
        print(locationID)
        token = FIRInstanceID.instanceID().token()!
        print(token)
        downloadData()
        

        
    }
    
    
    func downloadData(){
        
        
        
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
    
    
    
    



    
    
    
    
    
    
       
    
}
