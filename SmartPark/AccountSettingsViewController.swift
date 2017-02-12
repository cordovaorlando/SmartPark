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
    var locationID2 = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Passed Data " + locationID)
        print("Thanks Jesus!! " + locationID2)

        
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
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogIn")
        present(vc, animated: true, completion: nil)

    }
    
    
    
    
    
    
    
}
