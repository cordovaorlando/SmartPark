//
//  AccountSettingsViewController.swift
//  SmartPark
//
//  Created by Jose Cordova on 1/3/17.
//  Copyright © 2017 Jose Cordova. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class AccountSettingsViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        if FIRAuth.auth()?.currentUser != nil {
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
        }
    }
    
    
    
    
    
    
    
}
