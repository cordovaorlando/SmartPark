//
//  AccountSettingsViewController.swift
//  SmartPark
//
//  Created by Jose Cordova on 1/3/17.
//  Copyright © 2017 Jose Cordova. All rights reserved.
//

import UIKit



class AccountSettingsViewController: UIViewController{
    
    var locationID = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(locationID)
        downloadData()

        
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 248.0/255, green: 146.0/255, blue: 35.0/255, alpha: 1.0)
    }
    
    @IBAction func logOutAction(_ sender: Any) {
       /* if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogIn")
                present(vc, animated: true, completion: nil)
                
                //let vc = self.storyboard?.instantiateViewController(withIdentifier: "VC2")
                //self.present(vc!, animated: true, completion: nil)
               //self.navigationController?.popToRootViewController(animated: true)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }*/
        
        navigationController?.popViewController(animated: true)
        
        //let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogIn")
        //present(vc, animated: true, completion: nil)

    }
    
    
    
    func downloadData(){
        
        var jsonElement: NSDictionary = NSDictionary()
        
        let myUrl = URL(string: "http://spvalet.com/settings.php");
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
                
                var UsernameArray = String()
                var locNameArray = String()
                var locStreetArray = String()
                var locCityArray = String()
                var locStateArray = String()
                var locZipArray = String()
                var locPhoneArray = String()
                var valetNameArray = String()
                var valetStreetArray = String()
                var valetCityArray = String()
                var valetStateArray = String()
                var valetZipArray = String()
                var valetPhoneArray = String()
                
                for i in (0..<json!.count){
                    
                    jsonElement = json![i] as! NSDictionary
                    
                    
                    if let username = jsonElement["Username"] as? String,
                        let locName = jsonElement["LocationName"] as? String,
                        let locStreet = jsonElement["LocationStreet"] as? String,
                        let locCity = jsonElement["LocationCity"] as? String,
                        let locState = jsonElement["LocationState"] as? String,
                        let locZip = jsonElement["LocationZip"] as? String,
                        let locPhone = jsonElement["LocationPhone"] as? String,
                        let valetName = jsonElement["ValetName"] as? String,
                        let valetStreet = jsonElement["ValetStreet"] as? String,
                        let valetCity = jsonElement["ValetCity"] as? String,
                        let valetState = jsonElement["ValetState"] as? String,
                        let valetZip = jsonElement["ValetZip"] as? String,
                        let valetPhone = jsonElement["ValetPhone"] as? String
                        
                    {
                        UsernameArray = username
                        locNameArray = locName
                        locStreetArray = locStreet
                        locCityArray = locCity
                        locStateArray = locState
                        locZipArray = locZip
                        locPhoneArray = locPhone
                        valetNameArray = valetName
                        valetStreetArray = valetStreet
                        valetCityArray = valetCity
                        valetStateArray = valetState
                        valetZipArray = valetZip
                        valetPhoneArray = valetPhone
                        
                        
                    }
                }
                

                
     
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    print(UsernameArray)
                    print(locNameArray)
                    print(locStateArray)
                    print(locCityArray)
                    print(locStateArray)
                    print(locZipArray)
                    print(locPhoneArray)
                    print(valetNameArray)
                    print(valetStreetArray)
                    print(valetCityArray)
                    print(valetStateArray)
                    print(valetZipArray)
                    print(valetPhoneArray)
                    

                    
                })
                
            } catch {
                print(error)
            }
            
        }
        task.resume()
        
    }
    

    
}
