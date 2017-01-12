//
//  LoginViewController.swift
//  SmartPark
//
//  Created by Jose Cordova on 1/3/17.
//  Copyright © 2017 Jose Cordova. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .default

    }
    
    
    
    @IBAction func loginAction(_ sender: Any) {
        
        
        let userEmail = emailTextField.text!
        let userPassword = passwordTextField.text!
        
        //print(userEmail)
        //print(userPassword)
        
        
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }else{
            let myUrl = URL(string: "http://spvalet.com/userLogin.php");
            var request = URLRequest(url:myUrl!)
            request.httpMethod = "POST"// Compose a query string
            let postString = "email=\(userEmail)&password=\(userPassword)";
            request.httpBody = postString.data(using: String.Encoding.utf8);
            let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
    
                if error != nil
                {
                    print("error=\(error)")
                    return
                }// You can print out response object
                print("response = \(response!)")
                //Let's convert response sent from a server side script to a NSDictionary object:
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    if let parseJSON = json {
                        // Now we can access value of First Name by its key
                        let resultValue = parseJSON["status"] as? String
                        let resultValue2 = parseJSON["message"] as? String
                        //let resultValue2 = parseJSON["user_password"] as? String
                        print("Status: \(resultValue!)")
                        print("Message: \(resultValue2!)")
                        //print("firstNameValue: \(resultValue2)")
                        if(resultValue == "Success"){
                        print("It Works yes, go in!")
                       // self.dismiss(animated: true, completion:nil)
                            UserDefaults.standard.set(true, forKey:"isUserLoggedIn")
                            UserDefaults.standard.synchronize()
                            
                            //let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home")
                            //self.present(vc, animated: true, completion: nil)
   
                            OperationQueue.main.addOperation {
                                //self.presentViewController(vc, animated: true, completion: nil)
                                //Above line was generating same exception in my scenario
                                // I got it resolved by using NSOperationQueue.mainQueue().addOperationWithBlock {
                            
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                                self.present(vc!, animated: true, completion: nil)
                            }
                            
                       
                        }                    }
                } catch {
                    print(error)
                    print("Sorry, you need to register first!")
                }
            }
            task.resume()
            
            }
    }
    
}
