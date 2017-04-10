//
//  LoginViewController.swift
//  SmartPark
//
//  Created by Jose Cordova on 1/3/17.
//  Copyright © 2017 Jose Cordova. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController,UITextFieldDelegate  {
    
    var locationID = String()
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .default
        
        dismissKeyboard()
        
        self.emailTextField.delegate = self;
        self.passwordTextField.delegate = self;
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = nil
        passwordTextField.text = nil
        dismissKeyboard()
        
    }

    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func loginAction(_ sender: Any) {
        
        
        let userEmail = emailTextField.text!
        let userPassword = passwordTextField.text!

        
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
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    if let parseJSON = json {
                        // Now we can access value of First Name by its key
                        let resultValue = parseJSON["status"] as? String
                        let resultValue2 = parseJSON["message"] as? String
                        let resultValue3 = parseJSON["locationId"] as? String

                        if(resultValue == "Success"){
                        self.locationID = resultValue3!
   
                            OperationQueue.main.addOperation {
                                self.dismissKeyboard()
                                self.performSegue(withIdentifier: "finally", sender: self)
                            }
                            
                        }else{
                            
                            OperationQueue.main.addOperation {
                            let alertController = UIAlertController(title: "Error", message: "Incorrect Credentials", preferredStyle: .alert)
                            
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                            }
                        }
                        
                        
                    }
                } catch {
                    print(error)
                    print("Sorry, you need to register first!")
                }
            }
            task.resume()
            
            }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "finally" {
            
            let tabCtrl = segue.destination as! UITabBarController
            let destinationVC = tabCtrl.viewControllers![1] as! ReportTableViewController
            destinationVC.locationID = locationID
            
            let destinationVC2 = tabCtrl.viewControllers?[0] as! RequestTableViewController
            
            destinationVC2.locationID = locationID

        }
    }

    
}
